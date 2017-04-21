## Starting

1. Create `database.yml`, you could use `database.yml.sample` as a sample
2. run bundler `bundle install`
3. run migration `rake db:migrate`
4. run puma with application instance `rackup`

Now you have got application on `localhost:9292`

Im using swagger ui to explore api's you could do the same to explore `http://localhost:9292/swagger_doc`

or use

` curl -X GET "http://localhost:9292/dictionaries?page=1" -H  "accept: application/json" -H  "content-type: application/json" `

