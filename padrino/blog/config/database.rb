##
# You can use other adapters like:
#
#   ActiveRecord::Base.configurations[:development] = {
#     :adapter   => 'mysql2',
#     :encoding  => 'utf8',
#     :reconnect => true,
#     :database  => 'your_database',
#     :pool      => 5,
#     :username  => 'root',
#     :password  => '',
#     :host      => 'localhost',
#     :socket    => '/tmp/mysql.sock'
#   }
#

require_relative '../app/helpers/clound_helper'

ActiveRecord::Base.configurations[:development] = {
  :adapter => 'sqlite3',
  :database => Padrino.root('db', 'blog_development.db')
}

credential = {
    'hostname' => 'localhost',
    'name' => 'blog_production',
    'username' => 'root',
    'password' => ''
}
if (VCAP_SERVICES = ENV['VCAP_SERVICES'])
  credential = CloundHelper.get_credentials(VCAP_SERVICES)
end

#VCAP_SERVICES={"cleardb-n/a":[{"name":"padrino-blog-demo","label":"cleardb-n/a","tags":["mysql","relational"],"plan":"spark","credentials":{"jdbcUrl":"jdbc:mysql://b27aac27ca6a1b:a7b68c28@us-cdbr-east-04.cleardb.com:3306/ad_258a5698a5d433a","uri":"mysql://b27aac27ca6a1b:a7b68c28@us-cdbr-east-04.cleardb.com:3306/ad_258a5698a5d433a?reconnect=true","name":"ad_258a5698a5d433a","hostname":"us-cdbr-east-04.cleardb.com","port":"3306","username":"b27aac27ca6a1b","password":"a7b68c28"}}]}
ActiveRecord::Base.configurations[:production] = {
  :adapter   => 'mysql2',
  :encoding  => 'utf8',
  :reconnect => true,
  :database  => credential['name'],
  :pool      => 5,
  :username  => credential['username'],
  :password  => credential['password'],
  :host      => credential['hostname']
}

ActiveRecord::Base.configurations[:test] = {
  :adapter => 'sqlite3',
  :database => Padrino.root('db', 'blog_test.db')
}

# Setup our logger
ActiveRecord::Base.logger = logger

# Raise exception on mass assignment protection for Active Record models.
ActiveRecord::Base.mass_assignment_sanitizer = :strict

# Log the query plan for queries taking more than this (works
# with SQLite, MySQL, and PostgreSQL).
ActiveRecord::Base.auto_explain_threshold_in_seconds = 0.5

# Include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = false

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper
# if you're including raw JSON in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Now we can establish connection with our db.
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])
