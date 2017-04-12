module SSD
  module Internals
    module Entity
      module InstanceMethods

	def self.included(base)
	  @@ssd_name  		= base.new.class.to_s.downcase
	end

	attr_accessor :ssd

	def ssd= value
	  @ssd	= value
	  FileUtils::mkdir_p ".ssd/#{@@ssd_name}"
	  @@ssd_path 		= ".ssd/#{@@ssd_name}/#{@ssd}.ssd" 
	  @@ssd_db 		= PStore.new @@ssd_path, true
	  @@ssd_db.ultra_safe 	= true
	  @@ssd_db.transaction(true) {}
	  return @@ssd_db
	end

	def transaction
	  @@ssd_db.transaction do
	    yield @@ssd_db
	    @@ssd_db.commit
	  end
	end

	def []= 
	  @@ssd_path 		= ".ssd/#{@@ssd_name}/#{@ssd}.ssd" 
	  @@ssd_db 		= PStore.new @@ssd_path, true
	  begin  
	    if !@ssd.nil? then 
	      @@ssd_db.transaction do
		#todo should be somthing like??? timestamp instead of ssd as a key?? and use .last while reading
		@@ssd_db[Time.now.utc.to_s + "_" + Random.new_seed.to_s ] = self 
	      end
	    else
	      raise 'ssd key can not be nil. see more (documentation url)'  
	    end
	  end  
	end

	alias append! []= 
	  alias save! []= 
	  alias store! []= 
      end
    end
  end
end
