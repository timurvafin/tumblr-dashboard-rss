require 'nokogiri'

Spec::Matchers.define :have_xml do |xpath, text|
  match do |body|
    @nodes = Nokogiri::XML(body).xpath(xpath)
    @nodes.should_not be_blank
    
    if text
      @nodes.each do |node|
        node.content.match(Regexp.escape(text)).should_not be_blank
      end
    end
    true
  end

  failure_message_for_should do |body|
    "expected to find xml tag #{xpath} in:\n#{body}\nNodes:\n#{@nodes.to_a.inspect}\n"
  end

  failure_message_for_should_not do |body|
    "expected not to find xml tag #{xpath} in:\n#{body}"
  end

  description do
    "have xml tag #{xpath}"
  end
end