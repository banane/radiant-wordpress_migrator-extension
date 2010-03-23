class WpOption < ActiveRecord::Base
  self.abstract_class = true
  establish_connection Radiant::Config['wpm.db_profilename']
  set_table_name 'wp_options'
  set_primary_key 'ID'
  
end