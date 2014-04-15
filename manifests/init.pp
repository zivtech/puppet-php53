# Installs PHP 5.3 packages.
class php53 (
    $webadminuser = 'webadmin',
    $webadmingroup = 'webadmin',
    $web_permissions = 'true',
    $max_post_size = '8M',
    $apacheport = '80',
    $apc_shm_size = '256M'
  ) inherits php53::params {
  package { 'php53':
    name => $php53::params::packages,
    ensure => installed
  }
  service { $php53::params::apache_service:
    ensure => running,
    require => Package['php53'],
    enable => true,
  }

  service { 'memcached':
    ensure => running,
    require => Package['php53'],
    enable => true,
  }

/*
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
*/

  file { '/var/log/php':
    ensure => 'directory',
    owner => $php53::params::apache_user,
    group => $webadmingroup,
    recurse => true,
  }

  file { '/var/log/php/error.log':
    require => File['/var/log/php'],
    ensure => present,
    owner  => $php53::params::apache_user,
    group => $webadminuser,
  }


  file { $php53::params::vhost_perm_folders:
    require => Package['php53'],
    ensure => 'directory',
    owner => $webadminuser,
    recurse => true,
  }

  file { "/var/www/default":
    require => Package['php53'],
    ensure => 'directory',
    owner => $webadminuser,
    group => $webadmingroup,
    mode    => 0644,
  }

  file { '/var/www/default/index.html':
    ensure => present,
    replace => "no",
    source => "puppet:///modules/php53/index.html",
    require => File["/var/www/default"],
    owner => $webadminuser,
    group => $webadmingroup,
    mode    => 0644,
  }

  file { "${php53::params::apache_vhost_dir}/default":
    ensure => present,
    content => template('php53/default_vhost'),
    require => File["/var/www/default"],
    owner => $webadminuser,
    group => $webadmingroup,
    mode    => 0644,
    notify => Service[$php53::params::apache_service],
  }

  file { "${php53::params::apache_vhost_dir}/default-ssl":
    ensure => present,
    source => "puppet:///modules/php53/default-ssl",
    require => File["/var/www/default"],
    owner => $webadminuser,
    group => $webadmingroup,
    mode    => 0644,
    notify => Service[$php53::params::apache_service],
  }

/*
  # TODO: Fixme for CentOS
  # TODO: THis is out of date.
  file { "/etc/apache2/envvars":
    require => Package['php53'],
    source => "puppet:///modules/php53/envvars",
  }
*/


  file { $php53::params::php_ini_path:
    require => Package['php53'],
    content => template("php53/php.ini.apache2.erb"),
    owner => root,
    group => root,
    notify => Service[$php53::params::apache_service],
  }

  if $::osfamily == 'Debian' {
    # This file is created automatically on RedHat.
    file { "${php53::params::php_conf_dir}/memcache.ini":
      require => Package['php53'],
      source => "puppet:///modules/php53/memcache.ini",
      owner => root,
      group => root,
      notify => Service[$php53::params::apache_service],
    }
    file { "/etc/php5/cli/php.ini":
      require => Package['php53'],
      source => "puppet:///modules/php53/php.ini.cli",
      owner => root,
      group => root,
    }
  }

  file { "/etc/memcached.conf":
    source => "puppet:///modules/php53/memcached.conf",
    owner => root,
    group => root,
  }
  file { "${php53::params::php_conf_dir}/apc.ini":
    require => Package['php53'],
    content => template('php53/apc.ini.erb'),
    owner => root,
    group => root,
  }
  if ($web_permissions == 'true') {
    file { $php53::params::apache_docroot:
      ensure => 'directory',
      owner => $webadminuser,
      group => $webadmingroup,
    }
  }
  else {
    file { $php53::params::apache_docroot:
      ensure => 'directory',
    }
  }

  /*
  # enable mod_rewrite
  exec { "/usr/sbin/a2enmod rewrite":
    path => "/usr/bin:/usr/sbin:/bin",
    unless => "/usr/bin/test -f /etc/apache2/mods-enabled/rewrite.load",
    require => Package['php53'],
  }
  */

  # unfotunately ubuntu packages use deprecated comments
  exec { 'clean deprecated comments in /etc/php5/cli':
    command => "find ${php53::params::php_conf_dir}/* -type f -exec sed -i 's/#/;/g' {} \\;",
    path => "/usr/bin:/usr/sbin:/bin",
    onlyif => "grep -qr '#' /etc/php5/cli/conf.d"
  }

  # unfotunately ubuntu packages use deprecated comments
  exec { 'clean deprecated comments in /etc/php5/conf.d':
    command => "find ${php53::params::php_conf_dir}/* -type f -exec sed -i 's/#/;/g' {} \\;",
    path => "/usr/bin:/usr/sbin:/bin",
    onlyif => "grep -qr '#' /etc/php5/conf.d"
  }

  # unfotunately ubuntu packages use deprecated comments
  exec { 'clean deprecated comments in /etc/php5/apache2':
    command => "find ${php53::params::php_conf_dir}/* -type f -exec sed -i 's/#/;/g' {} \\;",
    path => "/usr/bin:/usr/sbin:/bin",
    onlyif => "grep -qr '#' /etc/php5/apache2/conf.d"
  }

  if ($::osfamily == 'Redhat') {
    file { '/etc/httpd/conf/httpd.conf':
      require => Package['php53'],
      content => template("php53/httpd.conf.erb"),
      owner => root,
      group => root,
      notify => Service[$php53::params::apache_service],
    }
  }
}
