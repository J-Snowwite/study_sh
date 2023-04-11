#/bin/bash
set -x

#加载环境变量
source /etc/kolla/admin-openrc.sh
rm -f md5Info.txt;

url="http://resource.xxx.com:8081/artifactory/xxx-Generic-Dev-Local/EBase/FG-resource/base%20image/"
##标准库路径
#url="http://resource.xxx.com:8081/artifactory/xxx-Generic-Dev-Local/EBase/FG-resource/scene/%E5%AE%89%E5%85%A8%E9%98%B2%E5%BE%A1%E8%AE%BE%E5%A4%87/images/"
##场景-安全设备
#url="http://resource.xxx.com:8081/artifactory/xxx-Generic-Dev-Local/EBase/FG-resource-off/unPassImage/"
##还未检测的镜像

for image_name in `cat list`
do
#循环开始
	image_id=`openstack image list |grep $image_name|awk '{ print $2}'`
        glance image-download $image_id --file $image_name --progress;
	md5=`curl -v -u 'AAA:AAA' -T $image_name $url$image_name | grep md5|awk '{ print $3}'|sed "s/\"//g"|sed "s/\,//g"`;
	echo $image_name   $md5 >> md5Info.txt;
	rm -f $image_name;
done
