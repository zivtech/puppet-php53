# Dev class for PHP 5.3 submodule
class php53::dev (
    $webadminuser = $php53::webadminuser,
    $webadmingroup = $php53::webadmingroup,
    $web_permissions = $php53::web_permissions,
    $xdebug_idekey = "netbeans-xdebug",
    $xdebug_remote_host = "33.33.33.1",
    $install_phpmyadmin = false
  ) inherits php53 {

  $xdebug_zend_extension_path = $php53::params::xdebug_zend_extension_path

  package { $php53::params::xdebug_package:
    ensure => installed
  }

  # TODO: Remove phpmyadmin installation completely.
  if ($install_phpmyadmin) {
    package { "phpmyadmin":
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
  }

  if ($web_permissions == 'true') {
    if ($install_phpmyadmin) {
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
    }
    file { "${php53::params::apache_docroot}/apc.php":
      #require => Package['php53'],
      ensure => present,
      source => "puppet:///modules/php53/apc.php",
      owner => $webadminuser,
      group => $webadmingroup,
    }
    file { "${php53::params::apache_docroot}/memcache.php":
      #require => Package['php53'],
      ensure => present,
      source => "puppet:///modules/php53/memcache.php",
      owner => $webadminuser,
      group => $webadmingroup,
    }
  }
  else {
    if ($install_phpmyadmin) {
      file { "/etc/apache2/sites-available/phpmyadmin":
        require => Package["phpmyadmin"],
        ensure => link,
        target => "/etc/phpmyadmin/apache.conf",
      }
      file { "/etc/apache2/sites-enabled/phpmyadmin":
        require => File["/etc/apache2/sites-available/phpmyadmin"],
        ensure => link,
        target => "/etc/apache2/sites-available/phpmyadmin",
        #notify => Service['apache2'],
      }
    }
  }

  File[$php53::params::php_ini_path] {
    content => template("php53/dev.php.ini.apache2.erb"),
  }
  file { "${php53::params::php_conf_dir}/xdebug.ini":
    require => Package[$php53::params::xdebug_package],
    ensure => present,
    content => template("php53/xdebug.ini.erb"),
    owner => 'root',
    group => 'root',
    mode => 644,
  }

}
