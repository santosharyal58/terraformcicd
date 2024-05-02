#!/bin/bash
yum -y update
yum -y install httpd git
instance_id=$(ec2-metadata -i | cut -d " " -f 2); 
line_to_append="<h1>Webserver Instance ID : $instance_id</h1>"
#myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
#echo "<h1>Welcome to the nonprod environment! My private IP is $myip</h2><br>Built by Zhiwei Zeng"  >  /var/www/html/index.html
git clone -b feature-web-application --single-branch https://github.com/meetjonca/acs730-project-group8.git
cp -rp acs730-project-group8/Web-Application-Deployment/* /var/www/html/
echo "$line_to_append" | sudo tee -a /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
