class app::redis {
    package {["redis-server"]:
        ensure => present,
    }
}
