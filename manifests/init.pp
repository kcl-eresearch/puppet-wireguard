# @summary
#   Wireguard class manages wireguard - an open-source software application
#   and protocol that implements virtual private network techniques to create
#   secure point-to-point connections in routed or bridged configurations.
# @see https://www.wireguard.com/
# @param package_name
#   Name the package(s) that installs wireguard
# @param manage_package
#   Should class install package(s)
# @param package_ensure
#   Set state of the package
# @param config_dir
#   Path to wireguard configuration files
# @param config_dir_mode
#   The config_dir access mode bits
# @param interfaces
#   Define wireguard interfaces
class wireguard (
  Variant[Array, String] $package_name     = $wireguard::params::package_name,
  Boolean                $manage_package   = $wireguard::params::manage_package,
  Variant[Boolean, Enum['installed','latest','present']] $package_ensure = 'installed',
  Stdlib::Absolutepath   $config_dir       = $wireguard::params::config_dir,
  String                 $config_dir_mode  = $wireguard::params::config_dir_mode,
  Boolean                $config_dir_purge = $wireguard::params::config_dir_purge,
  Optional[Hash]         $interfaces       = {},
) inherits wireguard::params {

  class { 'wireguard::install':
    package_name   => $package_name,
    package_ensure => $package_ensure,
    manage_package => $manage_package,
  }
  -> class { 'wireguard::config':
    config_dir       => $config_dir,
    config_dir_mode  => $config_dir_mode,
    config_dir_purge => $config_dir_purge,
  }
  -> Class[wireguard]

  $interfaces.each |$name, $options| {
    wireguard::interface { $name:
      * => $options,
    }
  }
}
