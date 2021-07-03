module SolidusRazorpay
  class Engine < Rails::Engine
    require 'solidus/core'
    isolate_namespace Solidus
    engine_name 'solidus_razorpay'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer 'solidus.gateway.payment_methods', after: 'solidus.register.payment_methods' do |app|
      app.config.solidus.payment_methods << Solidus::Gateway::RazorpayGateway
    end

    config.to_prepare &method(:activate).to_proc
  end
end
