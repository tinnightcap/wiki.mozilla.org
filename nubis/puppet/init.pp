# Main entry for puppet
#
# import is depricated and we should use another method for including these
#+ manifests
#

import 'datadog.pp'
import 'apache.pp'
import 'fluentd.pp'
import 'varnish.pp'
import 'nubis_configuration.pp'
import 'nubis_storage.pp'

exec { "apt-get update":
    command => "/usr/bin/apt-get update",
}

package { 'php-apc':
  ensure => '4.0.2-2build1',
  require  => Exec['apt-get update'],
}

package { 'php5-gd':
  ensure => '5.5.9+dfsg-1ubuntu4.9',
  require  => Exec['apt-get update'],
}

package { 'php5-mysql':
  ensure => '5.5.9+dfsg-1ubuntu4.9',
  require  => Exec['apt-get update'],
}

package { 'mysql-client':
  ensure => '5.5.43-0ubuntu0.14.04.1',
  require  => Exec['apt-get update'],
}

package { 'makepasswd':
  ensure => '1.10-9',
  require  => Exec['apt-get update'],
}

package { 'git':
  ensure => 'latest',
  require  => Exec['apt-get update'],
}

package { 'librsvg2-bin':
  ensure => 'latest',
  require  => Exec['apt-get update'],
}

package { 'php-http-request2':
  ensure => 'latest',
  require  => Exec['apt-get update'],
}

package { 'imagemagick':
  ensure => 'latest',
  require  => Exec['apt-get update'],
}

package { 'graphviz':
  ensure => 'latest',
  require  => Exec['apt-get update'],
}
