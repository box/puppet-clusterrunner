# == Class: clusterrunner::master
#
# Installs the ClusterRunner package in an appropriate location and with
# appropriate access rights on a particular ClusterRunner slave server. It also
# ensures that the ClusterRunner slave is connected to its specified master and
# that clusterrunner_slave service is in the specified state.
#
# === Parameters
#
# [*slave*]
#   The hostname of the ClusterRunner slave.
#
# [*slave_port*]
#   The port that the ClusterRunner slave service should run on. Defaults to '43001'.
#
# [*master*]
#   The hostname of the ClusterRunner master that the slave intends to connect to.
#
# [*master_port*]
#   The port that the ClusterRunner master service is running on. Defaults to
#   '43000'.

# [*secret_key*]
#   The key that the master will use to validate API requests and requests from
#   the slave. This MUST be the same as secret_key passed to the master.
#
# [*user*]
#   ClusterRunner service user. Defaults to 'clusterrunner'.
#
# [*group*]
#   Group for the ClusterRunner service user. Defaults to 'clusterrunner'.
#
# [*home*]
#   The home directory of the ClusterRunner service user. This is where the
#   ClusterRunner package is installed. Defaults to '/usr/local/clusterrunner'.
#
# [*ensure*]
#   The state of the clusterrunner_slave service. It can either be 'running'
#   or 'stopped'. Defaults to 'running'.
#
# [*package_url*]
#   This parameter allows you to specify an alternate url to the ClusterRunner
#   GZIP Compressed Tar Archive (.tgz) file. By default the ClusterRunner
#   package is pulled from the public internet hosted on Box. This parameter is
#   useful if access to the public internet is not available and/or internal
#   hosting is preferred.
#
# === Authors
#
# Nadeem Ahmad
#
# === Copyright
#
# Copyright 2016 Box, Inc.
#
class clusterrunner::slave (
  $master      = undef,
  $slave       = undef,
  $secret_key  = undef,
  $slave_port = $clusterrunner::params::slave_port,
  $master_port = $clusterrunner::params::master_port,
  $group       = $clusterrunner::params::group,
  $user        = $clusterrunner::params::user,
  $home        = $clusterrunner::params::home,
  $ensure      = 'running',
  $package_url = $clusterrunner::params::package_url,
) inherits clusterrunner::params {

  unless ($secret_key and is_string($secret_key)) {
    fail('clusterrunner: A secret_key is required')
  }
  validate_absolute_path($home)

  # Declare the install/config classes with appropriate relationships.
  class { 'clusterrunner::common::install':
    group       => $group,
    user        => $user,
    home        => $home,
    package_url => $package_url,
    before      => Class['clusterrunner::slave::config'],
  }

  class { 'clusterrunner::slave::config':
    master      => $master,
    master_port => $master_port,
    slave       => $slave,
    slave_port  => $slave_port,
    home        => $home,
    user        => $user,
    group       => $group,
    secret_key  => $secret_key,
    require     => Class['clusterrunner::common::install'],
  }

  class { 'clusterrunner::slave::service':
    ensure  => $ensure,
    user    => $user,
    group   => $group,
    require => Class['clusterrunner::slave::config'],
  }

}

