dir = File.dirname(__FILE__)

require 'rasta/fixture/rasta_fixture'
require "#{dir}\/..\/depot_defs"
require 'test/unit'
require 'watir'
require 'watir/testcase'

#
#  This file requires buy_books.xls and the rasta gem 
#

$site = "http://localhost:3000/store"

class Purchase_Book
#class DepotFunctions
  include Rasta::Fixture::RastaFixture
  attr_accessor  :test_case, :selected_book, :name, :email, :address, :pay_using

  include Depot_Defs
  include Test::Unit::Assertions
  include Watir::Assertions
   
  def add_book_to_cart
    puts "\nStarting test case #{test_case}\n"
    goto_site($site)
    add_book_to_cart_link("#{selected_book}")
    return true
  end
  def check_address
    return shipping_address_text_field.value
  end
  def check_email
    return shipping_email_text_field.value
  end
  def check_name
    return shipping_name_text_field.value
  end
  def check_pay_using
    if pay_using_list.selected?"#{pay_using}"
      return "#{pay_using}"
    end
  end
  def check_total
    return purchase_total_cell.text
  end
  def checkout
    link_by_text_click("Checkout")
    return true
  end
  def clear_buyers_information
    shipping_name_text_field.set''
    shipping_email_text_field.set''
    shipping_address_text_field.set''
    goto_site($site+"\/display_cart")
    link_by_text_click("Empty cart")
    return true
  end
  def enter_buyers_information
    verify(shipping_name_text_field.value == '', "Shipping name is not blank")
    verify(shipping_email_text_field.value == '', "Shipping email is not blank")
    verify(shipping_address_text_field.value == '', "Shipping address is not blank")
    shipping_name_text_field.set("#{name}")
    shipping_email_text_field.set("#{email}")
    shipping_address_text_field.set"#{address}"
    pay_using_list.select"#{pay_using}"
    return true
  end
  def pay_using_list
    $br.select_list(:id, 'order_pay_type')
  end   

end