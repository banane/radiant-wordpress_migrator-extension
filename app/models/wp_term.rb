class WpTerm < ActiveRecord::Base
  self.abstract_class = true
  establish_connection Radiant::Config['wpm.db_profilename']
  set_table_name 'wp_terms'
  set_primary_key 'term_ID'
  
  has_many :wp_post2term, :foreign_key => 'term_id'
  has_many :wp_posts, :through => 'wp_post2term'
  
  def self.move_to_radiant
    WpTerm.find(:all).each do |tag|
      MetaTag.find_or_create_by_name(tag.tag.strip.squeeze(' '))
    end
  end
end