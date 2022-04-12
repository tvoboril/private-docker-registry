# Private Docker Registry

This is a project to use the official docker registry 2 image to create a private docker registry with an Amazon S3 backend with a Redis Cache.  This does not cover ingress etc into a cluster.  I would suggest using an nginx load balancer with cert-manager and acme certs so you don't have think about it much.


## Simple Deployment
To deploy a single node private docker registry (port 5000) with an Amazon S3 backend and a Redis cache on a Kubernetes Cluster:


1. Install dependences
    * htpasswd (comes with apache)
    * base64
    * make
    * kubectl
2. Configure S3 [(See below)](https://github.com/tvoboril/private-docker-registry#setting-up-amazon-s3)
3. Have a k8s cluster and make sure you are in the right context!
4. Run `./configure` (or `make config`)


    ```
    S3 Access Key ID?
    S3 Bucket (NAME Only)?
    S3 Region?
    S3 Secret Key?
    HTTP Token (used internally can be anything)?
    
    Registry User?
    Registry Password?
    ```
    * This will create the `registry-secrets.yaml` file alternately you can edit the `registry-secrets.template` file and rename it `registry-secrets.yaml`
    * This will also create the appropriately formated htpasswd file and encode it to base64
5. (Optional) run `make adduser` to add additional users to the htpasswd file
6. Run `make deploy`
    * Create the `registry` namespace
    * Deploy secrets
    * Deploy ... Deployment (with configMaps, etc)
    * Display resources

## Cleanup
* `make teardown`
    * This will DELETE the `registry` namespace please make sure you are not using it for anything else...

## Testing
* `make nodeports` will create nodeports for the the registry on 30500 and for the Redis cache.  Test acces with http://localhost:30500/v2/_catalog
* `make restart` will restart the registry and cache pods
* `make stats` will get all resources for this project
* `make alllogs` will print the logs for the registry and the cache
* `make reglogs` will watch the registry logs
* `make cachelogs` will watch the Redis Cache logs 






## Setting Up Amazon S3

1. Create S3 Bucket
2. Create IAM Policy per [Docker Documentation](https://docs.docker.com/registry/storage-drivers/s3/#s3-permission-scopes)
    * Note the *S3_BUCKET_NAME* needs to match your new bucket
3. Create service user with the created IAM Policy

```javascript
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads"
      ],
      "Resource": "arn:aws:s3:::S3_BUCKET_NAME"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": "arn:aws:s3:::S3_BUCKET_NAME/*"
    }
  ]
}
```
