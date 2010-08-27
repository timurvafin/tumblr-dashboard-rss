Feature: Generating RSS from tumblr dashboard
  In order to be able to read lates news
  A tumblr user would like to get his dashbord via RSS feed

  @tumblr_dashboard_with_regular_posts
  Scenario: Generate new RSS from dashboard with regular posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And should have item with "title" like "Regular title"
    And should have item with "description" like "Regular body"
    And save RSS to the file "tumblr_dashboard_with_regular_posts.xml"

  @tumblr_dashboard_with_photo_posts
  Scenario: Generate new RSS from dashboard with photo posts
    Given a have tumblr account with "tumblr-dashboard-rss@timurv.ru/123456"
    When I generate RSS from dashboard
    Then RSS should be valid
    And should have item with "title" like "Photo caption"
    And should have item with description with image
    And save RSS to the file "tumblr_dashboard_with_photo_posts.xml"
