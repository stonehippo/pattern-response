require './partials.rb'

set :public_folder, File.dirname(__FILE__) + '/public'

class PatternCategory
  attr_accessor :name, :info, :items
  def initialize(name)
    @name = name
    
    if has_info? @name
      @info = get_info @name
    end
    
    # get the patterns for the current pattern category
    @items = []
    Dir.foreach("#{Dir.pwd}/public/patterns/#{name}") do |filename|
      next if filename =~ /^\./ # skip parent folders and hidden files
      next if !File.directory?("#{Dir.pwd}/public/patterns/#{name}/#{filename}") && File.extname("#{Dir.pwd}/public/patterns/#{name}/#{filename}") !~ /\.html$/
      
      @foo = Pattern.new(filename, "#{name}/#{filename}")
      
      # If this is a collection of subpatterns, get them and insert them as subpatterns
      if File.directory? "#{Dir.pwd}/public/patterns/#{name}/#{filename}"
        if has_info? "#{name}/#{filename}"
          @foo.info = get_info "#{name}/#{filename}"
        end
        
        Dir.foreach("#{Dir.pwd}/public/patterns/#{name}/#{filename}") do |pattern|
          next if pattern =~ /^\./ # skip parent folders and hidden files
          next if File.extname("#{Dir.pwd}/public/patterns/#{name}/#{filename}/#{pattern}") !~ /\.html$/
          @bar = Pattern.new(pattern, "#{name}/#{filename}/#{pattern}")
          @foo.subpatterns.push(@bar)
        end
      end
      
      @items.push(@foo)
    end    
  end
  
  def get_info(path)
    File.read(File.join('public/patterns/', path, '/info.txt'))
  end
  
  def has_info?(path)
    File.exists?(File.join("public/patterns/", path,'/info.txt'))
  end
end

class Pattern
  attr_accessor :name, :info, :filename, :path, :html, :css, :css_file, :sass, :less, :subpatterns
  def initialize(filename, path)
    @name = filename
    @filename = filename
    @path = path
    @subpatterns = []
    if !File.directory?("#{Dir.pwd}/public/patterns/#{path}")
      @file =  File.read("#{Dir.pwd}/public/patterns/#{path}")
      @html = find_html(@file)
      @info = find_string(@file, '<!--INFO!', '/INFO-->')
      @css = find_string(@file, '<!--CSS!', '/CSS-->')
      @sass = find_string(@file, '<!--SASS!', '/SASS-->')
      @less = find_string(@file, '<!--LESS!', '/LESS-->')  
    else 
      @html = "No HTML"
    end
    # Find the matching CSS doc, if there is one
    @css_path = @path.gsub(/.html/, '.css')
    if !File.directory?("#{Dir.pwd}/public/patterns/#{path}") && File.exists?("#{Dir.pwd}/public/patterns/#{@css_path}")
      @css_file = File.read("#{Dir.pwd}/public/patterns/#{@css_path}")
    end
  end
  
  def find_string(source, start, finish)
    source[Regexp.new("#{start}(.*)#{finish}", Regexp::MULTILINE), 1]
  end
  
  def find_html(source)
    source.gsub(/<!--([A-Z]+)!.*\/\1-->/m, '')
  end
end

helpers do
  include Sinatra::Partials
  def get_patterns
    objects = []
    # Get the top level items
    Dir.foreach("#{Dir.pwd}/public/patterns") do |filename|
      next if filename =~ /^\./ # skip parent folders and hidden files
      @foo = PatternCategory.new(filename)
      objects.push(@foo)
    end
    return objects
  end
  
  def remove_chars(value)
    value.gsub(/[0-9. -]/,'').downcase
  end
  
  def fix_case(value)
    value.gsub(/-/, ' ').scan(/\w+|\W+/).map(&:capitalize).join
  end

  def h(source)
    coder = HTMLEntities.new
    coder.encode(source)
  end

end

get '/' do
  erb :index 
end

get '/responsive' do
  erb :responsive
end
