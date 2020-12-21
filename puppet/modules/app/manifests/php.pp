class app::php {
    exec {"add-php-apt-repository":
        require => Package["python-software-properties"],   
        command => "add-apt-repository ppa:ondrej/php", 
    }   

    exec {"apt-update-php": 
        require => Exec["add-php-apt-repository"],  
        command => "/usr/bin/apt-get update",   
    }   

    package {["php7.4-cli", "php7.4-dev", "php-apcu-bc", "php7.4-mysql", "php7.4-intl", "php7.4-curl", "php7.4-xml", "php7.4-zip", "php-xdebug", "php-redis", "php-gd", "php-mbstring"]:
        require => Exec["apt-update-php"],  
        ensure => present,
        notify => Service[$webserverService],
    }

    file {"/var/www/":
        ensure => "directory",
        owner => "www-data",
    }

    exec {"clear-symfony-cache":
        require => [File["/var/www/"], Package["php7.4-cli"], Exec["db-schema-create"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.test && COMPOSER_HOME=/var/www/.composer php composer.phar install'",
        user => "www-data"
    }

    if 'nginx' == $webserver {
        include app::php::fpm
    }
}
