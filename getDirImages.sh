#/bin/bash
set -x

Repository_Path="XXX-Generic-Dev-Local/EBase/FG-resource-off/unPassImage/"
url="https://resource.XXXX.com/artifactory/"
apiurl="api/storage/"

num1=$(curl -u AAA:AAA $url$apiurl$Repository_Path |jq '.children'|grep uri|wc -l)
echo "共 $num1 个镜像需要下载"

for filename in $(curl -u AAA:AAA $url$apiurl$Repository_Path |jq '.children'|grep uri|awk '{ print $2}'|sed "s/\"//g"|sed "s/\///g"|sed "s/\,//g" ); 
do
	echo "下载第$num1个镜像："$filename;
	wget --user AAA --password AAA $url$Repository_Path$filename;
done

