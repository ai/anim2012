require 'pathname'
require 'base64'
ROOT   = Pathname(__FILE__).dirname
PUBLIC = ROOT.join('public')
SLIDES = ROOT.join('slides')
COMMON = ROOT.join('common')
VENDOR = ROOT.join('vendor')

require 'slim'
require 'compass'
require 'ceaser-easing'
require 'coffee-script'
require 'uglifier'

Compass.configuration.images_path = ROOT.to_s
Compass.configuration.fonts_path  = VENDOR.to_s

class Pathname
  def glob(pattern, &block)
    Pathname.glob(self.join(pattern), &block)
  end

  def copy_to(to_dir, pattern = '**/*', &block)
    self.glob(pattern) do |from|
      next if from.directory?
      next if block_given? and yield
      to = to_dir.join(from.relative_path_from(self))
      to.dirname.mkpath
      FileUtils.cp(from, to)
    end
  end
end

Slide = Struct.new(:name, :title, :types, :html, :file) do
  def style
    file.dirname.join("#{name}.sass")
  end

  def js
    file.dirname.join("#{name}.coffee")
  end

  def name
    file.basename.sub_ext('')
  end
end

class Environment
  attr_accessor :slides

  def name(value);  @name = value; end
  def title(value); @title = value; end

  def type(*values)
    @types += ' ' + values.join(' ')
  end

  def render(file, &block)
    @current = file
    options = { format: :html5, disable_escape: true }
    Slim::Template.new(file.to_s, options).render(self, &block)
  end

  def find_asset(path, ext = nil)
    [COMMON, VENDOR].map { |i| i.join(path) }.find { |i| i.exist? }
  end

  def include_style(path)
    file = find_asset(path + '.css')
    if file
      file.read
    else
      file = find_asset(path + '.sass')
      compile(file) if file
    end
  end

  def include_js(path)
    file = find_asset(path + '.js')
    if file
      file.read
    else
      file = find_asset(path + '.coffee')
      compile(file) if file
    end
  end

  def sass_options
    @sass_options ||= begin
      Compass.configuration.http_images_path = development? ? '/' : './'
      Compass.configuration.http_fonts_path = if development?
        'vendor/'
      else
        'file:///' + VENDOR.to_s
      end

      opts = Compass.sass_engine_options
      opts[:line_comments] = false
      opts[:style] =  development? ? :nested : :compressed
      opts[:load_paths] << Sass::Importers::Filesystem.new(VENDOR)
      opts
    end
  end

  def sass_before
    base = COMMON.join('_base.sass').read
    if standalone?
      base + COMMON.join('_standalone.sass').read
    else
      base
    end
  end

  def compile(file)
    if file.extname == '.sass'
      Sass::Engine.new(sass_before + file.read, sass_options).render
    elsif file.extname == '.coffee'
      CoffeeScript.compile(file.read)
    end
  end

  def slide(file)
    @name  = @title = @cover = nil
    @types = ''
    html = render(file)
    html = image_tag(@cover, class: 'cover') + html if @cover
    @slides << Slide.new(@name, @title, @types, html, file)
  end

  def slides_styles
    slides.map(&:style).reject {|i| !i.exist? }.map {|i| compile(i) }.join("\n")
  end

  def slides_jses
    slides.map(&:js).reject {|i| !i.exist? }.map {|i| compile(i) }.join("\n")
  end

  def compress_js(&block)
    js = yield(block)
    if development?
      js
    else
      Uglifier.compile(js, copyright: false)
    end
  end

  def image_tag(name, attrs = {})
    attrs[:alt] ||= ''
    uri  = @current.dirname.join(name)
    type = file_type(uri)
    if type == 'image/gif'
      attrs[:class] = (attrs[:class] ? attrs[:class] + ' ' : '') + 'gif'
    end
    if standalone?
      uri = encode_image(uri, type)
    else
      uri = uri.to_s.gsub(ROOT.to_s + '/', '')
    end
    attrs = attrs.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')
    "<img src=\"#{ uri }\" #{ attrs } />"
  end

  def encode_image(file, type)
    "data:#{type};base64," + Base64.encode64(file.open { |io| io.read })
  end

  def file_type(file)
    `file -ib #{file}`.split(';').first
  end

  def cover(name)
    @types += ' cover'
    @cover  = name
  end

  def include_counter
    COMMON.join('_counter.html').read
  end

  def standalone?
    @build_type == 'standalone'
  end

  def production?
    @build_type == 'production'
  end

  def development?
    @build_type == 'development'
  end

  def google_fonts
    ['family=PT+Sans&subset=latin,cyrillic',
     'family=PT+Sans+Narrow:700&subset=latin,cyrillic',
     'family=PT+Mono']
  end

  def result_file
    if standalone?
      'anim2012.html'
    else
      'index.html'
    end
  end

  def layout_file
    COMMON.join('layout.slim')
  end

  def clean!
    PUBLIC.mkpath
    PUBLIC.glob('*') { |i| i.rmtree }
    self
  end

  def build!(build_type = 'development')
    @build_type = build_type

    @slides = []
    SLIDES.glob('**/*.slim').sort.each { |i| slide(i) }

    PUBLIC.join(result_file).open('w') { |io| io << render(layout_file) }
    if production?
      ROOT.copy_to(PUBLIC, '**/*.{png,gif,jpg}') do |image|
        image.to_s.start_with? PUBLIC.to_s
      end
    end

    if standalone?
      `zip -j public/anim2012.zip public/anim2012.html`
      FileUtils.rm PUBLIC.join('anim2012.html')
    end

    self
  end
end

desc 'Build site files'
task :build do
  Environment.new.clean!.build!('production')
end

desc 'Build presentation all-in-one file'
task :standalone do
  Environment.new.clean!.build!('standalone')
end

desc 'Run server for development'
task :server do
  require 'sinatra/base'

  class WebSlides < Sinatra::Base
    get '/' do
      slides_env.clean!.build!
      send_file PUBLIC.join('index.html')
    end

    get '/*' do
      send_file ROOT.join(params[:splat].first)
    end

    def slides_env
      @slides_env ||= Environment.new
    end
  end

  WebSlides.run!
end
