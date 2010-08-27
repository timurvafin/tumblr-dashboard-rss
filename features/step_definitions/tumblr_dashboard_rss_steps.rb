Given /^a have tumblr account with "(.*?)\/(.*?)"$/ do |email, password|
  @tumblr = Tumblr::DashboardRSS.new(email, password, {'channel_name' => 'Test channel'})
end

When /^I generate RSS from dashboard$/ do
  @rss = @tumblr.to_rss
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

Then /^should have item with description with image$/ do
  Then %Q{should have xml path "/rss/channel/item/description/img"}
end

Then /^save RSS to the file "([^"]*)"$/ do |file|
  File.open(file, 'w') { |f| f.write(@rss.to_s) }
end


