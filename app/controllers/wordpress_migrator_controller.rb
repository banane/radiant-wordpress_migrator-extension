class WordpressMigratorController < ApplicationController
  def edit
    if request.post? 
      # 2.1 vs. 2.3 determines whether there's a categories table
            
      @config['wpm.db_profilename'] = params['db_profilename']
      @config['wpm.wp_version'] = params['wp_version']      
              
      if WpUser.move_to_radiant
        flash[:notice] = 'Users moved.'
  #      format.html { render :action => "index" }
      else
        format.html { render :action => "index" }
        format.xml { render :xml => WpUsers.errors, :status => :unprocessable_entity }
      end
      
      # logic to determine the wordpress version (which is stored in a .php file not in db! and db_version
      # in wp_options is simply an incremented value of local interest only

      logger.debug "outside unless wp_cat thing *************************************"    

      cat_flag = 0
      if Radiant::Config['wp_version'] == ''
        cat_flag = 1 if WpCategory.exists?
      end
      
      logger.debug "#{cat_flag.to_s} <= is the cat flag &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
      
  #    cat_flag= 0
      if cat_flag == 1
        if WpCategory.move_to_radiant
          flash[:notice] = "categories moved, if present"
        else
          flash[:error] = "Problem moving categories."
        end
      else  # run terms
        if WpTerm.move_to_radiant
          flash[:notice] = "Terms moved, if present"
        else
          flash[:error] = "Problem moving terms."
        end        
      end

       if WpTag.move_to_radiant
          flash[:notice] = "Tags moved, if present"
        else
          flash[:error] = "Problem moving tags."
        end        
 
      if WpPost.move_to_radiant
          format.html { render :action => "index" }
      else
        format.html {render :action => "edit" }
        format.xml { render :xml => WpPosts.errors, :status => :unprocessable_entity }
      end
    end
  end
  
   def index
     stats['wp_users'] = WpUser.all(:count_by_sql)
     stats['r_users'] = User.all(:count_by_sql)
     stats['wp_posts'] = WpPost.all(:count_by_sql)
     stats['r_pages'] = Page.all(:count_by_sql)

    respond_to do |format|
      format.html
      format.xml { render :xml => @stats.to_xml }
    end
  end
  
  def wpm_config
    Radiant::Config
  end

end