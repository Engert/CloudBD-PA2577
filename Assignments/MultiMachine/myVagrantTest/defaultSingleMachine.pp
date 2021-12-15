#$packages = ["curl", "nodejs"]
#package {
#  $packages: ensure => installed,
#  require => Exec["apt-update"],
#  require => require => Exec["Add nodesource sources"],
#}


exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

package { 'curl':
  ensure => installed,
  require => Exec["apt-update"],
}

exec { "Add nodesource sources":
  command => 'curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -',
  creates => '/etc/apt/sources.list.d/nodesource.list',
  path    => ['/usr/bin', '/bin', '/usr/sbin'];
}

package { 'nodejs':
  ensure => installed,
  require => Exec["Add nodesource sources"];
}