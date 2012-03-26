require './partials.rb'

set :public_folder, File.dirname(__FILE__) + '/public'

class Pattern
  attr_accessor :folder_name, :items
  def initialize(folder_name)
    @folder_name = folder_name
    # get the subfolders and files for the current pattern
    @items = []
    Dir.foreach(Dir.pwd + '/patterns/' + folder_name) do |filename|
      next if filename =~ /^\./ # skip parent folders and hidden files
      @items.push(filename)
    end
  end
end

helpers Sinatra::Partials
helpers do
  def get_patterns
    objects = []
    Dir.foreach(Dir.pwd + '/patterns') do |filename|
      next if filename =~ /^\./ # skip parent folders and hidden files
      @foo = Pattern.new(filename)
      objects.push(@foo)
    end
    return objects
  end
  
  def remove_chars(value)
    value.gsub(/[0-9. -]/,'').downcase
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
