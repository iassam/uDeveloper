    apt-get install apache2 -y
    echo "Servername $1" >> /etc/apache2/apache2.conf    
    service apache2 restart
    
    #Debconf mysql
    debconf-set-selections <<< "mysql-server mysql-server/root_password password $2"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $2"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
    
    #Debconf phpmyadmin
    debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $2"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $2"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $2"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

    apt-get install mysql-server phpmyadmin php libapache2-mod-php php-mcrypt php-mysql php-gd php-gettext php-zip php-mbstring phpunit php-gettext -y

    a2enmod rewrite

    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini


    npm install -g gulp bower

    service apache2 restart
