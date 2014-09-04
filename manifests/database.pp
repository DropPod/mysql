define mysql::database($user) {
  include mysql

  unless defined(Mysql::User[$user]) {
    mysql::user { "${user}": password => passwordgen($name) }
  }

  exec { "Creating MySQL Database '${name}'":
    command => "mysqladmin create -u root ${name}",
    unless  => "mysqlshow -u root | grep -q ' ${name} '",
    path    => "/usr/local/bin:/usr/bin:/bin",
    require => [Class['mysql']],
  }
}
