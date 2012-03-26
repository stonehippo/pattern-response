require './partials.rb'

set :public_folder, File.dirname(__FILE__) + '/public'

class Pattern
  attr_accessor :folder_name
end

helpers Sinatra::Partials
helpers do
  def get_patterns

  end
  
  def remove_chars
    
  end
  
  def print_html
    
  end
  
  def find_string
    
  end
  
  def find_html
    
  end
end

get '/' do
  erb :index 
end

get '/responsive' do
  erb :responsive
end
