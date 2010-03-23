# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class WordpressMigratorExtension < Radiant::Extension
  version "1.1"
  description "Tools to migrate from a WordPress database"
  url "http://saturnflyer.com"
  
  class MissingDependency < StandardError; end
 
  define_routes do |map|
    map.with_options :controller => 'wordpress_migrator' do |t|
      t.wordpress_migrator '/admin/wordpress_migrator', :action => "edit"
    end
  end
  
  def activate 
    tab "Content" do
      add_item("WordPress Migrator", "/admin/wordpress_migrator")
    end
  end
  
  def deactivate
  end
  
end
