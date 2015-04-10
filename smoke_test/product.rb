load File.dirname(__FILE__) +  '/../test_helper.rb'


class Login < Test::Unit::TestCase 
  fixtures :users

#To open firefox browser and the application url
  def setup
    @driver = get_driver
    login
    @accept_next_alert = true
    @verification_errors = [] 
  end
# Throws an assertion errors
  def teardown
    #@driver.quit
    assert_equal [], @verification_errors
  end
  
# Test to create a product with basic pricing
  def test_create_product    
       check_product
   end

  # Test to creat a product with pricing type "Formula" 
  def test_create_product_formula
      
  end

end
