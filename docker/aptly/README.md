# Using Aptly, an publish to S3
gpg --full-generate-key
gpg --list-secret-keys

Create the GPG Key and import

Summarizing, this seems to work as workaround on Debian stretch:

Install gpgv1 and gnupg1
Exporting gpg2 keys + importing into gpg1 .

apt install gpgv1 gnupg1
gpg --output gpg2_exported_pub.gpg --armor --export 7DA52876FB5775DF19A3F17CC1606483B0848116
gpg --output gpg2_exported_sec.gpg --armor --export-secret-key 7DA52876FB5775DF19A3F17CC1606483B0848116


Download remote repo contents
```
wget -O - https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | gpg --no-default-keyring --keyring trustedkeys.gpg --import
```
```
aptly mirror create \
    -architectures=amd64 \
    -filter="nri-apache" \
    -filter-with-deps \
    mirror-newrelic \
    https://download.newrelic.com/infrastructure_agent/linux/apt bionic main
```
You can run 'aptly mirror update mirror-newrelic' to download repository contents

Create local repo
```
aptly repo create local-newrelic
```
Import from the mirror to local repo
```
aptly repo import <src-mirror> <dst-repo> <package-query> ...
aptly repo import mirror-newrelic local-newrelic 'nri-apache' -with-deps -architectures "amd64"
aptly repo import mirror-newrelic local-newrelic 'nri-vsphere'
aptly repo import mirror-newrelic local-newrelic 'nri-kafka'
```
Create snapshot
```
aptly snapshot create \
    snapshot-newrelic-$(date +"%Y-%m-%d_%H-%M-%S") \
    from repo local-newrelic
```
Publish to S3 from snapshot
```
aptly publish snapshot \
    --gpg-key="7DA52876FB5775DF19A3F17CC1606483B0848116" \
    --distribution="bionic"  \
    snapshot-newrelic-2020-05-07_08-50-05 \
    s3:nr-repo-apt: 
```
Add package
```
aptly repo add <name> <package file>|<directory> ...
aptly repo add local-newrelic nri-jmx_0.0.1-1_amd64.deb
```

Update published repo in S3
```
aptly publish switch  bionic s3:nr-repo-apt: snapshot-newrelic-2020-05-06_16-37-36
```

Customer side

From a clean Ubuntu bionic:
```
curl -s http://nr-repo-apt.s3-website-us-east-1.amazonaws.com/apt/public.gpg |  apt-key add -
printf "deb [arch=amd64] http://nr-repo-apt.s3-website-us-east-1.amazonaws.com/apt bionic main" |  tee -a /etc/apt/sources.list.d/newrelic-infra.list
apt-get update
root@53e63545b69f:/# apt-cache search nri-apache
nri-apache - New Relic Infrastructure apache Integration extend the core New Relic
```
