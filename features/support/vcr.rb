require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'features/fixtures/vcr'
  c.http_stubbing_library = :fakeweb
end

VCR.cucumber_tags do |t|
  t.tags '@rcmru', :record => :new_episodes
end

