class php53::params {
  $base_packages = [
   
  ]
  case $::osfamily {
    'RedHat': {
      $apache_service = 'httpd'
      $apache_user = 'apache'
      $vhost_perm_folders = ['/etc/httpd/conf.d']
      $php_ini_path = '/etc/php.ini'
      $php_conf_dir = '/etc/php.d'
      $apache_docroot = "/var/www/html"
      $rehl_packages = [
        'httpd',
        'httpd-devel',
        'php-pear',
        'php-common',
        'php-devel',
        'php-pecl-apc',
        'php-mysql',
        'php-pdo',
        'php-pgsql',
        'php-soap',
        'php-xml',
        'php-xmlrpc',
        'php-gd',
        'php-pecl-xdebug',
        'php-pecl-memcached',
        'php-pecl-Fileinfo',
        'php-pecl-zip',
        'openssl',
        /*
        # The following alternate set of packages install php53 but not apc.
        'httpd',
        'httpd-devel',
        'php53-common',
        'php-pear',
        'php53-devel',
        # 'php53-apc',
        'php53-mysql',
        'php53-pdo',
        'php53-pgsql',
        'php53-soap',
        'php53-xml',
        'php53-xmlrpc',
        'php53-gd',
        # 'php-pecl-xdebug',
        # 'php-pecl-memcached',
        # 'php-pecl-Fileinfo',
        # 'php-pecl-zip',
        */
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
      $php_ini_path = "/etc/php5/apache2/php.ini"
      $php_conf_dir = '/etc/php5/conf.d'
      $apache_docroot = "/var/www"
      $deb_packages = [
        'apache2-mpm-prefork',
        'apache2-prefork-dev',
        'apache2-utils',
        'apache2.2-common',
            # 'autoconf',
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
      ]
      $packages = concat($base_packages, $deb_packages)
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian.")
    }
  }
}