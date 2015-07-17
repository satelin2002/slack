require 'sinatra/base'
require 'sinatra/config_file'

class App < Sinatra::Base
  register Sinatra::ConfigFile

  configure do
    set :public_folder, Proc.new { File.join(root, "static") }
    set :views, Proc.new { File.join(root, "views") }
    enable :sessions
    set :show_exceptions, false
    set :raise_errors, false
    set :raise_internal_errors, false
  end

end
