require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Teacup
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.enable_dependency_loading = true
    # Rails 5 disabled autoloading in production
    config.autoload_paths << Rails.root.join("lib")
    #config.autoload_paths << "#{Rails.root}/lib"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_cable.mount_path = '/cable'
  end
end
