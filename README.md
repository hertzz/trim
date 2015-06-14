# TRIM

**TRIM** is a simple URL shortening service that provides the ability to turn any sized URL into a much smaller link.
These links can be sent to anyone, and once clicked, will redirect a user to the website. Shortened URL's generated
with **TRIM** can be tracked by total redirects as well as individual redirects on a per-IP basis.

## Requirements
 - Ruby 2.1.x+
 - Rubygems
 - Bundler (gem)
 - MySQL server 5.0+ (you can use PostgreSQL, MSSQL, SQLite etc.. as well)
 - Apache/nginx/mod_passenger

## Setup
Clone the repository on your server, outside of the webservers publically accessible directories:
```sh
$ git clone git@github.com:tommyjohnson/trim.git /usr/local/
```

Install rubygems dependencies:
```sh
$ cd /usr/local/trim
$ bundle install
```

Modify appropriate database settings in the `/usr/local/trim/config/database.yml` file:
```yaml
production:
  <<: *default
  adapter: mysql2
  host: localhost
  port: 3306
  database: trim_production
  username: trim_user
  password: trim_password
```

Modify appropriate application settings in the `/usr/local/trim/config/application.yml` file:
```yaml
production:
  <<: *default
  base_url: 'https://mydomain.com'
```

Run the database initializer rake tasks:
```sh
$ rake db:create

# It isn't necessary to provide a specific migration version, however
# this can be specified if you wish to start migrations from a specific
# point in time.
$ rake db:migrate [MIGRATION_VERSION]
```

Start Unicorn:
```sh
$ unicorn -E production -o 0.0.0.0 -p 8080
```

## Contributors
Please refer to [CONTRIBUTORS.md](https://github.com/tommyjohnson/trim/blob/master/CONTRIBUTORS.md).

## License
Please refer to [LICENSE.md](https://github.com/tommyjohnson/trim/blob/master/LICENSE.md).
