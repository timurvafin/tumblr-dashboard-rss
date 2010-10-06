Given /^a have tumblr account with "(.*?)\/(.*?)"$/ do |email, password|
  @tumblr = Tumblr::DashboardRSS.new(email, password, {'channel_name' => 'Test channel'})
end

When /^I generate RSS from dashboard$/ do
  begin
    @rss = @tumblr.to_rss
  rescue => e
    @exception = e
  end
end

Then /^should have xml path "([^"]*)"(?: with "([^"]*)")?$/ do |xpath, text|
  @rss.should have_xml(xpath, text)
end

Then /^RSS should be valid$/ do
  @rss.should_not be_blank

  Then %Q{should have xml path "/rss/channel/title" with "#{@tumblr.options['channel_name']}"}
  Then %Q{should have xml path "/rss/channel/description" with "#{@tumblr.options['channel_description']}"}
end

Then /^should have item with "([^"]*)" like "([^"]*)"$/ do |field, string|
  Then %Q{should have xml path "/rss/channel/item/#{field}" with "#{string}"}
end

Then /^should have xml path "([^"]*)"(?: with "([^"]*)")? in the "([^"]*)"$/ do |xpath, text, field|
  node = Nokogiri::XML(@rss).xpath("/rss/channel/item/#{field}").first
  node.should_not be_blank

  node.content.should have_xml(xpath, text)
end

Then /^should have item with image "([^"]*)" in the description$/ do |image|
  Then %Q{should have xml path "/a/img[@src='#{image}']" in the "description"}
end

Then /^should have item with audio enclosure "([^"]*)"$/ do |audio|
  Then %Q{should have xml path "/rss/channel/item/enclosure[@type='audio/mpeg'][@url='#{audio}']"}
end

Then /^should have item with video enclosure "([^"]*)"$/ do |video|
  Then %Q{should have xml path "/rss/channel/item/enclosure[@type='video/mpeg'][@url='#{video}']"}
end

Then /^save RSS to the file "([^"]*)"$/ do |file|
  File.open(file, 'w') { |f| f.write(@rss.to_s) }
end

Then /^I should get exception$/ do
  @exception.should_not be_nil
  @exception.class.should == Tumblr::Api::Error
  @exception.to_s.should == 'Invalid credentials.'

  raise_error
end


