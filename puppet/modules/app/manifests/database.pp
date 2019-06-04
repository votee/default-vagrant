class app::database {

    mysql::db { $vhost:
      user     => $vhost,
      password => $vhost,
    }
    ->
    exec {"db-schema-create":
        require => [Package["php7.2-cli"], Class["mysql::server", "mysql::config"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.localhost && bin/console doctrine:schema:update --force'",
    }

    exec {"db-default-data":
        require => [Exec["db-schema-create"], Package["php7.2-cli"], Class["mysql::server", "mysql::config"]],
        command => "/bin/bash -c 'cd /srv/www/vhosts/$vhost.localhost && bin/console doctrine:fixtures:load --no-interaction'",
        onlyif => "/srv/www/vhosts/$vhost.localhost/bin/console list | grep doctrine:fixtures",
    }
}
