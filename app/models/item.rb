require 'amazon_product'
require 'pp'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/png_outputter'

class Item < ActiveRecord::Base
  attr_accessible :asin, :barcode
  attr_reader :upc
  before_create :get_item_info

  def barcode
    @barcode ||= Barby::Code39.new(upc).to_png if upc
  end

  private

  def get_item_info
    begin
      @upc = fetch_upc
      if upc.blank?
        puts "Sorry, couldn't locate a UPC or ISBN for that item. It may be online-only (e.g. a Kindle book)."
      else
        puts "UPC/ISBN is #{upc}"
      end
    rescue Exception => e
      puts "Caught an error: #{e}"
      # TODO invalidate model (cancel save)
    end
  end

  def fetch_upc
    req = AmazonProduct["us"]
    req.configure do |c|
      c.key    = AMAZON_KEY
      c.secret = AMAZON_SECRET
      c.tag    = ASSOCIATE_TAG
    end
    res = req.find(asin, :response_group => 'Medium')
    valid_req = res.to_hash['Items']['Request']['IsValid'] == 'True' ? true : false
    raise InvalidRequest and return unless valid_req
    errors = res.to_hash['Items']['Request']['Errors']
    if errors && errors.any?
      if errors['Error']['Code'] == 'AWS.InvalidParameterValue'
        raise "Invalid ASIN" and return
      else
        raise errors['Error']['Message'] and return
      end
    end
    item_attrs = res.to_hash['Items']['Item']['ItemAttributes']
    item_attrs['UPC'] || item_attrs['ISBN']
  end
end
