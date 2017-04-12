require 'fileutils'
require 'logger'
require 'securerandom'
require 'pstore'
require 'digest'
require 'yaml/store'

require_relative "./ssd/version"
require_relative "./ssd/internals"
$log = Logger.new(STDOUT)

module SSD 
  module Entity
    def self.included(base)
      base.send :include, SSD::Internals::Entity::InstanceMethods
      base.extend SSD::Internals::Entity::ClassMethods
    end
  end

  class Store
    
    def initialize path, key, value=nil
      @path = path
      @key = key
      @value = value
      FileUtils::mkdir_p ".ssd/#{@path}"
      @ssd_path 		= ".ssd/#{@path}/#{@key}.ssd" 

      #@ssd_db 			= PStore.new @ssd_path, true
      @ssd_db 			= YAML::Store.new @ssd_path, true

      @ssd_db.ultra_safe 	= true
      #@ssd_db.transaction(true) {}
    end

    def write
      #p "writing"
      @ssd_db.transaction do
	@ssd_db[Time.now.utc.to_s + "_" + @key.to_s ] = @value 
	#@ssd_db[@key.to_s] = @value 
      end
      @ssd_db
    end

    def dump
      p "dump all"
      # true sets it to be read-only transaction
      @ssd_db.transaction true do
	@ssd_db[@key.to_s]
      end
      @ssd_db
    end

    def read
      #setup ssd
      @ssd_db.transaction true do
	@ssd_db[@ssd_db.roots.last]
      end
    end

  end



  def self.write path, key, value
    ssd_db = Store.new path, key, value
    ssd_db.write
  end

  def self.read path, key 
    ssd_db = Store.new path, key
    ssd_db.read
  end

  def self.dump path, key 
    ssd_db = Store.new path, key
    ssd_db.dump
  end

end
