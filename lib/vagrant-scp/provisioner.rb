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

      def provision
        # TODO this is messy
        @destination_owner = @config.destination_owner
        @destination_owner = @machine.ssh_info[:username] if @config.destination_owner == ::Vagrant::Plugin::V2::Config::UNSET_VALUE

        copy_files
        change_ownership
      end

      def copy_files
        recursive_scp(@config.source_path, @config.destination_path)
      end

      def change_ownership
        @machine.communicate.tap do |comm|
          comm.sudo("chown -R #{@destination_owner} #{@config.destination_path}")
        end
      end

      def recursive_scp(from, to)
        if from.file?
          @machine.ui.info "uploading #{from} to #{to}"
          @machine.communicate.upload(from, to)

        elsif from.directory?
          # need to create the remote root
          @machine.communicate.tap do |comm|
            comm.sudo("rm -rf #{to}")
            comm.sudo("mkdir -p #{to}")
            comm.sudo("chown #{@machine.ssh_info[:username]} #{to}")
          end

          Dir.glob("#{from}/**/*") do |path|
            to_path = path.gsub(from.to_s, '') # Remove the local cruft

            if File.directory?(path)
              @machine.ui.info "making #{to}#{to_path}"
              @machine.communicate.execute("mkdir -p #{to}#{to_path}")
            else
              @machine.ui.info "uploading #{path} to #{to}#{to_path}"
              @machine.communicate.upload(path, "#{to}#{to_path}")
            end
          end
        end
      end
    end
  end
end

