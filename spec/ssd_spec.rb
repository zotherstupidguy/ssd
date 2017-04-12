require_relative "./spec_helper"

describe "SSD Store" do 
  before do
  end

  describe "it takes a location, a key, and a value to write it to store" do
    p SSD.write("company_api/microservice_name/", "special_id", "this is a big value super funny")
  end


  describe "it takes a location, a key to read the value from the store" do
    p " this is reading the last"
    p SSD.read("company_api/microservice_name/", "special_id")
  end

  describe "it takes a location, a key to read all the appended values from the store" do


    p " this is reading all"
    p SSD.dump("company_api/microservice_name/", "special_id")
  end

end

describe "SSD entity" do
  before do
    class User
      include SSD::Entity
      attr_accessor :id, :first_name, :last_name, :location

      def initialize id=""
	@id = id
	@ssd = @id 
      end
    end
    @generated_ssd = Random.new.seed
  end

  describe "#append!" do
    it "saves an object to the database" do
      @user 		= User.new @generated_ssd
      @user.append!
      @user.ssd.must_equal @generated_ssd
    end
  end

  describe "#read" do
    it "fetches an object from the database" do
      #    skip
      @user 		= User.new
      @user.ssd 	= @generated_ssd
      @user.append!
      user 		= User.ssd(@generated_ssd)
      user.ssd.must_equal @generated_ssd
    end
  end

  describe "an append!-only operations" do
    it "it keeps adding new objects" do
      @user 		= User.new

      @user.ssd		= @generated_ssd 
      @user.location	= "Egypt"
      @user.append!

      @user 		= User.ssd(@generated_ssd)
      @user.location 	= "Brazil"
      @user.append!

      @user 		= User.ssd(@generated_ssd)
      @user.location 	= "France"
      @user.append!

      User.count(@generated_ssd).must_equal 3
    end
  end

end
