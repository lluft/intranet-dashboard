DashboardKomin::Application.configure do
  config.action_controller.relative_url_root = "/dashboard-2.0"
  config.cache_classes = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.static_cache_control = "public, max-age=3600"
  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :yui
  config.assets.compile = false
  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end
