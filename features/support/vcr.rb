require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'features/fixtures/vcr'
  c.http_stubbing_library = :fakeweb
  c.default_cassette_options = { :record => :new_episodes }
end

VCR.cucumber_tags do |t|
  t.tags '@tumblr_dashboard_with_regular_posts', '@tumblr_dashboard_with_photo_posts',
    '@tumblr_dashboard_with_quote_posts', '@tumblr_dashboard_with_link_posts',
    '@tumblr_dashboard_with_chat_posts', '@tumblr_dashboard_with_audio_posts',
    '@tumblr_dashboard_with_video_posts', '@tumblr_dashboard_with_full_of_posts'
end

