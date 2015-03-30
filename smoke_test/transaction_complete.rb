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
      check_payment_method

      getElement_text("Companies").click

      getElement_text("company_name_data").click

      getElement_xpath("company_actions").click

      getElement_text("Quote").click

      quote_name = "Automation Quote "+get_Present
      getElement_placeholder("Title").send_keys quote_name
       
      getElement_placeholder_text("About this quote").send_keys "Created by using Automation"
      
      getElement_xpath("save").click

      sleep(5)

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
      sleep(5)

      make_payment_order
      getElement_xpath("quote_more").click
      getElement_text("To_invoice").click
      getElement_xpath("save").click
      puts "Order Converted to Invoice"
      make_payment_invoice
   end

    def check_payment_method
      getElement_xpath("store_name").click
      mouseHover(getElement_xpath("pos_settings"))
      getElement_xpath("payments").click
      status = check_required("payment_name")

       # creates required payment method if not available
      if(!status)
        getElement_xpath("pipeline_new").click
        getElement_id("payment_name_id").send_keys Keys_CONFIG["payment_name"]
        getElement_xpath("commit").click
        puts getElement_xpath("category_success").text
      end
    end

    def make_payment_order
      initial_payment  = getElement_xpath("payment_total").text
      puts "initial payment : #{initial_payment}"

      getElement_xpath("quote_more").click
      #getElement_text("To_invoice").click
      sleep(5)
      getElement_text("Record_payment").click
      sleep(5)
      getElement_xpath("payment_type").send_keys Keys_CONFIG["payment_name"]
      amount = 10
      getElement_placeholder("Amount").send_keys amount

      for i in 1..100
        xpath = Keys_CONFIG["order_selected_start"]+"#{i}"+Keys_CONFIG["order_selected_end"]
        checked = getElement_xpath(xpath,"d").selected?
        if(checked == true)
          xpath = "//div[@class='table-responsive'][2]/table/tbody[#{i}]/tr/td[5]/div/text-field/div/div/input"
          getElement_xpath(xpath,"d").clear
          getElement_xpath(xpath,"d").send_keys amount
          break
        end
      end
      getElement_xpath("save").click
      sleep(5)
      getElement_text("sales_orders").click
      sleep(3)
      
      getElement_xpath("payment_order").click
      new_payment  = getElement_xpath("payment_total").text
      puts "New payment : #{new_payment} "       
    end

    def make_payment_invoice

      initial_payment  = getElement_xpath("payment_total").text
      puts "initial payment : #{initial_payment}"

      getElement_xpath("quote_more").click
      sleep(5)
      getElement_text("Record_payment").click
      sleep(5)
      #getElement_xpath("payment_type").send_keys Keys_CONFIG["payment_name"]
      getElement_xpath("payment_type").send_keys "CASH"
      amount = 10
      getElement_placeholder("Amount").clear
      getElement_placeholder("Amount").send_keys amount
      getElement_xpath("record_payment").click
      sleep(5)
      new_payment  = getElement_xpath("payment_total").text
      puts "New payment : #{new_payment} "   
    end
end
