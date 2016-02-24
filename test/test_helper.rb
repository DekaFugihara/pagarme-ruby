require 'test/unit'
require 'shoulda'
require 'webmock'
require 'pry'
require 'vcr'

require_relative '../lib/pagarme'
require_relative 'assertions'
require_relative 'fixtures'

VCR.configure do |config|
  config.cassette_library_dir                         = 'test/vcr_cassettes'
  config.default_cassette_options[:match_requests_on] = [:method, :uri, :host, :path, :query, :body, :headers]
  config.default_cassette_options[:record]            = :new_episodes
  config.hook_into :webmock
end

class Test::Unit::TestCase
  include Fixtures::Helpers
  include Assertions

  def setup
    PagarMe.api_key = temporary_api_key
  end

  def teardown
    PagarMe.api_key = nil
  end

  protected
  def ensure_positive_balance
    VCR.use_cassette 'TestCase/ensure_positive_balance' do
      transaction = PagarMe::Transaction.charge transaction_with_boleto_params(amount: 100_000_00)
      transaction.status = :paid
      transaction.save
    end
  end

  def temporary_api_key
    VCR.use_cassette 'TestCase/tmp_company_api_key' do
      PagarMe.api_key = 'ak_test_Rw4JR98FmYST2ngEHtMvVf5QJW7Eoo'
      PagarMe::Request.post('/companies/temporary').run['api_key']['test']
    end
  end

  def temp_api_key_path
    File.expand_path '../aki_key.txt', __FILE__
  end

  # Monkey Patch that adds VCR everywhere
  def self.should(description, &block)
    cassette_name = "#{ self.name.split('::').last }/should_#{ description.gsub /\s+/, '_' }"
    super(description){ VCR.use_cassette(cassette_name){ self.instance_exec &block } }
  end
end
