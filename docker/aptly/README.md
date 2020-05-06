# Using Aptly

## Mirroring a site
```
gpg --generate-key
gpg --list-secret-keys
```

To generate entropy dodrung the creatin of the key
```
while true; do cat /proc/sys/kernel/random/entropy_avail; dd bs=100M count=1 if=/dev/zero of=/tmp/foo conv=fdatasync; done
```

```
root@fa36340221ce:/# gpg --list-secret-keys
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
gpg: next trustdb check due at 2022-05-05
/root/.gnupg/pubring.kbx
------------------------
sec   rsa3072 2020-05-05 [SC] [expires: 2022-05-05]
      D310E5B59CAA15DBCF68ED57E793938EA1C15A28
uid           [ultimate] new-relic <kk@kk.es>
ssb   rsa3072 2020-05-05 [E] [expires: 2022-05-05]
```

GPG
```
curl -s https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg |  apt-key add -
gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver pool.sks-keyservers.net --recv-keys <GPG KEY EX: BB29EE038ECCE87C>
```

```
aptly mirror create <name> <archive url> <distribution> [<component1> ...]
aptly mirror create  newrelic https://download.newrelic.com/infrastructure_agent/linux/apt/ bionic main
```

Download remote repo contents
```
aptly mirror update newrelic
```
```
aptly repo import new-relic https://download.newrelic.com/infrastructure_agent/linux/apt/
```
Show contents of the mirror
```
aptly mirror show newrelic
```
Create local repo
```
aptly repo create localnewrelic
```
Import from the mirror to local repo
```
aptly repo import <src-mirror> <dst-repo> <package-query> ...
aptly repo import newrelic localnewrelic 'nrjmx'
aptly repo import newrelic localnewrelic 'nri-vsphere'
aptly repo import newrelic localnewrelic 'nri-kafka'
```
Create snapshot
```
aptly snapshot create snap-newrelic from repo localnewrelic
```
Export GPG from old repo to the mirror
https://ahelpme.com/linux/aptly-mirror-gpgv-cant-check-signature-public-key-not-found/

Create GPG signing key
```
gpg --default-new-key-algo rsa4096 --gen-key --keyring pubring.gpg
gpg --list-keys --keyring pubring.gpg
gpg --list-keys
```
Delete GPG key:
```
gpg --delete-secret-keys "newrelic"
gpg --delete-key "newrelic"
```


Publish snasphot to local filesystem (we need the GPG sining key)
```
aptly publish snapshot --distribution="bionic" snap-newrelic
```
```
gpg --default-new-key-algo rsa4096 --gen-key --keyring pubring.gpg
```
# S3 publish
export AWS_ACCESS_KEY_ID="XXXXXXXX" AWS_SECRET_ACCESS_KEY="YYYYYYYYYYYY"

In aptly.conf add:
```
"S3PublishEndpoints": {
    "nr-repo-apt": {
      "region": "us-east-1",
      "bucket": "nr-repo-apt",
      "prefix": "apt",
      "acl": "public-read",
      "storageClass": "",
      "encryptionMethod": "",
      "plusWorkaround": false,
      "disableMultiDel": false,
      "forceSigV2": false,
      "debug": false
    }
}
```    
Publish to S3           
```
aptly publish snapshot --distribution="bionic" --skip-signing snap-newrelic s3:nr-repo-apt:
```
Add package
```
aptly repo add <name> <package file>|<directory> ...
aptly repo add localnewrelic nri-jmx_0.0.1-1_amd64.deb
```
Recreate snapshot
```
aptly snapshot create snapshot-newrelic-$(date +"%Y-%m-%d_%H-%M-%S") from repo localnewrelic
```

Update published repo in S3
```
aptly publish switch --skip-signing bionic s3:nr-repo-apt: snapshot-newrelic-2020-05-05_17-00-56
```
