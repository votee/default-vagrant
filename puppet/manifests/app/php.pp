import 'php/*'

class app::php {
    package {["php5", "php5-cli", "php5-dev", "php-apc", "php5-mysql", "php5-intl", "php5-curl", "php5-xdebug"]:
        ensure => present,
        notify => Service[$webserverService],
    }

    exec {"clear-symfony-cache":
        require => [Package["php5-cli"], Exec["install-bower"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.dev && /usr/bin/php app/console cache:clear --env=dev'",
        user => "www-data"
    }

    if 'nginx' == $webserver {
        include app::php::fpm
    }
}
