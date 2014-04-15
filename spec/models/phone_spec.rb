# coding:utf-8
#
require 'spec_helper'

describe Phone do
  it "does not allow duplicate phone numbers per contact" do
=begin
    contact = Contact.create(
      firstname: 'Motoaki',
      lastname:  'Shibagaki',
      email:     'motoaki.shibagaki@gmail.com'
    )
    contact.phones.create(
      phone_type: 'home',
      phone:      '090-4234-2235'
    )
    mobile_phone = contact.phones.build(
      phone_type: 'mobile',
      phone:      '090-4234-2235'
    )
=end
    contact = create(:contact)
    create(:home_phone, contact: contact, phone: '090-4234-2235')
    mobile_phone = build(:mobile_phone, contact: contact, phone: '090-4234-2235')

    expect(mobile_phone).to have(1).errors_on(:phone)
  end

  it "allows two contacts to share a phone number" do
=begin
    contact = Contact.create(
      firstname: 'Motoaki',
      lastname:  'Shibagaki',
      email:     'motoaki.shibagaki@gmail.com'
    )

    contact.phones.create(
      phone_type: 'home',
      phone:      '090-4234-2235'
    )

    other_contact = Contact.new
    other_phone= other_contact.phones.build(
      phone_type: 'home',
      phone:      '090-4234-2235'
    )
    expect(other_phone).to be_valid
=end
    create(:home_phone, phone: '090-4234-2235')
    expect(build(:home_phone, phone: '090-4234-2235')).to be_valid

  end
end
