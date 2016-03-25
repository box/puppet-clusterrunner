# Puppet ClusterRunner

[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Reference](#reference)
6. [Limitations](#limitations)
7. [Contributors](#contributors)
8. [Support](#support)
9. [Copyright and License](#copyright-and-license)

## Overview

This module installs and manages [ClusterRunner](http://www.clusterrunner.com/). ClusterRunner makes it easy to execute test suites across an infrastructure in the fastest and most efficient way possible.

## Module Description

This module installs the ClusterRunner package for both the master and the slave. It also sets up the configuration and services required to get ClusterRunner up and running.

## Setup

* This module will not alter any existing files or services.
* There are only two Puppet module dependencies:
  * [`stdlib`](https://forge.puppetlabs.com/puppetlabs/stdlib)
  * [`archive`](https://forge.puppetlabs.com/puppet/archive)

## Usage

To function, ClusterRunner requires a master host and one or more slaves.

**NOTE**: The user must ensure that the ClusterRunner master service is started **BEFORE** the ClusterRunner slave service can be started. This means that the order shown below must be followed.

Using this module, a ClusterRunner master is very easy to setup:

```puppet
class { 'clusterrunner::master':
  master      => 'clusterrunner-master.example.com',
  master_port => '3000',
  secret_key  => $secret_key # Generated SHA-512 hash for secret_key
}
```

After the master is up and running, the slave can be configured:
```puppet
class { 'clusterrunner::slave':
  master      => 'clusterrunner-master.example.com',
  master_port => '3000',
  slave       => 'clusterrunner-slave.example.com'
  slave_port  => '3001',
  secret_key  => $secret_key #The secret_key must be the same as the one passed to the master
}
```
This can be repeated for any number of slaves.

ClusterRunner requires that the masters and the slaves have bi-directional SSH access. This modules provides a class to do just that. An SSH key pair can be generated and passed to `clusterrunner::access` class and included on **BOTH** the master and the slave.

```puppet
class { 'clusterrunner::access':
  private_key => $private_key,
  public_key  => $public_key,
}
```

## Reference

### Class `clusterrunner::master`

Installs the ClusterRunner package in an appropriate location and with appropriate access rights on the ClusterRunner master server. It also ensures that the `clusterrunner_master` service is in the specified state.

#### Parameters

 * `master`: The hostname of the ClusterRunner master.

 * `master_port`: The port that the ClusterRunner master service should run on. Defaults to '43000'.

 * `secret_key`: The key that the master will use to validate API requests and requests from the slave. Should be a SHA-512 hash.

 * `user`: ClusterRunner service user. Defaults to 'clusterrunner'.

 * `group`: Group for the ClusterRunner service user. Defaults to 'clusterrunner'.

 * `home`: The home directory of the ClusterRunner service user. This is where the ClusterRunner package is installed. Defaults to '/usr/local/clusterrunner'.

 * `ensure`: The state of the `clusterrunner_master` service. It can either be 'running' or 'stopped'. Defaults to 'running'.

 * `package_url`: This parameter allows you to specify an alternate URL to the ClusterRunner GZIP Compressed Tar Archive (.tgz) file. By default, the ClusterRunner package is pulled from the public internet hosted on Box. This parameter is useful if access to the public internet is not available and/or internal hosting is preferred.

### Class `clusterrunner::slave`

Installs the ClusterRunner package in an appropriate location and with appropriate access rights on a particular ClusterRunner slave server. It also ensures that the ClusterRunner slave is connected to its specified master and that `clusterrunner_slave` service is in the specified state.

 * `slave`: The hostname of the ClusterRunner slave.

 * `slave_port`: The port that the ClusterRunner slave service should run on. Defaults to '43001'.

 * `master`: The hostname of the ClusterRunner master that the slave intends to connect to.

 * `master_port`: The port that the ClusterRunner master service is running on. Defaults to '43000'.

 * `secret_key`: The key that the master will use to validate API requests and requests from the slave. This MUST be the same as `secret_key` passed to the master.

 * `user`: ClusterRunner service user. Defaults to 'clusterrunner'.

 * `group`: Group for the ClusterRunner service user. Defaults to 'clusterrunner'.

 * `home`: The home directory of the ClusterRunner service user. This is where the ClusterRunner package is installed. Defaults to '/usr/local/clusterrunner'.

 * `ensure`: The state of the `clusterrunner_slave` service. It can either be 'running' or 'stopped'. Defaults to 'running'.

 * `package_url`: This parameter allows you to specify an alternate URL to the ClusterRunner GZIP Compressed Tar Archive (.tgz) file. By default, the ClusterRunner package is pulled from the public internet hosted on Box. This parameter is useful if access to the public internet is not available and/or internal hosting is preferred.

### Class `clusterrunner::access`

Ensures that the SSH public/private key pair is in the appropriate location on the server where this class is declared. This class is useful as it enables bi-directional SSH access between ClusterRunner master and slaves. Therefore, it should be included on both the master and the slave.

 * `public_key`: SSH public key.

 * `private_key`: SSH private key corresponding to the public key.

 * `user`: ClusterRunner service user. Defaults to 'clusterrunner'.

 * `group`: Group for the ClusterRunner service user. Defaults to 'clusterrunner'.

 * `home`: The home directory of the ClusterRunner service user. This is where the ClusterRunner package is installed. Defaults to '/usr/local/clusterrunner'.

## Limitations
Fully tested on Scientific Linux 6 and Ubuntu 14. Please open a pull request for problems encountered with other Linux systems.

## Contributors

The list of contributors can be found at: https://github.com/box/puppet-clusterrunner/graphs/contributors

## Support

Need to contact us directly? Email oss@box.com and be sure to include the name of this project in the subject.

## Copyright and License

Copyright 2016 Box, Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

