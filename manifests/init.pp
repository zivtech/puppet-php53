# Installs PHP 5.3 packages
class php53(
  $webadminuser = 'root',
  $webadmingroup = 'root',
  $web_permissions = 'true',
  $max_post_size = '8M'
) {
  package { 'php53':
    name => [
      'apache2-mpm-prefork',
      'apache2-prefork-dev',
      'apache2-utils',
      'apache2.2-common',
      'autoconf',
      'automake',
      'autotools-dev',
      'build-essential',
      'comerr-dev',
      'libaprutil1-dev',
      'libtool',
      'libc-client2007e',
      'libldap2-dev',
      'libexpat1-dev',
      'libpcre3-dev',
      'libapr1-dev',
      'libsqlite3-dev',
      'libpq5',
      'libkrb5-dev',
      'libpq-dev',
      'libpcrecpp0',
      'libmysqlclient-dev',
      'krb5-multidev',
      'm4',
      'memcached',
      'mime-support',
      'mlock',
      'mysql-client',
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
      'php5-curl',
      'shtool',
      'ssl-cert',
      'uuid-dev',
    ],
      ensure => installed
  }

  service {
    [
      'apache2',
      'memcached',
    ]:
    ensure => running,
    require => Package['php53'],
  }

  exec { 'pecl install uploadprogress':
    command => "/usr/bin/pecl install uploadprogress",
    require => Package['php53'],
    creates => "/etc/php5/apache2/conf.d/uploadprogress.ini",
    path => ["/usr/bin:/usr/sbin:/bin"],
  }

  file { '/etc/php5/apache2/conf.d/uploadprogress.ini':
    ensure => present,
    content => 'extension=uploadprogress.so',
    require => Exec['pecl install uploadprogress'],
    owner   => root,
    group   => root,
    mode    => 0644,
  }

  file { '/var/log/php':
    ensure => 'directory',
    owner => 'www-data',
    group => $webadmingroup,
    recurse => true,
  }

  file { '/var/log/php/error.log':
    require => File['/var/log/php'],
    ensure => present,
    owner  => 'www-data',
    group => $webadminuser,
  }

  file {
    [
      '/etc/apache2/sites-available',
      '/etc/apache2/sites-enabled',
    ]:
    require => Package['php53'],
    ensure => 'directory',
    owner => $webadminuser,
    recurse => true,
  }

  # TODO: THis is out of date.
  file { '/etc/apache2/envvars':
    require => Package['php53'],
    source => "puppet:///modules/php53/envvars",
  }


  file { "/etc/php5/apache2/php.ini":
    require => Package['php53'],
    content => template("php53/php.ini.apache2.erb"),
    owner => root,
    group => root,
  }

  file { "/etc/php5/conf.d/memcache.ini":
    require => Package['php53'],
    source => "puppet:///modules/php53/memcache.ini",
    owner => root,
    group => root,
  }

  file { "/etc/php5/cli/php.ini":
    require => Package['php53'],
    source => "puppet:///modules/php53/php.ini.cli",
    owner => root,
    group => root,
  }

  file { "/etc/memcached.conf":
    source => "puppet:///modules/php53/memcached.conf",
    owner => root,
    group => root,
  }

  if ($web_permissions == 'true') {
    file { "/var/www":
      ensure => 'directory',
      owner => $webadminuser,
      group => $webadmingroup,
    }
    file { "/etc/php5/apache2/conf.d/apc.ini":
      require => Package['php53'],
      source => "puppet:///modules/php53/apc.ini",
      owner => root,
      group => root,
    }
  }
  else {
    file { "/var/www":
      ensure => 'directory',
    }
    file { "/etc/php5/apache2/conf.d/apc.ini":
      require => Package['php53'],
      source => "puppet:///modules/php53/apc.ini",
    }
  }



  # enable mod_rewrite
  exec { "/usr/sbin/a2enmod rewrite":
    path => "/usr/bin:/usr/sbin:/bin",
    unless => "/usr/bin/test -f /etc/apache2/mods-enabled/rewrite.load",
    require => Package['php53'],
  }

  # unfotunately ubuntu packages use deprecated comments
  exec { 'clean deprecated comments in /etc/php5/cli':
    command => "find /etc/php5/cli/conf.d/* -type f -exec sed -i 's/#/;/g' {} \\;",
    path => "/usr/bin:/usr/sbin:/bin",
    onlyif => "grep -qr '#' /etc/php5/cli/conf.d"
  }

  # unfotunately ubuntu packages use deprecated comments
  exec { 'clean deprecated comments in /etc/php5/conf.d':
    command => "find /etc/php5/conf.d/* -type f -exec sed -i 's/#/;/g' {} \\;",
    path => "/usr/bin:/usr/sbin:/bin",
    onlyif => "grep -qr '#' /etc/php5/conf.d"
  }

  # unfotunately ubuntu packages use deprecated comments
  exec { 'clean deprecated comments in /etc/php5/apache2':
    command => "find /etc/php5/apache2/conf.d/* -type f -exec sed -i 's/#/;/g' {} \\;",
    path => "/usr/bin:/usr/sbin:/bin",
    onlyif => "grep -qr '#' /etc/php5/apache2/conf.d"
  }
}
