class php53::params {
  $base_packages = [
    'memcached',
  ]
  case $::osfamily {
    'RedHat': {
      $apache_service = 'httpd'
      $apache_user = 'apache'
      $vhost_perm_folders = ['/etc/httpd/conf.d']
      $php_ini_path = '/etc/php.ini'
      $php_conf_dir = '/etc/php.d'
      $apache_docroot = "/var/www/html"
      $apache_vhost_dir = "/etc/httpd/conf.d"
      $apc_package = 'php-pecl-apc'
      $xdebug_package = 'php-pecl-xdebug'
      $xdebug_zend_extension_path = '/usr/lib64/php/modules/xdebug.so'
      $rehl_packages = [
        'httpd',
        'httpd-devel',
        'php-pear',
        'php-cli',
        'php-common',
        'php-devel',
        'php-mysql',
        'php-pdo',
        'php-pgsql',
        'php-soap',
        'php-xml',
        'php-xmlrpc',
        'php-gd',
        'php-pecl-memcache',
        'openssl',
      ]
      $packages = concat($base_packages, $rehl_packages)
    }
    'Debian': {
      $apache_service = 'apache2'
      $apache_user = 'www-data'
      $vhost_perm_folders = [
        "/etc/apache2/sites-available",
        '/etc/apache2/sites-enabled',
      ]
      $xdebug_package = 'php5-xdebug'
      $xdebug_zend_extension_path = '/usr/lib/php5/20090626+lfs/xdebug.so'
      $php_ini_path = "/etc/php5/apache2/php.ini"
      $php_conf_dir = '/etc/php5/conf.d'
      $apache_docroot = "/var/www"
      $apache_vhost_dir = "/etc/apache2/sites-available"
      $apc_package = 'php-apc'
      # perhaps `autoconf` should be included?
      $deb_packages = [
        'apache2-mpm-prefork',
        'apache2-prefork-dev',
        'apache2-utils',
        'apache2.2-common',
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
        'mime-support',
        'mlock',
        'mysql-client',
        'php5',
        'php5-cli',
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
        'memcached',
      ]
      # TODO: FIXME
      # $packages = concat($base_packages, $deb_packages)
      $packages = $deb_packages
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian.")
    }
  }
}
