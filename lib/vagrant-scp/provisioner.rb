require 'log4r'

module VagrantPlugins
  module Scp
    class ScpError < Vagrant::Errors::VagrantError
      error_namespace('vagrant.scp')
    end

    class Provisioner < Vagrant.plugin(2, :provisioner)
      def initialize(machine, config)
        super

        @logger = Log4r::Logger.new('vagrant::scp')
      end

      def configure(root_config)
        # Calculate the paths we're going to use based on the environment
        root_path = @machine.env.root_path

        @source_path = @config.source_path
        @destination_path = @config.destination_path
        @destination_user = @config.destination_user
      end

      def provision
        create_guest_path
        copy_files
        change_ownership
        verify_binary('puppet')
        run_puppet_apply
      end

      def create_guest_path
        @machine.communicate.tap do |comm|
          comm.sudo("mkdir -p #{@destination_path}")
          comm.sudo("chown -R #{@machine.ssh_info[:username]} #{@destination_path}")
        end
      end

      def copy_files
        recursive_scp(@source_path, @destination_path)
      end


      def change_ownership
        @machine.communicate.tap do |comm|
          comm.sudo("chown -R #{@destination_user} #{@destination_path}")
        end
      end

#      def verify_binary(binary)
#        @machine.communicate.sudo(
#          "which #{binary}",
#          :error_class => PuppetScpError,
#          :error_key => :not_detected,
#          :binary => binary)
#      end

      def recursive_scp(from, to)
        @machine.communicate.tap do |comm|
          comm.sudo("rm -rf #{to}")
          comm.sudo("mkdir -p #{to}")
          comm.sudo("chown #{@machine.ssh_info[:username]} #{to}")
        end

        Dir.glob("#{from}/**/*") do |path|
          to_path = path.gsub(from.to_s, '') # Remove the local cruft

          if File.directory?(path)
            @machine.communicate.execute("mkdir -p #{to}#{to_path}")
          else
            @machine.communicate.upload(path, "#{to}#{to_path}")
          end
        end
      end
    end
  end
end

