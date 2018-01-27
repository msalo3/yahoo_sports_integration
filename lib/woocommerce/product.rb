module Woocommerce
  class Product

    def initialize(hash, variations, source, id_prefix)
      @id = (id_prefix.nil? ? '' : id_prefix) + hash['id'].to_s
      @name = hash['name']
      @description = hash['description']
      @short_description = hash['short_description']
      @sku = hash['sku']
      @source = source
      @price = hash['price']

      @variations = []
      if variations.length > 0
        variations.each do |variation|
          woo_variation = Woocommerce::Variation.new(variation, @id, @price, @description, @short_description)
          @variations << woo_variation
        end
      else
        woo_variation = Woocommerce::Variation.new(hash, @id, @price, @description, @short_description)
        @variations << woo_variation
      end

      @images = []
      unless hash['images'].nil?
        hash['images'].each do |image|
          woo_image = Woocommerce::Image.new(image)
          @images << woo_image
        end
      end

      @options = []
      unless hash['attributes'].nil?
        hash['attributes'].each do |attribute|
          @options << attribute['name']
        end
      end
    end

    def as_flowlink_hash
      {
        id: @id.to_s,
        woocommerce_id: @id.to_s,
        source: @source,
        name: @name,
        sku: @sku,
        description: @description,
        meta_description: @short_description,
        price: @price,
        variants: Util.flowlink_array(@variations),
        images: Util.flowlink_array(@images),
        options: @options
      }
    end

  end
end
