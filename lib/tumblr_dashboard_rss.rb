require 'rubygems'
require 'bundler/setup'
require 'httparty'
require 'active_support/core_ext/class/attribute'
require 'ostruct'
require 'cgi'
require 'builder'

module RSSPostExtension
  
  def to_rss_title
    to_s.decode_entity.strip_tags.encode_entity
  end

  def to_rss_link
    to_s.decode_entity.strip_tags
  end

  def to_rss_description
    to_s
  end

  protected

  def strip_tags
    gsub(/<\/?[^>]*>/, "")
  end

  def decode_entity
    CGI.unescapeHTML(self)
  end

  def encode_entity
    CGI.escapeHTML(self)
  end
end

class String
  include RSSPostExtension
end

class NilClass
  include RSSPostExtension
end

module Tumblr
  class Api
    class Error < Net::HTTPError
      def initialize(response)
        @response = response
      end

      def to_s
        @response.parsed_response
      end
    end

    include HTTParty
    format :xml

    class_attribute :default_options
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

      response = self.class.get('http://www.tumblr.com/api/dashboard', :query => options)
      raise Error.new(response) unless response.code == 200
      response
    end
  end

  class DashboardRSS
    class Post
      attr_reader :title, :description, :link, :date, :audio_enclosure

      def initialize(post)
        @post = post
        convert if feed_ready?
      end

      def feed_ready?
        ['regular', 'link', 'photo', 'quote', 'conversation', 'audio', 'video'].include?(@post['type'])
      end

      private

      def convert
        @link, @date = @post['url'], Time.parse(@post['date'])

        send("conver_to_#{@post['type']}".to_sym)

        @description = @title if @description.blank?
        @title = %Q{<![CDATA[#{@title}]]>}
        @description = %Q{<![CDATA[#{@description}]]>}
      end

      def conver_to_regular
        @title, @description = @post['regular_title'].to_rss_title, @post['regular_body'].to_rss_description
      end

      def conver_to_link
        @link, @title, @description = @post['link_url'].to_rss_link, @post['link_text'].to_rss_title, @post['link_description'].to_rss_description
      end

      def conver_to_photo
        @title, @description = @post['photo_caption'].to_rss_title,
          %Q{<a href="#{@link}" target="_blank"><img src="#{@post['photo_url'].last}" alt="#{@post['photo_caption'].to_rss_title}" /></a>}
      end

      def conver_to_quote
        @title, @description = @post['quote_source'].to_rss_title, @post['quote_text']
      end

      def conver_to_conversation
        @title, @description = @post['conversation_title'].to_rss_title, @post['conversation_text'].to_rss_description
      end

      def conver_to_audio
        @title, @audio_enclosure = @post['audio_caption'].to_rss_title, @post['download_url'].to_rss_link
      end

      def conver_to_video
        @title = @post['video_caption'].to_rss_title
        @description = %Q{#{@post['video_source']}<br />#{@post['video_caption']}}
      end
    end

    class_attribute :default_options
    self.default_options = {
      'api' => {},
      'channel_name' => 'Tumblr dashboard',
      'channel_link' => 'http://www.tumblr.com/dashboard',
      'channel_description' => 'Latest posts from all folowers',
      'channel_do_sort' => true,
    }

    attr_reader :options

    def initialize(email, password, options = {})
      @email, @password = email, password
      @options = default_options.merge(options)
    end

    def to_rss
      xml = Builder::XmlMarkup.new(:indent => 1)

      xml.instruct! :xml, :version => '1.0'
      xml.rss :version => '2.0' do
        xml.channel do
          xml.title @options['channel_name']
          xml.description @options['channel_description']
          xml.link @options['channel_link']

          posts.each do |unconverted_post|
            post = Post.new(unconverted_post)
            next unless post.feed_ready?

            xml.item do
              xml.title  {|html| html << post.title }
              xml.description {|html| html << post.description }
              xml.pubDate post.date
              xml.link post.link
              xml.enclosure :url => post.audio_enclosure, :type => 'audio/mpeg' unless post.audio_enclosure.blank?
            end
          end
        end
      end
    end

    private

    def posts
      return @posts unless @posts.blank?

      @data = Api.new(@email, @password).dashboard(@options['api'])

      @posts = @data['tumblr']['posts']['post']
      @posts = [@posts] unless @posts.is_a?(Array)

      @posts
    end
  end
end
