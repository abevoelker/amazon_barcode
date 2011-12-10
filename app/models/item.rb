require 'amazon_product'
require 'pp'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/png_outputter'

class Item < ActiveRecord::Base
  attr_accessible :asin, :barcode
  attr_reader :upc
  before_create :fetch_upc

  def barcode
    @barcode ||= get_barcode
  end

  private

  def fetch_upc
    req = AmazonProduct["us"]
    req.configure do |c|
      c.key    = AMAZON_KEY
      c.secret = AMAZON_SECRET
      c.tag    = ASSOCIATE_TAG
    end
    res = req.find(asin, :response_group => 'Medium')
    @upc = res.to_hash['Items']['Item']['ItemAttributes']['UPC']
  end

  def get_barcode
    Barby::Code39.new(@upc).to_png
  end
end
