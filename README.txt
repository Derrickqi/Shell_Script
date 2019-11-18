#sendEmail下载地址

wget http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz



#sendEmail基本参数

######################################################################
#    -f  XXXXXXX@163.com 发件人邮箱地址                              
#    -t  XXXXX@qq.com  收件人邮箱                                  
#    -s  smtp.163.com  发件人邮箱的smtp服务器                         			         
#    -u  '标题'  邮件的主题                                          				       
#    -o message-content-type=html  邮件内容的格式为html，也可以是text		        
#    -o message-charset=utf8  邮件内容编码                           			        
#    -xu XXXXXXX@qq.com  发件人账号                               			        
#    -xp XXXXXX  发件人密码                                          			         
#    -m  '邮件内容'  邮件的内容                                      			        
######################################################################


#用法

./sendEmail.sh   邮件标题   邮件内容 
