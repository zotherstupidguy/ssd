module SSD
  module Internals
    module Entity
      module ClassMethods
	def self.extended(base)
	  @@ssd_name  		= base.new.class.to_s.downcase
	  #FileUtils::mkdir_p 'DS'
	  #@@ssd_path 			= "DS/#{name}.pstore" 
	  #@@ssd_db 			= PStore.new @@ssd_path, true
	  #@@ssd_db.ultra_safe 	= true
	  #@@ssd_db.transaction(true) {}
	  #@@ssd_db
	end 

	def setup ssd 
	  @@ssd = ssd
	  FileUtils::mkdir_p ".ssd/#{@@ssd_name}"
	  @@ssd_path 		= ".ssd/#{@@ssd_name}/#{@@ssd}.ssd" 
	  @@ssd_db 			= PStore.new @@ssd_path, true
	  @@ssd_db.ultra_safe 	= true
	  @@ssd_db.transaction(true) {}
	  return @@ssd_db
	end

	def last_key ssd 
	  setup ssd
	  last_key = @@ssd_db.transaction true do
	    @@ssd_db.roots
	  end
	  last_key.last
	end

	def keys ssd
	  setup ssd
	  @@ssd_db.transaction true do
	    @@ssd_db.roots
	  end
	end

	def key? ssd 
	  setup ssd
	  @@ssd_db.transaction true do
	    @@ssd_db.root? ssd 
	  end
	end

	alias exists? key?

	def [] ssd 
	  setup ssd 
	  @@ssd_db.transaction true do
	    @@ssd_db[ssd]
	  end
	end

	def ssd ssd, default = nil
	  #TODO add raise if ssd.nil?
	  last_key = (last_key ssd) 
	  @@ssd_db.transaction true do
	    @@ssd_db.fetch last_key, default
	  end
	end

	#alias get ssd 
	#alias find ssd 

	def delete *ssds
	  @@ssd_db.transaction do
	    ssds.each do |ssd|
	      @@ssd_db.delete ssd.to_sym
	    end
	    @@ssd_db.commit
	  end
	end
	alias remove delete

	def count ssd
	  setup ssd 
	  $log.info("count")
	  return keys(ssd).count
	end
      end
    end
  end
end
