class WpCategory < ActiveRecord::Base
  self.abstract_class = true
  establish_connection Radiant::Config['wpm.db_profilename']
  set_table_name 'wp_categories'
  set_primary_key 'cat_ID'
  
  has_many :wp_post2cat, :foreign_key => 'category_id'
  has_many :wp_posts, :through => 'wp_post2cat'
  
  def self.move_to_radiant
    logger.debug "hello in model  *************************************"
      WpCategory.find(:all).each do |cat|
        MetaTag.find_or_create_by_name(cat.cat_name.strip.squeeze(' '))
    end
  end
end