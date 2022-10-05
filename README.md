## Set environment
Set environment's variables
> rake secret

Add all variables for production

> export DATABASE_NAME=production_db

> export DATABASE_USERNAME=production_user

> export DATABASE_PASSWORD={your password}

## Install RoR
Install app dependencies
> bundle install

> bundle exec rake db:create

> bundle exec rake db:migrate
 

## Run parser
To run parser manually
> rake review:execute

To run parser every 24h
> whenever --update-crontab
