What is SSD?
==================
SSD is an append-only, file-based, immutable key-value store for Microservices written in Ruby. 

Key Features
=================
- **Scalable** via a schemaless, thread-safe, file-based design that easily meets your data evolution needs.
- **Immutable Append-only** tracks data evolution over time via out-of-the-box UTC timestamped appends (*accountants don't use erasers, otherwise they go to jail*).
- **Fault Tolerance** (out-of-the-box transactional operations).
- **Zero External Dependencies for a Measurably Low Technical Debt** (a well-maintained, consciously clean, lightweight library that prioritizes the sanity of your codebase and takes measures to **NEVER** complect it).
- **Key-based Forward\Backward Rolling**.
- **Super Easy to Learn and Use** (up & running in mins).

TODO
======
- Out-of-the-box Data Archiving 
- REPL console
- RAMDisk-based Server
- Server Web-based Admin Interface
- Strict hard-coded Security-first SHA256 Encryption policy (implment your own logging for intercepting keys required for decrypting data).
- JSON objects (based on ruby's native pstore).
- RESTful HTTP/JSON API Endpoint.

Use Cases
==========
SSD is carefully crafted to scale specially-well with the Microservies Architeturual Pattern to allow providing storage for independently deployable services with ease. 

Usage
======
```
gem install ssd
```

```ruby
# Simple Usage
  # writes to the store
  SSD.write("company_api/microservice_name/", "special_id", "this is a big value super funny")

  # returns the last value of the append-only store
  SSD.read("company_api/microservice_name/", "special_id")

  # Dumps all the store 
  SSD.dump("company_api/microservice_name/", "special_id")

end
```
Further more you can use ssd console commands to view the contents in a readable manner, 
SSD can use Marshal for performance(the default is yaml) but the ssd commands views it in yaml for readability
```bash
ssd view ./ssd/company_api/microservice_name/special_id
```

```ruby 
# Entity Usage
require 'sinatra/base'
require 'ssd'

module MyApp
  class User
    include SSD::Entity
    attr_accessor :id, :name, :bio
    def initialize
    end
  end

  class API < Sinatra::Base
    get '/' do 
      #####################  Writing  #####################  
      @user 		= MyApp::User.new
      @user.id	 	= "somekind_of_id_like_username_or_email"       

      # Set the ssd key of the object 
      @user.ssd 	= @user.id

      # Do what you wish with your object 
      @user.name 	= "Makki Omura"
      @user.bio	 	= "a charming girl!"

      # If you are ready to store your object to disk; Do an `append!` and viola! DONE 
      @user.append!              

      #####################  READING  #####################  
      # If you want to get your object back from disk; Use Klass.ssd(:ssd)
      result = MyApp::User.ssd("somekind_of_id_like_username_or_email")           
      result.name
    end
    run!
  end
end
```

Concerns FAQs
===============
Asynchronous I/O [https://en.wikipedia.org/wiki/Asynchronous_I/O]

Other Alternatives
======================
- ArangoDB  	[https://www.arangodb.com/].
- Persistent 	[https://github.com/ismasan/persistent].
- CouchDB 	[http://couchdb.apache.org/].
- DataMapper 	[http://github.com/datamapper/dm-core/tree/master]. 
- Persistable 	[http://github.com/andykent/persistable/tree/master].
- Stone 	[http://github.com/ndemonner/stone/tree/master].

References
===========
- The rise of append-only, immutable data stores. [http://www.pwc.com/us/en/technology-forecast/2015/remapping-database-landscape/features/assets/pwc-append-only-immutable-data-stores-rise.pdf]
- NoSQL DB. 	[http://nosql-database.org/]
- Anti-RDBMs. 	[https://www.metabrew.com/article/anti-rdbms-a-list-of-distributed-key-value-stores]
- Architecture of immutable data stores. [http://www.toadworld.com/platforms/oracle/w/wiki/11548.architecture-of-immutable-data-stores]
