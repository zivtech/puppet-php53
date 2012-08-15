# Dev class for PHP 5.3 submodule
class php53::dev ($webadminuser = $php53::webadminuser, $webadmingroup = $php53::webadmingroup) inherits php53 {

  package {
    [
      "build-essential",
      "phpmyadmin",
    ]:
      ensure => installed
  }

  file { "/etc/phpmyadmin/config.inc.php":
    require => Package["phpmyadmin"],
    ensure => present,
    source => "puppet:///modules/php53/config.inc.php",
    mode => 644,
    owner => $webadminuser,
    group => $webadmingroup,
  }

  file { "/etc/apache2/sites-available/phpmyadmin":
    require => Package["phpmyadmin"],
    ensure => link,
    target => "/etc/phpmyadmin/apache.conf",
    owner => $webadminuser,
    group => $webadmingroup,
  }

  file { "/etc/apache2/sites-enabled/phpmyadmin":
    require => File["/etc/apache2/sites-available/phpmyadmin"],
    ensure => link,
    target => "/etc/apache2/sites-available/phpmyadmin",
    owner => $webadminuser,
    group => $webadmingroup,
    #notify => Service['apache2'],
  }

  file { "/var/www/apc.php":
    #require => Package['php53'],
    ensure => present,
    source => "puppet:///modules/php53/apc.php",
    owner => $webadminuser,
    group => $webadmingroup,
  }

  file { "/var/www/memcache.php":
    #require => Package['php53'],
    ensure => present,
    source => "puppet:///modules/php53/memcache.php",
    owner => $webadminuser,
    group => $webadmingroup,
  }

  File["/etc/php5/apache2/php.ini"] {
    source => "puppet:///modules/php53/dev.apache2.php.ini"
  }
}
