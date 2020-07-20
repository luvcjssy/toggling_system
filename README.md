##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby 2.7.1
- Rails 6.0.3.2

##### 2. Go to project directory

```bash
cd <path_to_project>
```

##### 3. Install gem
```bash
bundle install
```

##### 4. Create database.yml file

Edit the database configuration as required.

```bash
config/database.yml
```

##### 5. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

##### 6. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

##### 7. Information

User account test

```bash
hq_owner@example.com - 12345678
school_owner@example.com - 12345678
teacher@example.com - 12345678  
```

API authentication

```ruby
POST http://localhost:3000/api/v1/auth/sign_in

Request body:
{ "email":"teacher@example.com", "password":"12345678" }
```

API export

```ruby
GET http://localhost:3000/api/v1/exports/tracking?class_ids=1,2&school_ids=1,2
```

params `class_ids` for user has school owner role

params `school_ids` for user has school hq role