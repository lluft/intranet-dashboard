require 'elasticsearch/rails/tasks/import'
Rake::TaskManager.record_task_metadata = true

namespace :elasticsearch do
  desc "Zero downtime re-indexing
  $ rake environment elasticsearch:reindex CLASS='Model_name' ALIAS='alias_name'"
  task reindex: :environment do |task|
    if ENV['CLASS'].blank? || ENV['ALIAS'].blank?
      puts "USAGE:"
      puts task.full_comment
      exit(1)
    end

    ENV["FORCE"] = 'y' # must be set to force mapping
    ENV['INDEX'] = "#{ENV['ALIAS']}_#{Time.new.strftime('%Y%m%d%H%M%S')}"

    client = Elasticsearch::Client.new
    has_alias = client.indices.exists_alias name: ENV["ALIAS"]
    old_indices = has_alias ? client.indices.get_alias(name: ENV["ALIAS"]).map {|k,v| k } : []

    # Creat new index, command line arguments are used
    Rake::Task["elasticsearch:import:model"].invoke

    client.indices.delete_alias(index: "*", name: ENV["ALIAS"]) if has_alias
    client.indices.put_alias(index: ENV['INDEX'], name: ENV["ALIAS"])
    client.indices.delete(index: old_indices) if old_indices.present?
  end
end
