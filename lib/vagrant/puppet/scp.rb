require 'vagrant/puppet/scp/version'
require 'vagrant'

module Vagrant
  module Puppet
    module Scp
      class Plugin < Vagrant.plugin('2')
        name 'puppet_scp'
        description <<-DESC
        Provides support for provisioning your virtual machines with
        Puppet using `puppet apply`. Manifests are copied using SCP.
        DESC

        config(:puppet_scp, :provisioner) do
          require 'vagrant/puppet/scp/config'
          Config
        end

        provisioner(:puppet_scp) do
          require 'vagrant/puppet/scp/provisioner'
          Provisioner
        end
      end
    end
  end
end
