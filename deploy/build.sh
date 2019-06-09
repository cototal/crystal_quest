export OLD_VERSION=`cat deploy/version.txt`
export NEW_VERSION=`expr $OLD_VERSION + 1`
echo $NEW_VERSION > deploy/version.txt
export IMG_NAME=polysphere/crystal_quest:$NEW_VERSION
docker build -t $IMG_NAME .
docker push $IMG_NAME
sed -i -e "s=image.*=image: $IMG_NAME=g" deploy/docker-compose.yml
