# frozen_string_literal: true

RSpec.configure do |config|
  # Verify partial doubles to catch mistakes
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Randomize test order to catch dependencies
  config.order = :random
  Kernel.srand config.seed
end
