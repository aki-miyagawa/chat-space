FactoryBot.define do
  factory :message do
    content { Faker::Lorem.sentence }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/image.jpg'))}
    #image File.open("#{Rails.root}/public/images/no_image.jpg")
    group
    user
  end
end


