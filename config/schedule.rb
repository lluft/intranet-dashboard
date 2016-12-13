# Whenever cron manager http://github.com/javan/whenever

# Installed w/capistrano: deploy.rb

# Check output with
# $ bundle exec whenever --set 'environment=production'

set :output,  "#{path}/log/cron.log"
job_type :rake, "cd :path && PATH=/usr/local/bin:$PATH RAILS_ENV=:environment bundle exec rake :task --silent :output"

if environment == "test"
  every :day, :at => '1:30am' do
    rake "users:update_profiles"
  end

  every :sunday, :at => '5:45am' do
    rake "users:map_cmg_ids"
  end

  every :day, :at => '4:13am' do
    rake "delete_old_feed_entries"
  end
end

if environment == "production"
  every :day, :at => '0:30am' do
    rake "users:update_profiles"
  end

  every :sunday, :at => '5:15am' do
    rake "users:map_cmg_ids"
  end

  every :day, :at => '4:13am' do
    rake "delete_old_feed_entries"
  end
end
