namespace :promocodes do
  desc "Create 10.000 promocodes for eSova Sabac (launch)"
  task :codes => :environment do
    counter = 0
    until counter == 10000
      code = "SA" + SecureRandom.hex[0..5]
      Promocode.create!(code: code)
      counter+=1
    end
    puts counter
  end
end
