FactoryBot.define do
  
  factory :account do
    user_id { 1 }
    identity { "MyString" }
    confirmed { false }
    primary { false }
  end
  
end
