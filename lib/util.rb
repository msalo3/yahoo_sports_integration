class Util

  # Return an array of FlowLink-style objects
  # Input is an array of objects, each of which must contain the
  # 'as_flowlink_hash' method
  def self.flowlink_array objs
    flowlink_array = Array.new
    objs.each do |obj|
      flowlink_obj = obj.as_flowlink_hash
      if flowlink_obj.kind_of?(Array)
        flowlink_array += flowlink_obj
      else
        flowlink_array << flowlink_obj
      end
    end
    flowlink_array
  end

  # Merge an array of hashes into one big hash
  def self.merge_hashes hashes
    merged_hash = {}
    hashes.each do |hash|
      merged_hash.merge! hash
    end
    merged_hash
  end

end
