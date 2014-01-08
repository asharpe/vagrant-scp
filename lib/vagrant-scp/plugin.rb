require_relative 'version'
require 'vagrant'

module VagrantPlugins
  module Scp
    class Plugin < Vagrant.plugin('2')
      name 'Scp'

      description <<-DESC
        Provides support for provisioning your virtual machines with SCP
      DESC

      config(:scp, :provisioner) do
        require_relative 'config'
        Config
      end

      provisioner(:scp) do
        require_relative 'provisioner'
        Provisioner
      end
    end
  end
end

