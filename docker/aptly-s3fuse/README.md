Secrets manager, create key
REGION='us-east-1'
aws secretsmanager create-secret --region $REGION --name gpg_private_key  --description "GPG private key" --secret-string Elquesigui


aws ssm put-parameter \
        --name "gpg_private_key" \
        --type String \
        --description "GPG private key" \
        --value "$(cat gpg_private_key.gpg)"


```
docker run  -it  --privileged \
  -e AWS_ACCESS_KEY_ID=XXXXXXX \
  -e AWS_SECRET_ACCESS_KEY='XXXXXXX' \
  -e AWS_STORAGE_BUCKET_NAME='nr-aptly-backend' \
  -e AWS_S3_MOUNTPOINT='/mnt/aptly' \
  jportasa/aptly-s3fuse:1.0 bash -c "ls /mnt/aptly"
```


# Aptly

curl -s https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg |  apt-key add -
wget -O - https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | gpg --no-default-keyring --keyring trustedkeys.gpg --import
gpg --no-default-keyring --keyring /etc/apt/trusted.gpg --export | gpg --no-default-keyring --keyring trustedkeys.gpg --import
------
Create a mirror:
    aptly mirror create -architectures="amd64" -filter='nri-nginx' -ignore-signatures bionic-main https://download.newrelic.com/infrastructure_agent/linux/apt bionic main
    aptly mirror update -ignore-signatures bionic-main
------
Create local repo from the mirror
    aptly repo create bionic-main
------
Copy mirror to local repo
    aptly repo import bionic-main bionic-main nri-nginx
------
Publish repo 
    aptly publish repo -distribution="bionic" bionic-main s3:nr-repo-apt:
--GPG----
Create private key
    gpg --full-generate-key
or export:
    gpg --list-secret-keys 
    gpg --export -a KEYNAME > public.key
    gpg --export-secret-key -a KEYNAME > private.key
import
    gpg --import private.key    
------
Add package to repo
    GITHUB_RELEASE_DEB_URL=
    NEW_DEB='nri-memcached_0.1.0-1_amd64.deb'
    wget -q https://download.newrelic.com/infrastructure_agent/linux/apt/pool/main/n/nri-memcached/$NEW_DEB
    aptly repo add bionic-main ./$NEW_DEB
------
Update the current publish
    aptly publish update  bionic s3:nr-repo-apt:

