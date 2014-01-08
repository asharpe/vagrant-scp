module VagrantPlugins
  module Scp
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :source_path
      attr_accessor :destination_path
      attr_accessor :destination_owner
      attr_accessor :options

      def initialize
        super

        @source_path = UNSET_VALUE
        @destination_path = UNSET_VALUE
        @destination_owner = UNSET_VALUE
        @options = []
      end

      def finalize!
        super

        @source_path = Pathname.new(@source_path) if @source_path != UNSET_VALUE
        @destination_path = Pathname.new(@destination_path) if @destination_path != UNSET_VALUE
      end

      def validate(machine)
        errors = []

        errors += validate_source(@source_path)

        { "vagrant_scp provisioner" => errors }
      end

      def validate_source(source)
        errors = []

        if source == UNSET_VALUE
          errors << I18n.t("vagrant_scp.config.source_not_set")
        else
          if !source.exist?
            errors << I18n.t("vagrant_scp.config.source_not_exist", :path => source)
          elsif !source.file? and !source.directory?
            errors << I18n.t("vagrant_scp.config.source_not_file_or_dir", :path => source)
          end
        end

        errors
      end
    end
  end
end

