require 'set'
require 'time'
require 'digest/sha1'
require 'openssl'

require_relative 'pagarme/version'
require_relative 'pagarme/core_ext'
require_relative 'pagarme/object'
require_relative 'pagarme/model'
require_relative 'pagarme/nested_model'
require_relative 'pagarme/transaction_common'
require_relative 'pagarme/request'
require_relative 'pagarme/errors'

Dir[File.expand_path('../pagarme/resources/*.rb', __FILE__)].map do |path|
  require path
end

module PagarMe
  class << self
    attr_accessor :api_endpoint, :open_timeout, :timeout, :api_key
  end

  self.api_endpoint = 'https://api.pagar.me/1'
  self.open_timeout = 30
  self.timeout      = 90
  self.api_key      = "ak_test_Ytru3s0YBc6Z5mDkGrBr6nIn1YLaGh"

  # TODO: Remove deprecated PagarMe.validate_fingerprint
  def self.validate_fingerprint(*args)
    raise '[Deprecation Error] PagarMe.validate_fingerprint is deprecated, use PagarMe::Postback.valid_request_signature? instead'
  end
end
