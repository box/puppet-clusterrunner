# == Class: clusterrunner::master::service
#
#  This class is responsible for starting the ClusterRunner master service
#
class clusterrunner::master::service(
  $user,
  $group,
  $ensure
) {

  $log_file = '/var/log/clusterrunner/master.log'
  file { $log_file:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0755',
  }

  $service_script = '/etc/init.d/clusterrunner_master'
  file { $service_script:
    ensure   => file,
    owner    => 'root',
    group    => 'root',
    mode     => '0755',
    source   => 'puppet:///modules/clusterrunner/clusterrunner_master',
  }

  service { 'clusterrunner_master':
    ensure  => $ensure,
    require => File[$service_script, $log_file],
  }

}
