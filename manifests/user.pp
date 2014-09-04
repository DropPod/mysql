define mysql::user($password = undef) {
  include mysql

  if ($password) {
    $sql_password = "IDENTIFIED BY '${password}'"
  } else {
    $sql_password = ''
  }

  exec { "Creating MySQL User '${name}'":
    command => "mysql -u root -e \"CREATE USER '${name}'@'localhost' ${sql_password}\"",
    unless  => "mysql -u root -e \"SELECT 1 FROM mysql.user WHERE User = '${name}' AND Host = 'localhost'\" | grep -q 1",
    path    => "/usr/local/bin:/usr/bin:/bin",
    require => [Class['mysql']],
  }

  exec { "Granting all MySQL permissions to '${name}'":
    command => "mysql -u root -e \"GRANT ALL ON *.* TO '${name}'@'localhost'\"",
    unless  => "mysql -u ${name} -p${password} -e 'SELECT 1'",
    path    => "/usr/local/bin:/usr/bin:/bin",
    require => [Class['mysql'], Exec["Creating MySQL User '${name}'"]],
  }
}
