# == Class: clusterrunner::access
#
# Ensures that the SSH public/private key pair is in the appropriate location
# on the server where this class is declared. This class is useful as it
# enables bi-directional SSH access between ClusterRunner master and slaves.
# Therefore, it should be included on both the master and the slave.
#
# === Parameters
#
# [*public_key*]
#   SSH public key.
#
# [*private_key*]
#   SSH private key corresponding to the public key.
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
# === Authors
#
# Nadeem Ahmad
#
# === Copyright
#
# Copyright 2016 Box, Inc.
#
class clusterrunner::access(
  $public_key,
  $private_key,
  $home         = $::clusterrunner::params::home,
  $user         = $::clusterrunner::params::user,
  $group        = $::clusterrunner::params::group
) inherits clusterrunner::params {

  file { "${home}/.ssh":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }

  $key_type = 'ssh-rsa'
  $public_key_comment = 'key for using ClusterRunner'

  file { "${home}/.ssh/id_rsa.cr.pub":
    ensure  => file,
    content => "${key_type} ${public_key} ${public_key_comment}",
    owner   => $user,
    group   => $group,
    mode    => '0600',
  }

  ssh_authorized_key { $public_key_comment:
    user    => $user,
    type    => $key_type,
    key     => $public_key,
    require => File["${home}/.ssh"],
  }

  file { "${home}/.ssh/id_rsa.cr":
    ensure  => file,
    content => $private_key,
    owner   => $user,
    group   => $group,
    mode    => '0600',
  }

}
