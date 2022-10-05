namespace :review do
  desc 'Get review from airbnb'
  task execute: :environment do
    ReviewJob.perform_now
  end
end
