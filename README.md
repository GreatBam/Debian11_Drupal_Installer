# DrupalDebian11"

## Usage

### Create the file in your instance

If you want to copy the scritp :

```bash
touch filename.sh
```

### Set Server name

Simply download the script.

Don't forget to change the server name at line 63 of the script file.

```bash
ServerName {hostname}
```

Replace {hostname} by the domain name or ip of your instance.

### Set the file as executable

Set the file as executable :

```bash
chmod 755 filename.sh
```

### Run the script

Finaly, run it :

```bash
./filename.sh
```

The installation will begin.

Follow the instruction on your command prompt terminal.

Navigate to the domain name you defined at step 2.

Follow the instruction, use the credentials when asked for.

## Credentials

### Drupal browser installation :

The following credentials are hardcoded in the script.

Feel free to change them for your own installation.

db name :

```bash
drupaldb
```

<br>

user name :

```bash
drupaluser
```

<br>

password :

```bash
mariadb
```

## Remote control issues

If the instance is deleted and reinstalled, please note that you will have to clear the connection in this file

```bash
C:/Users/{username}/.ssh -> known_hosts
```

remove the related IP and run the ssh command again:

```bash
ssh username@hostname -i keyname
```

## Sources

PHP8.1 source :<br>
https://www.linuxtuto.com/how-to-install-php-8-1-on-debian-11/#

mariaDB:<br>
https://aymeric-cucherousset.fr/en/install-mariadb-on-debian-11/

drupal:<br>
https://www.rosehosting.com/blog/how-to-install-drupal-on-debian-11/

other links :<br>
https://www.howtoforge.com/how-to-install-drupal-with-apache-and-lets-encrypt-ssl-on-debian-11/<br>
https://computingforgeeks.com/install-and-configure-drupal-cms-on-debian/

## Credit

Jonathan Gabioud
