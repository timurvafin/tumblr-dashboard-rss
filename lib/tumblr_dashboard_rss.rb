require 'rubygems'
require 'bundler/setup'
require 'httparty'
require 'activesupport'
require 'ostruct'
require 'cgi'
require 'builder'

class String
  # entities encoded & tags removed
  def to_rss_title
    decode_entity.strip_tags
  end

  # entities encoded & tags in place
  def to_rss_description
    decode_entity
  end

  protected

  def strip_tags
    gsub(/<\/?[^>]*>/, "")
  end

  def decode_entity
    CGI.unescapeHTML(self)
  end

end

module Tumblr
  class Api
    include HTTParty
    format :xml

    cattr_accessor :default_options
    self.default_options = {
      'start' => 0,
      'num' => 20,
      'type' => nil,
      'filter' => nil,
      'likes' => 0
    }

    def initialize(email, password)
      @email, @password = email, password
    end

    def dashboard(options = {})
      options = default_options.update(options).update({
          'email' => @email,
          'password' => @password
        })

      self.class.get('http://www.tumblr.com/api/dashboard', :query => options)
    end
  end

  class DashboardRSS
    class Post
      attr_reader :title, :description, :link, :date

      def initialize(post)
        @post = post
        convert if feed_ready?
      end

      def feed_ready?
        ['regular', 'link', 'photo'].include?(@post['type'])
      end

      private

      def convert
        @link, @date = @post['url'], Time.parse(@post['date'])

        case @post['type']
        when 'regular'
          then @title, @description = @post['regular_title'].to_rss_title, @post['regular_body'].to_rss_description
        when 'link'
          then @title, @description = @post['link_text'].to_rss_title, %Q{<a href="#{@post['link_url']}" target="_blank">#{@post['link_text'].to_rss_description}</a>}
        when 'photo'
          then @title, @description = @post['photo_caption'].to_rss_title, %Q{<img src="#{@post['photo_url'].first}" alt="#{@post['photo_caption'].to_rss_title}" />}
        end
      end
    end

    cattr_accessor :default_options
    self.default_options = {
      'api' => {},
      'channel_name' => 'Tumblr dashboard',
      'channel_link' => 'http://www.tumblr.com/dashboard',
      'channel_description' => 'Latest posts from all folowers',
      'channel_do_sort' => true,
    }

    attr_reader :options

    def initialize(email, password, options = {})
      @options = default_options.update(options)

      @data = Api.new(email, password).dashboard(@options['api'])

      @posts = @data['tumblr']['posts']['post']
      @posts = [@posts] unless @posts.is_a?(Array)
    end

    def to_rss
      xml = Builder::XmlMarkup.new(:indent => 1)

      xml.instruct! :xml, :version => '1.0'
      xml.rss :version => '2.0' do
        xml.channel do
          xml.title @options['channel_name']
          xml.description @options['channel_description']
          xml.link @options['channel_link']

          @posts.each do |unconverted_post|
            post = Post.new(unconverted_post)
            next unless post.feed_ready?

            xml.item do
              xml.title post.title
              # we need to inject full html here
              xml.description {|html| html << post.description }
              xml.pubDate post.date
              xml.link post.link
            end
          end
        end
      end
    end
  end
end
