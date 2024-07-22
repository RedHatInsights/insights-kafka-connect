#! /bin/sh

ORG=${ORG:="RedHatInsights"}
REPO=${REPO:="inventory-syndication"}
TOKEN=${1}
TAG=${2}
FILE=${3}

AUTH="Authorization: token ${TOKEN}"

# Obtain the download URL using github API
URL=$(curl -H "$AUTH" "https://api.github.com/repos/${ORG}/${REPO}/releases/tags/${TAG}" | python -c "import sys, json; print(list(filter(lambda x:x['name']=='$FILE', json.load(sys.stdin)['assets']))[0]['url'])")

curl -J -L -H "$AUTH" -H 'Accept: application/octet-stream' $URL
