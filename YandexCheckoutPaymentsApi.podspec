Pod::Spec.new do |s|
  s.name      = 'YandexCheckoutPaymentsApi'
  s.version   = '1.4.0'
  s.homepage  = 'https://github.com/yandex-money/yandex-checkout-payments-api-swift'
  s.license   = {
    :type => "MIT",
    :file => "LICENSE"
  }
  s.authors = 'Yandex Checkout'
  s.summary = 'Yandex Checkout Payments Api iOS'

  s.source = { 
    :git => 'https://github.com/yandex-money/yandex-checkout-payments-api-swift.git',
    :tag => s.version.to_s 
  }

  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'

  s.ios.source_files  = 'YandexCheckoutPaymentsApi/**/*.{h,swift}', 'YandexCheckoutPaymentsApi/*.{h,swift}'

  s.ios.dependency 'FunctionalSwift', '~> 1.1.0'
  s.ios.dependency 'YandexMoneyCoreApi', '~> 1.7.0'
end
