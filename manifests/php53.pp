class php53 {
  package { 
    [
      'apache2-mpm-prefork',
      'apache2-prefork-dev',
      'apache2-utils',
      'apache2.2-common',
      'ssl-cert',
      'memcached',
      'mime-support',
      'php5',
      'php5-cli',
      'php-apc',
      'php-pear',
      'php5-common',
      'php5-dev',
      'php5-gd',
      'php5-imap',
      'php5-mcrypt',
      'php5-memcache',
      'php5-mysql',
      'sendmail',
    ]: 
      ensure => installed 
  }
  service { 
    [
      'apache2',
      'memcached',
    ]:
    ensure => running,
  }

  file { '/var/log/php':
    type => 'directory',
    ensure => 'directory',
    owner => 'www-data',
    group => 'webadmin',
    recurse => true,
  }

  file { 
    [
      '/etc/apache2/sites-available',
      '/etc/apache2/sites-enabled',
    ]:
    type => 'directory',
    ensure => 'directory',
    owner => 'webadmin',
    recurse => true,
  }

  file { '/var/log/php/error.log':
    ensure => exists,
    owner  => 'www-data',
  }

  file { "/etc/php5/apache2/php.ini":
    require => Package['php5'],
    source => "puppet:///php53/php.ini.apache2",
    owner => root,
    group => root,
  }

  file { "/etc/php5/cli/php.ini":
    require => Package['php5'],
    source => "puppet:///php53/php.ini.cli",
    owner => root,
    group => root,
  }

  file { "/etc/memcached.conf":
    source => "puppet:///php53/memcached.conf",
    owner => root,
    group => root,
  }

  file { "/var/www":
    ensure => 'directory',
    owner => 'webadmin',
    group => 'webadmin',
  }

  # enable mod_rewrite
  exec { "/usr/sbin/a2enmod rewrite":
    path => "/usr/bin:/usr/sbin:/bin",
    unless => "/usr/bin/test -f /etc/apache2/mods-enabled/rewrite.load"
  }

}
