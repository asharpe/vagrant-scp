module Vagrant
  module Puppet
    module Scp
      class Config < Vagrant.plugin('2', :config)
        attr_accessor :manifest_file
        attr_accessor :manifests_path
        attr_accessor :modules_path
        attr_accessor :guest_path
        attr_accessor :options
        attr_accessor :facter

        def initialize
          super

          @manifest_file = UNSET_VALUE
          @manifests_path = UNSET_VALUE
          @modules_path = UNSET_VALUE
          @guest_path = UNSET_VALUE
          @options = []
          @facter = {}
        end

        def finalize!
          super

          @manifest_file = 'default.pp' if @manifest_file == UNSET_VALUE
          @manifests_path = 'manifests' if @manifests_path == UNSET_VALUE
          @modules_path = 'modules' if @modules_path == UNSET_VALUE
          @guest_path = '/etc/puppet' if @guest_path == UNSET_VALUE
        end

        def expanded_manifests_path(root_path)
          Pathname.new(manifests_path).expand_path(root_path)
        end

        def expanded_modules_path(root_path)
          Pathname.new(modules_path).expand_path(root_path)
        end

        def manifests_guest_path
          File.join(guest_path, manifests_path)
        end

        def modules_guest_path
          File.join(guest_path, modules_path)
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

