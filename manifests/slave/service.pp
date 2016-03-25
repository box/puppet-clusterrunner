# == Class: clusterrunner::slave::service
#
#  This class is responsible for starting the ClusterRunner slave service
#  NOTE: This should only be used after the ClusterRunner master has been setup
#
class clusterrunner::slave::service(
  $user,
  $group,
  $ensure
) {

  $log_file = '/var/log/clusterrunner/slave.log'
  file { $log_file:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0755',
  }

  $service_script = '/etc/init.d/clusterrunner_slave'
  file { $service_script:
    ensure   => file,
    owner    => 'root',
    group    => 'root',
    mode     => '0755',
    source   => 'puppet:///modules/clusterrunner/clusterrunner_slave',
  }

  service { 'clusterrunner_slave':
    ensure  => $ensure,
    require => File[$service_script, $log_file],
  }
}
