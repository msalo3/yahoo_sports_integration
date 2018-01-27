module Woocommerce
  class Image

    def initialize(hash)
      @id = hash['id']
      @src = hash['src']
      @position = hash['position']
      @name = hash['name']
      @alt = hash['alt']
    end

    def as_flowlink_hash
      {
        woocommerce_id: @id,
        url: @src,
        position: @position,
        name: @name,
        alt: @alt
      }
    end

  end
end
