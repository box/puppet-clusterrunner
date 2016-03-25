# == Class: clusterrunner::master::config
#
# Sets up main ClusterRunner configuration file (clusterrunner.conf) and the
# system configuration file for the clusterrunner_master service
#
class clusterrunner::master::config (
  $master,
  $master_port,
  $home,
  $user,
  $group,
  $secret_key,
) {

  # Validate the variables passed in as parameters.
  validate_string($master)
  validate_string("${master_port}") #lint:ignore:only_variable_string - This way, we can validate numbers or strings.

  class { 'clusterrunner::common::config':
    group      => $group,
    user       => $user,
    home       => $home,
    secret_key => $secret_key,
  }

  $service_config_file = '/etc/clusterrunner/master_conf'
  file { $service_config_file:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('clusterrunner/master_conf.erb'),
    require => Class['clusterrunner::common::config'],
  }

}
