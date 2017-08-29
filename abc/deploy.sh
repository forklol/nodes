#!/bin/sh

echo "Building docker container"
docker build -t nodes-abc:$1 .

echo "Tagging container for GCE"
docker tag nodes-abc:$1 eu.gcr.io/splendid-sled-172714/nodes-abc:$1

echo "Pushing container to GCE"
gcloud docker -- push eu.gcr.io/splendid-sled-172714/nodes-abc:$1

echo "Replacing kube deployment"
sed -i -E "s/nodes-abc:v(.*)/nodes-abc:$1/g" ./deploy.yaml
kubectl replace -f ./deploy.yaml
