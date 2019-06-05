class mysql::server::apparmor {
  file { '/etc/apparmor.d/usr.sbin.mysqld':
    ensure  => present,
    mode    => '1550',
    source  => 'puppet://modules/mysql/files/usr.sbin.mysqld',
  }

  exec {"apparmor-reload":
    require => File["/etc/apparmor.d/usr.sbin.mysqld"],
    command => "apparmor_parser -r /etc/apparmor.d/usr.sbin.mysqld",
    notify  => Exec['mysqld-restart'],
  }
}
