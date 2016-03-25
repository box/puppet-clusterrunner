# == Class: clusterrunner::install
#
# This class is meant to setup everything needed to install a
# ClusterRunner server.
#
class clusterrunner::common::install (
  $group,
  $user,
  $home,
  $package_url
) {

  group { $group:
    ensure => present,
  }

  user { $user:
    ensure         => present,
    gid            => $group,
    comment        => 'ClusterRunner service user',
    home           => $home,
    shell          => '/bin/bash',
    password       => '!!',
    managehome     => true,
  }

  file { "${home}/.clusterrunner":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
  }

  file { "${home}/.clusterrunner/dist":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => File["${home}/.clusterrunner"],
  }

  include archive
  archive { '/tmp/clusterrunner.tgz':
    ensure       => present,
    source       => $package_url,
    extract      => true,
    extract_path => "${home}/.clusterrunner/dist",
    user         => $user,
    group        => $group,
    require      => [ User[$user], File["${home}/.clusterrunner"] ],
  }

}
