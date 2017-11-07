require './test/test_helper'

class BlupeeEtherTest < Minitest::Test
  def test_exists
    assert Blupee::Ether
  end

  def test_it_gives_back_a_single_car
    VCR.use_cassette('one_wallet') do
      car = Blupee::Ether.find("0xad96B1072E60f6279F628E7512242F9b1A83127F")
      assert_equal Blupee::Ether, ether.class

      # Check that the fields are accessible by our model
      assert_equal 0.00443, ether.balance
      assert_equal "0xad96B1072E60f6279F628E7512242F9b1A83127F", ether.wallet
      assert_equal "ETH", ether.coin_symbol
    end
  end

  def test_it_gives_back_all_the_cars
    VCR.use_cassette('all_cars') do
      result = Blupee::Ether.all

      # Make sure we got all the cars
      assert_equal 1, result.length

      # Make sure that the JSON was parsed
      assert result.kind_of?(Array)
      assert result.first.kind_of?(Blupee::Ether)
    end
  end
end

