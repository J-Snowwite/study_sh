#/bin/bash
#set -x

for image_name in `cat nameList`
do
	md5=$(curl -u AAA:AAA http://resource.XXX.com/artifactory/api/storage/xxx-Generic-Dev-Local/EBase/FG-resource-off/unPassImage/debian11_base_en.raw|jq '.checksums.md5'|sed 's/\"//g');
	echo $image_name $md5;
done
