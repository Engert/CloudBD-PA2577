#appserver has node.js installed
#dbserver has mysql installed and running
#web has nginx installed and running
#tst0 -- tst2 have simply run apt-get update and nothing more.

#exec { "apt-update":
#  command => "/usr/bin/apt-get update"
#}

node /^tst\d+$/ {
  exec { "apt-update":
    command => "/usr/bin/apt-get update" }
}

class nodejs {
  package { 'nodejs':
  ensure => installed,
  require => Exec["Add nodesource sources"];
  }
}

#class { 'mysql::server':
#  root_password => 'password',
#}

#class mysql {
#  package { 'mysql':
#  ensure => installed,
#  }
#}

# install mysql-server package
#package { 'mysql-server':
#  require => Exec['apt-update'],        # require 'apt-update' before installing
#  ensure => installed,
#}

# ensure mysql service is running
#service { 'mysql':
#  ensure => running,
#}

class nginx {
  package { 'nginx':
  ensure => installed,
  ensure => running,
  }
}

node 'appserver' {
  include nodejs
}

node 'dbserver' {
  package { 'mysql-server':
    require => Exec['apt-update'],
    ensure => installed,
    root_password => 'password',
  }
  service { 'mysql':
    ensure => running,
  }
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }
}


#node 'puppet-agent' {
#  package { 'vim' :
#    ensure => present,
#  }
#}

#node 'dbserver' {
#  include mysql-server
#
#  class { 'mysql-server':
#    package { 'mysql-server':
#      require => Exec['apt-update'],
#      ensure => installed,
#    }
#    service { 'mysql':
#      ensure => running,
#    }
#  }
#}

#node 'dbserver' {
#  include mysql::server
#}

#node 'dbserver' {
#  class { 'mysql::server':
#    root_password => 'password',
#  }
#}

node 'web' {
  include nginx
}

node default {
  notify { 'this node did not match any of the listed definitions': }
}

exec { "Add nodesource sources":
  command => 'curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -',
  creates => '/etc/apt/sources.list.d/nodesource.list',
  path    => ['/usr/bin', '/bin', '/usr/sbin'];
}
