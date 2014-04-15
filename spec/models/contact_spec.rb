# coding:utf-8
#
require 'spec_helper'

describe Contact do
  before(:all) do
    @contact = Contact.new(
      firstname: 'Motoaki',
      lastname:  'Shibagaki',
      email:     'motoaki.shibagaki@gmail.com'
    )
  end

  it "is valid with a firstname, lastname, email" do
    #expect(@contact).to be_valid
    expect(build(:contact)).to be_valid
  end

  it "is invalid without a firstname" do
    #expect(Contact.new(firstname: nil)).to have(1).errors_on(:firstname)
    #expect(FactoryGirl.build(:contact, firstname: nil)).to have(1).errors_on(:firstname)
    expect(build(:contact, firstname: nil)).to have(1).errors_on(:firstname)
  end

  it "is invalid without a lastname" do
    #expect(Contact.new(lastname: nil)).to have(1).errors_on(:lastname)
    expect(FactoryGirl.build(:contact, lastname: nil)).to have(1).errors_on(:lastname)
  end

  it "is invalid without an email address" do
    #expect(Contact.new(email: nil)).to have(1).errors_on(:email)
    expect(FactoryGirl.build(:contact, email: nil)).to have(1).errors_on(:email)
  end

  it "is invalid with a duplicate email address" do
=begin
    Contact.create(
      firstname: 'Motoaki',
      lastname:  'Shibagaki',
      email:     'motoaki.shibagaki@gmail.com'
    )
    expect(@contact).to have(1).errors_on(:email)
=end
    FactoryGirl.create(:contact, email: "motoaki.shibagaki@gmail.com")
    contact = FactoryGirl.build(:contact, email: "motoaki.shibagaki@gmail.com")
    expect(contact).to have(1).errors_on(:email)
  end

  it "returns a contact's full name as a string" do
    #expect(@contact.name).to eq("Motoaki Shibagaki")
    contact = FactoryGirl.build(:contact, firstname: "Motoaki", lastname: "Shibagaki")
    expect(contact.name).to eq("Motoaki Shibagaki")
  end

  it "has  a valid factory" do
    expect(FactoryGirl.build(:contact)).to be_valid
  end

  describe "filter last name by letter" do
    before :each do
      @smith = Contact.create(
        firstname: 'John',
        lastname:  'Smith',
        email:     'jsmith@example.com'
      )
      @jones = Contact.create(
        firstname: 'Tim',
        lastname:  'Jones',
        email:     'tjones@example.com'
      )
      @johnson = Contact.create(
        firstname: 'John',
        lastname:  'Johnson',
        email:     'jjohnson@example.com'
      )
    end

    context "matching letters" do
      it "returns a sorted array of results that match" do
=begin
        smith = Contact.create(
          firstname: 'John',
          lastname:  'Smith',
          email:     'jsmith@example.com'
        )
        jones = Contact.create(
          firstname: 'Tim',
          lastname:  'Jones',
          email:     'tjones@example.com'
        )
        johnson = Contact.create(
          firstname: 'John',
          lastname:  'Johnson',
          email:     'jjohnson@example.com'
        )
=end
        expect(Contact.by_letter("J")).to eq [@johnson, @jones]
      end
    end

    context "non-matching letters" do
      it "returns a sorted array of results that match" do
        expect(Contact.by_letter("J")).to_not include @smith
      end
    end
  end

  it "has three phone numbers" do
    expect(create(:contact).phones.count).to eq 3
  end

  after(:all) do
    @contact = nil
  end
end
