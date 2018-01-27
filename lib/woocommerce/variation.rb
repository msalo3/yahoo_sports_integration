module Woocommerce
  class Variation

    def initialize(hash, parent_id, parent_price, description, short_description)
      @sku = hash['sku']
      @id = hash['id'] == parent_id ? nil : hash['id']
      @parent_id = parent_id
      @shipping_category = ''
      @price = hash['price'].empty? ? parent_price : hash['price']
      @quantity = hash['manage_stock'] ? hash['stock_quantity'] : 0
      @description = description
      @short_description = short_description

      @images = []
      unless hash['images'].nil?
        hash['images'].each do |image|
          woo_image = Woocommerce::Image.new(image)
          @images << woo_image
        end
      end

      @attributes = []
      unless hash['attributes'].nil?
        hash['attributes'].each do |attribute|
          woo_attribute = Woocommerce::Attribute.new(attribute)
          @attributes << woo_attribute
        end
      end
    end

    def as_flowlink_hash
      {
        sku: @sku.to_s,
        woocommerce_id: @id.to_s,
        woocommerce_parent_id: @parent_id.to_s,
        shipping_category: @shipping_category,
        price: @price.to_s,
        quantity: @quantity,
        description: @description,
        meta_description: @short_description,
        images: Util.flowlink_array(@images),
        options: Util.merge_hashes(Util.flowlink_array(@attributes))
      }
    end

  end
end
