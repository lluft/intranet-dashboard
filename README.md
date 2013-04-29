# Intranet Dashboard

The Intranet Dashboard, “Min sida”, is City of Malmö’s personalized intranet front. Information and tools on the dashboard are targeted for the employee based on roles and her own preferences. The dashboards core functionality is:

* Targeted and user selected news from the organization and external resources.
* Searchable employee information with data compiled from other systems and a self service interface where the employees can update their information.
* Direct access to tools and applications based on the user’s roles and profile.
* Enterprise search for all intranet resources.
* User managed portrait pictures. The system acts as an avatar service for other intranet systems.

For more information about the Intranet Dashboard, contact kominteamet@malmo.se.

## Dependencies
* Ruby >=1.9.3
* Ruby on Rails >=3.2
* MySQL or PostgreSQL
* Memcached or another cache store with ttl support
* LDAP or a SAML 2.0 IdP for authentication
* LDAP directory for employee attributes
* ImageMagick
* PhantomJS (for testing)
* Asset files from an [asset host](https://github.com/malmostad/intranet-assets)

## Development Setup
Use `app_config.yml.example` and `database.yml.example` as templates for you own settings. Install the dependencies. Run the following to install the required Ruby Gems, create the database and start the application:

```shell
$ bundle install
$ rake db:schema:load
$ rails s
```

Note: Use only `rake db:schema:load` on an empty database, otherwise use `rake db:migrate`.

## Build and Deployment
The application is built and deployed using Capistrano. Deployment scripts are included in the source code. To set your deployment configuration:

1. Copy `config/deploy.yml.example` to `config/deploy.yml` and change the settings.
2. Edit `config/deploy.rb` and the environment files in the `config/deploy/` directory if needed.

Run the deployment script with one of the following command including the environment name:

```
$ cap staging deploy
$ cap production deploy
```

A database backup is performed on the server before deployment. Database migrations and `bundle` are run before the application i restarted. The Feed Worker daemon is restarted after the application is restarted.

## Testing
Run tests before pushing to the repository and performing deployments. The application contains high level integration/feature tests and unit tests using RSpec, Capybara and PhantomJS. To run all test cases:

```shell
$ rspec
```

Guard is used for continuous testing during development:

```shell
$ bundle exec guard
```

## Feed Worker
The feed worker updates all news feeds that are in use in the dashboard. It runs as a daemon. The aggressiveness is defined in `app_config.yml`. The daemon is started/restarted by the Capistrano deployment in staging and production. To run it in development, execute the following:

```shell
$ RAILS_ENV=development lib/daemons/feed_worker_ctl start
```

You can use the `status` and `stop` commands for the daemon. Stop is made gracefully so the worker will run until the current batch is finished. Results are written to the log file.

You can also use the following Rails console command to run the feed updates once:

```shell
$ rails c
$ FeedWorker.update_all
```

A feed is always fetched and feed entries are updated when it is added or changed by a user. This is part of the validation process.

## Scheduled Jobs
The `whenever` gem is used to add database maintenance rake tasks to cron. Change the settings in schedule.rb to match your staging and production environments. Capistrano runs `whenever` during deployment.

## LDAP Sync Worker
Syncing of LDAP attributes for all employees in the system is made with a worker and runs as a scheduled job defined in the `whenever` script `schedule.rb`.

## Avatar Service
The system contains management of employee portraits and is used as an avatar service for other applications on the intranet with a REST API. Pre-defined image sizes are generated when an employee uploads a new picture.

## Intranet Search Interface
The system contains an integration with the Siteseeker search engine. The search contains results from all intranet systems.


## License
Released under AGPL version 3.
