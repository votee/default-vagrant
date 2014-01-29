class app::database {

    mysql::db { $vhost:
      user     => $vhost,
      password => $vhost,
    }

    exec {"db-create":
        require => [Package["php5-cli"], Class["mysql::server", "mysql::config"]], 
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.dev && /usr/bin/php app/console doctrine:database:create'",
    }

    exec {"db-schema-create":
        require => [Exec["db-create"], Package["php5-cli"], Class["mysql::server", "mysql::config"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.dev && /usr/bin/php app/console doctrine:schema:update --force'",
    }

    exec {"db-default-data":
        require => [Exec["db-schema-create"], Package["php5-cli"], Class["mysql::server", "mysql::config"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.dev && /usr/bin/php app/console doctrine:fixtures:load --no-interaction'",
        onlyif => "/srv/www/vhosts/$vhost.dev/app/console list | grep doctrine:fixtures",
    }

    exec {"db-migrations":
        require => [Exec["db-schema-create"], Package["php5-cli"], Class["mysql::server", "mysql::config"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.dev && /usr/bin/php app/console doctrine:migrations:migrate --no-interaction'",
        onlyif => "/srv/www/vhosts/$vhost.dev/app/console list | grep doctrine:migrations",
    }
}
