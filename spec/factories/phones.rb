# coding: utf-8

require 'faker'

FactoryGirl.define do
  factory :phone do
    association :contact
    #phone {'090-4234-2235'}
    phone { Faker::PhoneNumber.phone_number }

    factory :home_phone do
      phone_type 'home'
    end

    factory :work_phone do
      phone_type 'work'
    end

    factory :mobile_phone do
      phone_type 'mobile'
    end
  end
end
