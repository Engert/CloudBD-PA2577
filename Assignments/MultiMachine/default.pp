#appserver has node.js installed
#dbserver has mysql installed and running
#web has nginx installed and running
#tst0 -- tst2 have simply run apt-get update and nothing more.

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

class nginx {
  package { 'nginx':
  ensure => installed,
  ensure => running,
  }
}

node 'appserver' {
  include nodejs
}

#node 'dbserver' {
#  include mysql::server
#}

node 'dbserver' {
  class { 'mysql::server':
    root_password => 'password',
  }
}

node 'web' {
  include nginx
}

node default {
  notify { 'this node did not match any of the listed definitions': }
}

#package { 'curl':
#  ensure => installed,
#  require => Exec["apt-update"],
#}

exec { "Add nodesource sources":
  command => 'curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -',
  creates => '/etc/apt/sources.list.d/nodesource.list',
  path    => ['/usr/bin', '/bin', '/usr/sbin'];
}

#package { 'nodejs':
#  ensure => installed,
#  require => Exec["Add nodesource sources"];
#}