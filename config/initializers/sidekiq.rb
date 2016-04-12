begin
  sidekiq_config = Rails.application.config_for(:sidekiq).symbolize_keys

  Sidekiq.configure_server do |config|
    config.redis = { url: sidekiq_config[:server_url], namespace: sidekiq_config[:server_namespace] }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: sidekiq_config[:client_url], namespace: sidekiq_config[:client_namespace] }
  end
rescue RuntimeError => e
  fail 'Sidekiq not configured'
end
