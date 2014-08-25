class multipath {
  include multipath::install, multipath::config, multipath::service
}

class multipath::install {
  package { 'device-mapper-multipath':
    ensure => present,
  }
}

class multipath::config {
  exec { '/sbin/mpathconf --enable --user_friendly_names y --find_multipaths y --with_module y':
    path    => ['/bin', '/usr/bin', '/sbin/',  '/usr/sbin/'],
    unless  => 'test -e /etc/multipath.conf',
    require => Class['multipath::install'],
    notify  => Class['multipath::service'],
  }
}

class multipath::service {
  service { 'multipathd':
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    require     => Class['multipath::config'],
  }
}
