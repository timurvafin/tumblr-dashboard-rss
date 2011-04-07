Feature: Generating RSS from tumblr dashboard
  In order to be able to read lates news
  A tumblr user would like to get his dashbord via RSS feed

  @tumblr_dashboard_with_regular_posts
  Scenario: Generate new RSS from dashboard with regular posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And should have item with "author" like "tumblr-dashboard-rss"
    And should have item with "title" like "Regular title"
    And should have item with "description" like "Regular body"
    And save RSS to the file "tumblr_dashboard_with_regular_posts.xml"

  @tumblr_dashboard_with_photo_posts
  Scenario: Generate new RSS from dashboard with photo posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And should have item with "author" like "tumblr-dashboard-rss"
    And should have item with "title" like "Photo caption"
    And should have item with image "http://26.media.tumblr.com/tumblr_l7tdi6nFiq1qdv6d1o1_250.png" in the description
    And save RSS to the file "tumblr_dashboard_with_photo_posts.xml"

  @tumblr_dashboard_with_quote_posts
  Scenario: Generate new RSS from dashboard with quote posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And should have item with "author" like "tumblr-dashboard-rss"
    And should have item with "title" like "http://www.lipsum.com/"
    And should have item with "description" like "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
    And save RSS to the file "tumblr_dashboard_with_quote_posts.xml"

  @tumblr_dashboard_with_link_posts
  Scenario: Generate new RSS from dashboard with link posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And should have item with "author" like "tumblr-dashboard-rss"
    And should have item with "title" like "Tumblr test site"
    And should have item with "description" like "Use this site for testing gem"
    And should have item with "link" like "http://tumblr-dashboard-rss.tumblr.com/"
    And save RSS to the file "tumblr_dashboard_with_link_posts.xml"

  @tumblr_dashboard_with_chat_posts
  Scenario: Generate new RSS from dashboard with chat posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And should have item with "author" like "tumblr-dashboard-rss"
    And should have item with "title" like "Me with some one"
    And should have item with "description" like "Could you give us directions to Olive Garden?"
    And save RSS to the file "tumblr_dashboard_with_chat_posts.xml"

  @tumblr_dashboard_with_audio_posts
  Scenario: Generate new RSS from dashboard with audio posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And should have item with "author" like "tumblr-dashboard-rss"
    And should have item with "title" like "Episode #117 - October 5, 2010"
    And should have item with audio enclosure "http://www.tumblr.com/audio_file/1250953897/tumblr_l9u51raCG21qdv6d1?t=1286312592&h=s3ZJX3IhhYM4LvF9CmxN6ddEQ0"
    And save RSS to the file "tumblr_dashboard_with_audio_posts.xml"

  @tumblr_dashboard_with_video_posts
  Scenario: Generate new RSS from dashboard with video posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And should have item with "author" like "tumblr-dashboard-rss"
    And should have item with "title" like "You tube video"
    And should have item with "description" like "http://www.youtube.com/watch?v=8mVEGfH4s5g"
    And save RSS to the file "tumblr_dashboard_with_video_posts.xml"

  @tumblr_dashboard_with_full_of_posts
  Scenario: Generate new RSS from dashboard with full of posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And save RSS to the file "tumblr_dashboard_with_full_of_posts.xml"

  @access_with_invalid_credentials
  Scenario: Access with invalid credentials
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/invalid password"
    When I generate RSS from dashboard
    Then I should get exception
