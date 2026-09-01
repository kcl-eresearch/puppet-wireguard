# @summary
#  Class installs wireguard packages and sets yum repository
# @param package_name
#   Name the package(s) that installs wireguard
# @param repo_url
#   URL of wireguard repo
# @param manage_repo
#   Should class manage yum repo
# @param manage_package
#   Should class install package(s)
# @param package_ensure
#   Set state of the package
class wireguard::install (
  Variant[Array, String] $package_name,
  Boolean                $manage_package,
  Variant[Boolean, Enum['installed','latest','present']] $package_ensure,
) {

  if $manage_package {
    package { $package_name:
      ensure  => $package_ensure;
    }
  }

  file {
    '/opt/puppetlabs/facter/facts.d/wireguard_interfaces.py':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0550',
      content => file('wireguard/facts.d/wireguard_interfaces.py');
  }
}
