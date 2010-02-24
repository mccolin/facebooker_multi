# FACEBOOKER MULTI
# Small plugin to tag-along database-backed application configuration loading
# in Facebooker. Facebook applications may be defined in an apps table in 
# your Rails project.

RAILS_DEFAULT_LOGGER.info "**** Loading Facebooker-Multi ****"

# Load our addendum to Facebooker-proper:
require 'facebooker'
