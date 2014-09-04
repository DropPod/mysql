class mysql {
  package { 'mysql': ensure => installed, provider => 'homebrew' }

  $LaunchAgents = "/Users/${id}/Library/LaunchAgents"
  unless defined(File[$LaunchAgents]) {
    file { "${LaunchAgents}":
      ensure => directory,
      mode   => '0755',
    }
  }

  $plist = "${LaunchAgents}/homebrew.mysql.plist"
  file { "${plist}":
    ensure  => link,
    target  => '/usr/local/opt/mysql/homebrew.mxcl.mysql.plist',
    require => [Package['mysql']],
    before  => [Exec['Starting MySQL']],
  }

  $mysql_is_running = "/usr/local/bin/mysqladmin -uroot status"

  exec { "Starting MySQL":
    command => "/bin/launchctl load ${plist}",
    unless  => $mysql_is_running,
    require => [Package['mysql']],
  }

  exec { "Waiting for MySQL":
    command   => $mysql_is_running,
    unless    => $mysql_is_running,
    tries     => 30,
    try_sleep => 1,
    require   => [Exec['Starting MySQL']],
  }
}
