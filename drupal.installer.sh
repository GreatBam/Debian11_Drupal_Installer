#!/bin/bash

# This script will install Drupal 10.0.0 on Debian 11 Bullseye
# LAMP stack will also be installed

# Check if root password is set
echo "Is any root password already set? (y/n)"
read rootpass

if [ "$rootpass" = "n" ]; then
    echo "Enter new root password"
    sudo passwd root
fi

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt install unzip gnupg ca-certificates apt-transport-https software-properties-common mariadb-server mariadb-client -y

# Add Sury PHP repository
sudo sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/sury-php.list'
wget -qO - https://packages.sury.org/php/apt.gpg | sudo apt-key add -

# Update system and install PHP 8.1 with extensions
sudo apt update
sudo apt install php8.1 php8.1-cli php8.1-common php8.1-curl php8.1-gd php8.1-mbstring php8.1-mysql php8.1-opcache php8.1-readline php8.1-xml php8.1-zip -y

# Install and configure Apache
sudo apt install apache2 -y
sudo systemctl enable apache2 && sudo systemctl start apache2
sudo a2enmod rewrite

# Configure MariaDB
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo mysql_secure_installation

# Create a database for Drupal
sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE USER 'drupaluser'@'localhost' IDENTIFIED BY 'mariadb';
CREATE DATABASE drupaldb;
GRANT ALL PRIVILEGES ON drupaldb.* TO 'drupaluser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

# Install Drupal
cd /var/www/html
sudo wget https://ftp.drupal.org/files/projects/drupal-10.0.0.zip
sudo unzip drupal-10.0.0.zip
sudo mv drupal-10.0.0/ drupal/
sudo rm drupal-10.0.0.zip
sudo chown -R www-data:www-data drupal/
sudo find drupal/ -type d -exec chmod 755 {} \;
sudo find drupal/ -type f -exec chmod 644 {} \;

# Create Apache2 virtual host
if [ ! -f /etc/apache2/sites-available/drupal.conf ]; then
    sudo bash -c 'cat <<EOF > /etc/apache2/sites-available/drupal.conf
<VirtualHost *:80>
    ServerAdmin admin@example.com
    ServerName {hostname}
    DocumentRoot /var/www/html/drupal
    <Directory /var/www/html/drupal>
        AllowOverride All
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'
fi

# Disable Default Apache Site
# sudo a2dissite 000-default.conf

# Enable the Drupal site and restart Apache
sudo a2ensite drupal
sudo systemctl restart apache2

echo "Drupal installation script completed."
