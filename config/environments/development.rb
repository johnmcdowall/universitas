Universitas::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  
  config.active_support.deprecation = :log
  
  config.action_mailer.default_url_options = { :host => 'universitas.dev' }
  
  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

	config.after_initialize do
	  Bullet.enable = false
	  Bullet.alert = true
	  Bullet.bullet_logger = true
	  Bullet.console = true
	  Bullet.rails_logger = true
	  Bullet.disable_browser_cache = true
	end
end
