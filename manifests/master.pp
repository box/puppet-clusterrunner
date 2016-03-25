# == Class: clusterrunner::master
#
# Installs the ClusterRunner package in an appropriate location and with
# appropriate access rights on the ClusterRunner master server. It also ensures
# that the clusterrunner_master service is in the specified state.
#
# === Parameters
#
# [*master*]
#   The hostname of the ClusterRunner master.
#
# [*master_port*]
#   The port that the ClusterRunner master service should run on.
#   Defaults to '43000'.
#
# [*secret_key*]
#   The key that the master will use to validate API requests and requests
#   from the slave. Should be a SHA-512 hash.
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
#   The state of the clusterrunner_master service. It can either be 'running'
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
class clusterrunner::master (
  $master      = undef,
  $secret_key  = undef,
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
    before      => Class['clusterrunner::master::config'],
  }

  class { 'clusterrunner::master::config':
    master      => $master,
    master_port => $master_port,
    home        => $home,
    user        => $user,
    group       => $group,
    secret_key  => $secret_key,
    require     => Class['clusterrunner::common::install'],
  }

  class { 'clusterrunner::master::service':
    ensure  => $ensure,
    user    => $user,
    group   => $group,
    require => Class['clusterrunner::master::config'],
  }

}
