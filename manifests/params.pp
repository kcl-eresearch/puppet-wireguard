# @summary
#  Class that contains OS specific parameters for other classes
class wireguard::params {
  $config_dir_mode    = '0700'
  $config_dir_purge   = false
  $manage_package     = true
  $config_dir         = '/etc/wireguard'
  $package_name       = 'wireguard-tools'
}
