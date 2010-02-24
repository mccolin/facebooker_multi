# FACEBOOKER MULTI
# Small plugin to tag-along database-backed application configuration loading
# in Facebooker. Facebook applications may be defined in an apps table in 
# your Rails project.

class << Facebooker

  # Override the method by which Facebooker loads configurations to also
  # include a database-backed option via the App model
  def fetch_config_for_with_db_and_log(api_key)
    unless config = fetch_config_for_without_db(api_key)
      RAILS_DEFAULT_LOGGER.debug "Facebook configuration cannot be loaded via YAML. We'll check the database."
      if ActiveRecord::Base.connection.tables.include?("apps")
        RAILS_DEFAULT_LOGGER.debug "Apps table exists in database. We'll search it for config. w00t."      
        if app = App.find_by_api_key(api_key)
          RAILS_DEFAULT_LOGGER.debug "Apps table yielded configuration for given API key. We'll use it."
          config = app.attributes.delete_if{|k,v| ["name","id","properties"].include?(k) }
          config["set_asset_host_to_callback_url"] = false
        else
          RAILS_DEFAULT_LOGGER.debug "Apps table does not include definition for API key. Bummer."
        end
      else
        RAILS_DEFAULT_LOGGER.debug "Apps table does not exist. Bummer."
      end
    else
      RAILS_DEFAULT_LOGGER.debug "Facebook configuration loaded the old-fashioned way."
    end
    return config || false
  end
  #alias_method_chain :fetch_config_for, :db_and_log
  
  
  # Override the method by which Facebooker loads configurations to also
  # include a database-backed option via the App model
  def fetch_config_for_with_db(api_key)
    unless config = fetch_config_for_without_db(api_key)
      if ActiveRecord::Base.connection.tables.include?("apps") && app = App.find_by_api_key(api_key)
        config = app.attributes.delete_if{|k,v| ["name","id","properties"].include?(k) }
        config["set_asset_host_to_callback_url"] = false
      end
    end
    return config || false
  end
  alias_method_chain :fetch_config_for, :db
  

end

