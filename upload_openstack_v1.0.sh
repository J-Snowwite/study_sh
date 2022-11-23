#/bin/bash
set -x

#加载环境变量
source /etc/kolla/admin-openrc.sh

#获取脚本后面的第一个参数
file_name=$1

#获取文件列表中的列(每列是一行镜像的url地址)
for image_url in `cat $file_name`

#循环开始
do

#获取下载连接中的文件名称
image_name=`echo $image_url |awk -F/ '{ print $NF}'`;

#查询镜像是否已经存在
first_name=`echo $image_name|sed 's/.qcow2//g'|sed 's/.raw//g'`;
status=`openstack image list |grep $first_name |awk -F\| '{print $4}'` ;
if [[ "$status" =~ "active" ]];then
	continue
fi

#下载镜像
wget --user yangshiwen --password Yang@123 $image_url;

#获取文件格式类型,判断文件格式进行转换
file_format=`qemu-img info $image_name |grep file|awk '{ print $3}'`
if [[ "$file_format" =~ "qcow2" ]];then
    qemu-img convert -f qcow2 -O raw $image_name $first_name.raw
    image_name=$first_name.raw
fi

#判断上传.如果镜像名称中存在2003的
if [[ "$image_name" =~ "2003" ]] ;then
    openstack image create --container-format bare --disk-format vmdk --file $image_name --private --project env_shixun $image_name --property hw_disk_bus=ide --property os_type=windows --property hw_qemu_guest_agent=yes

#判断如果不是win 2003 那么直接上传
  else
    openstack image create --container-format bare --disk-format raw --file $image_name --private --project env_shixun $image_name --property hw_qemu_guest_agent=yes
fi

#删除下载的镜像
rm -f $first_name*;

#清理桌面
done
rm -f nohup.out
