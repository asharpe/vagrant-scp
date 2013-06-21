module Vagrant
  module Puppet
    module Scp
      class Config < Vagrant.plugin('2', :config)
        attr_accessor :manifest_file
        attr_accessor :manifests_path
        attr_accessor :module_path
        attr_accessor :pp_path
        attr_accessor :options
        attr_accessor :facter

        def initialize
          super

          @manifest_file = UNSET_VALUE
          @manifests_path = UNSET_VALUE
          @module_path = UNSET_VALUE
          @pp_path = UNSET_VALUE
          @options = []
          @facter = {}
        end

        def finalize!
          super

          @manifest_file = 'default.pp' if @manifest_file == UNSET_VALUE
          @manifests_path = 'manifests' if @manifests_path == UNSET_VALUE
          @module_path = 'modules' if @module_path == UNSET_VALUE
          @pp_path = '/etc/puppet' if @pp_path == UNSET_VALUE
        end

        # Returns the manifests path expanded relative to the root path of the
        # environment.
        def expanded_manifests_path(root_path)
          Pathname.new(manifests_path).expand_path(root_path)
        end

        # Returns the module path expanded relative to the root path of the
        # environment.
        def expanded_module_path(root_path)
          Pathname.new(module_path).expand_path(root_path)
        end

        def manifests_guest_path
          File.join(pp_path, manifests_path)
        end

        def validate(machine)
          errors = []

          # Calculate the manifests and module paths based on env
          this_expanded_manifests_path = expanded_manifests_path(machine.env.root_path)
          this_expanded_module_path = expanded_module_path(machine.env.root_path)

          # Manifests path/file validation
          # TODO: Provide vagrant.provisioners.puppet_scp translations.
          if !this_expanded_manifests_path.directory?
            errors << I18n.t("vagrant.provisioners.puppet.manifests_path_missing",
                             :path => this_expanded_manifests_path)
          else
            expanded_manifest_file = this_expanded_manifests_path.join(manifest_file)
            if !expanded_manifest_file.file?
              errors << I18n.t("vagrant.provisioners.puppet.manifest_missing",
                               :manifest => expanded_manifest_file.to_s)
            end
          end

          # Module paths validation
          if !this_expanded_module_path.directory?
            errors << I18n.t("vagrant.provisioners.puppet.module_path_missing",
                             :path => path)
          end

          { "puppet_scp provisioner" => errors }
        end
      end
    end
  end
end

