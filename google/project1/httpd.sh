#!bin/bash
sudo yum install httpd -y 
sudo service httpd start 
sudo echo "<h2>Welcome to userdata Demo </h2>" /var/home/html/index.html