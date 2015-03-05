load File.dirname(__FILE__) +  '/../test_helper.rb'


class Transaction_complete < Test::Unit::TestCase 
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
    @driver.quit
    assert_equal [], @verification_errors
  end
  
# Test to create a quote and convert to order and invoice and make payment for both order and invoice.
  def test_transaction_complete
     
      check_product

      getElement_text("Companies").click

      getElement_text("company_name_data").click

      getElement_xpath("company_actions").click

      getElement_text("Quote").click

      quote_name = "Automation Quote "+get_Present
      getElement_placeholder("Title").send_keys quote_name
       
      getElement_placeholder_text("About this quote").send_keys "Created by using Automation"
      
      getElement_xpath("save").click

      wait_for_ajax(@driver)

      puts "Transaction name "+getElement_xpath("trans_name").text

      add_line_item

      quote_name = getElement_xpath("company_name").text

      getElement_xpath("quote_more").click

      getElement_text("To_order").click

      getElement_xpath("save").click

      getElement_xpath("alert_yes").click

      sleep(3)

      order_name = getElement_xpath("company_name").text

      check = compare(quote_name,order_name)

      if(check)
        puts "Quote not Converted to Order."
      else
        puts "Quote Converted to Order"
      end

      #make_payment
      getElement_xpath("quote_more").click
      getElement_text("To_invoice").click
      getElement_xpath("save").click
      puts "Order Converted to Invoice"
   end

    def make_payment
      getElement_xpath("store_name").click
      mouseHover(getElement_xpath("pos_settings"))
      getElement_xpath("payments").click
      status = check_required("payment_name")

       # creates required sales lead if not available
      if(!status)
        getElement_xpath("pipeline_new").click
        getElement_id("payment_name_id").send_keys Keys_CONFIG["payment_name"]
        getElement_xpath("commit").click
        puts getElement_xpath("category_success").text
      end
    end

    def compare(val1,val2)
        puts "inside compare"
        status = false
        if(val1.eql?val2)
          status = true
        end
        status
    end
end
