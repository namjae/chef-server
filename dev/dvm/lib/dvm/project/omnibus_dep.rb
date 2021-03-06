module DVM
  class OmnibusDep < Dep
    attr_reader :source_path, :dest_path, :reconfigure_on_load
    def initialize(base_dir, name, config)
      super(name)
      @source_path = File.join("#{base_dir}/files", config['source_path'])
      @dest_path = config['dest_path']
      @reconfigure_on_load = config['reconfigure_on_load']
      @available = true
    end
    def unload
      unmount(source_path)
      if reconfigure_on_load
        run_command("chef-server-ctl reconfigure", "Reconfiguring chef server to pick up the changes")
      end
    end
    def load(opts)
      bind_mount(source_path, dest_path)
      if reconfigure_on_load and not opts[:no_build]
        run_command("chef-server-ctl reconfigure", "Reconfiguring chef server to pick up the changes")
      end
    end
    def loaded?
      path_mounted? source_path
    end
  end
end


