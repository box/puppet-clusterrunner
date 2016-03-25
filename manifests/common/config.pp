# == Class: clusterrunner::config
#
# Sets up ClusterRunner configuration file (clusterrunner.conf) and common
# directories.
#
class clusterrunner::common::config (
  $home,
  $user,
  $group,
  $secret_key,
) {

  validate_absolute_path($home)
  file { "${home}/.clusterrunner/clusterrunner.conf" :
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0600',
    content => template('clusterrunner/clusterrunner.conf.erb'),
  }

  $log_dir = '/var/log/clusterrunner'
  file { $log_dir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
  }

  $conf_dir = '/etc/clusterrunner'
  file { $conf_dir:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
  }

}
