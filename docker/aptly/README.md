# Using Aptly

## Mirroring a site


GPG

Exportar clau privada:
```
gpg2 --export-secret-keys --armor joankey > joankey-privkey.asc
```
root@66a5549bcd1e:/# cat joankey-privkey.asc
-----BEGIN PGP PRIVATE KEY BLOCK-----

lQIGBF6ysKEBBAChaEtI3TTu9tN+Jm0VKQB7M/eefY7cTEf/NT/FrcogK+xiojqe
r4Sk4xfgRD3PH4v5FX2xu9ZG3v1Y4MvaOQQZDcNWFQMe+WlwB0ZggbWDfV9IP6EP
XXXXXXXXXXXXXXXXXXXXXX
-----END PGP PRIVATE KEY BLOCK-----

Importar clau privada:
```
gpg --import --batch private.key joankey-privkey.asc
```
Importo clau publica reop oficial de newrelic (no em funciona!!!!!!) 
he acabat actvant a aptly.conf el gpgDisableVerify




Download remote repo contents
```
aptly mirror update mirror-newrelic
```
```
aptly repo import new-relic https://download.newrelic.com/infrastructure_agent/linux/apt/
```
Show contents of the mirror
```
aptly mirror show mirror-newrelic
```
Downlod mirror
```
aptly -architectures="amd64" mirror create mirror-newrelic https://download.newrelic.com/infrastructure_agent/linux/apt bionic main
aptly -architectures="amd64" mirror create mirror-newrelic https://download.newrelic.com/infrastructure_agent/linux/apt xenial main
```

Create local repo
```
aptly repo create local-newrelic
aptly repo show local-newrelic
```
Import from the mirror to local repo
```
aptly repo import <src-mirror> <dst-repo> <package-query> ...
aptly repo import mirror-newrelic local-newrelic 'nrjmx'
aptly repo import mirror-newrelic local-newrelic 'nri-vsphere'
aptly repo import mirror-newrelic local-newrelic 'nri-kafka'

```
Create snapshot
```
aptly snapshot create snapshot-newrelic-$(date +"%Y-%m-%d_%H-%M-%S") from repo local-newrelic
```

# S3 publish snapshot
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
Publish to S3 from repo          
```
aptly publish repo --distribution="bionic" local-newrelic s3:nr-repo-apt: 
```

Publish to S3 from snapshot
```
aptly publish snapshot --distribution="bionic"   snapshot-newrelic-2020-05-06_16-36-20 s3:nr-repo-apt: 
```
Add package
```
aptly repo add <name> <package file>|<directory> ...
aptly repo add local-newrelic nri-jmx_0.0.1-1_amd64.deb
```
Recreate snapshot
```
aptly snapshot create snapshot-newrelic-$(date +"%Y-%m-%d_%H-%M-%S") from repo local-newrelic
```

Update published repo in S3
```
aptly publish switch  bionic s3:nr-repo-apt: snapshot-newrelic-2020-05-06_16-37-36
```


