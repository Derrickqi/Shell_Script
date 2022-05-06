#!/bin/bash

#存储路径
Source_Path='/root/sdata'
Dest_Path='/root/ddata'
Back_Path='/root/backdata'

#日志路径
Log_Path='/var/log/Transmition.log'


# 定义log输出及记录
function log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S")" "$1"
    echo -e "$(date "+%Y-%m-%d %H:%M:%S")" "$1" >> ${Log_Path}
}



# 判断文件是否更新完成
       
function Determine_file_size(){

[[ -e /tmp/Transmition.txt ]] || touch /tmp/Transmition.txt
i=0
while true;do
	du -sh ${Source_Path} | grep -oE '[0-9]+'  > /tmp/Transmition.txt && sleep 1

	if [[ $(ls -1 ${Source_Path}) != "" ]] && [[ $(du -sh ${Source_Path} | grep -oE '[0-9]+') == $(cat /tmp/Transmition.txt) ]];then
		return 0
	else
	    if [[ $i -le 10 ]];then
			echo "正在检测目录${Source_Path}............."
	    	let i++
	    	continue
		else
			return 1
	    fi
	fi
done
}


# ftp上传文件模块
function Ftp_Upload() {

FTP_HOST='172.17.0.2'
FTP_USER='root'
FTP_PASS='1'
LOCAL_DIR='/root/sdata'
FTP_DIR='/var/ftp/storage'


timeout 2 ftp ${FTP_HOST} | grep -o "Connected to ${FTP_HOST}"


if [[ $? == 0 ]];then
    log "FTP ${FTP_HOST} 连接成功；$(timeout 2 ftp ${FTP_HOST})"
    ftp -v -n ${FTP_HOST} << EOF
    user ${FTP_USER} ${FTP_PASS}
    binary
    hash
    cd ${FTP_DIR}
    lcd ${LOCAL_DIR}
    prompt
    mput *
    bye
    #here document
EOF
    log ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   ftp&nfs文件同步成功 !   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
else
    log "FTP ${FTP_HOST} 连接失败；$(timeout 2 ftp ${FTP_HOST})"
    log ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   Nfs文件同步成功，Ftp文件同步失败 !请检查FTP服务器 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
fi

}


# 若更新完成则开始同步文件
function File_synchronization(){

#二次判断
	if [[ $(du -sh ${Source_Path} | grep -oE '[0-9]+') == $(cat /tmp/Transmition.txt) ]];then
		#rsync -av ${Source_Path}/* ${Dest_Path}/ >> ${Log_Path} 2>&1 && rsync -av ${Source_Path}/* ${Back_Path}/ || exit 1
		rsync -av ${Source_Path}/* ${Dest_Path}/ >> ${Log_Path} 2>&1 && Ftp_Upload || exit 1
		if [[ $? -eq 0 ]];then
			rm -rf ${Source_Path}/* /tmp/Transmition.txt
			return 0 
		else
			return 1
		fi
	fi
}


# mian函数
function main(){
while true;do
	Determine_file_size
	if [[ $? -eq 0 ]];then
		sleep 0.5
		File_synchronization
		if [[ $? -eq 0 ]];then
			log "文件同步完成!"
			continue
		else
			log "文件未更新完成,请稍等....."
			continue
		fi
	else
		Determine_file_size
	fi
done
}

main






