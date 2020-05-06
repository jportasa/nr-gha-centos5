# Using Aptly

## Mirroring a site


GPG


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


