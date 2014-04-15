class Contact < ActiveRecord::Base
  has_many :phones
  accepts_nested_attributes_for :phones

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true

  #validates :phones, length: {is: 3}

  def name
    [firstname, lastname].join(' ')
  end

  def self.by_letter(letter)
    where("lastname LIKE ?", "#{letter}%").order(:lastname)
  end

  def self.to_csv
    csv_string = ""
    self.all.each do |contact|
      csv = "#{contact.name},#{contact.email}\n"
      csv_string += csv
    end
    return csv_string
  end
end
