module VagrantPlugins
  module Scp
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :source_path
      attr_accessor :destination_path
      attr_accessor :destination_owner
#      attr_accessor :guest_path
      attr_accessor :options

      def initialize
        super

        @source_path = UNSET_VALUE
        @destination_path = UNSET_VALUE
        @destination_owner = UNSET_VALUE
#        @guest_path = UNSET_VALUE
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

        # Calculate the manifests and module paths based on env
#        this_expanded_manifests_path = expanded_manifests_path(machine.env.root_path)
#        this_expanded_modules_path = expanded_modules_path(machine.env.root_path)
#
#        # Manifests path/file validation
#        # TODO: Provide vagrant.provisioners.puppet_scp translations.
#        source = Pathname.new(@source_path)
#        if ! Pathname.new(@source_path).exist?
#          errors << I18n.t("vagrant_scp.config.source_not_exist",
#                           :path => @source_path)
#        elsif ! 
#          expanded_manifest_file = this_expanded_manifests_path.join(manifest_file)
#          if !expanded_manifest_file.file?
#            errors << I18n.t("vagrant.provisioners.puppet.manifest_missing",
#                             :manifest => expanded_manifest_file.to_s)
#          end
#        end
#
#        # Module paths validation
#        if !this_expanded_modules_path.directory?
#          errors << I18n.t("vagrant.provisioners.puppet.module_path_missing",
#                           :path => path)
#        end

        { "puppet_scp provisioner" => errors }
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

