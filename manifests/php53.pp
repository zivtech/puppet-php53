class php53 {
  package { 
    [
      'apache2-mpm-prefork',
      'apache2-prefork-dev',
      'apache2-utils',
      'apache2.2-common',
      # needed? 'ssl-cert',
      'memcached',
      'mime-support',
      'php-pear',
      'php5',
      'php5-cli',
      'php5-common',
      'php5-dev',
      'php5-gd',
      'php5-imap',
      'php5-mcrypt',
      'php5-memcache',
      'php5-mysql',
    ]: 
      ensure => installed 
  }
  service { 
    [
      'apache2',
    ]:
    ensure => running,
  }
  file { '/var/log/php':
    type => 'directory',
    ensure => 'directory',
    owner => 'www-data',
    mode => '493'
  }
  file { '/var/log/php/error.log':
    ensure => exists,
    owner  => 'www-data',
  }
  file { "/etc/php5/apache2/php.ini":
    source => "puppet:///modules/php53/php.ini.apache2"
  }
  file { "/etc/php5/cli/php.ini":
    source => "puppet:///modules/php53/php.ini.cli"
  }
}


