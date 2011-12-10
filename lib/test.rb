require 'amazon_product'
require 'pp'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/png_outputter'
require 'yaml'

credentials = YAML::load(File.open(File.expand_path("../credentials.yml", __FILE__)))

req = AmazonProduct["us"]
req.configure do |c|
  c.key    = credentials['key']
  c.secret = credentials['secret']
  c.tag    = credentials['associate_tag']
end

=begin
req << { :operation    => 'ItemSearch',
           :search_index => 'All',
                    :keywords     => 'George Orwell' }
res = req.get
=end
res = req.find('B001OXUIIG', :response_group => 'Medium')

upc = res.to_hash['Items']['Item']['ItemAttributes']['UPC']
puts "upc: #{upc}"

barcode = Barby::Code39.new(upc)
File.open('/tmp/code39.png', 'w'){|f|
  f.write barcode.to_png(:xdim => 2, :ydim => 2)
}
