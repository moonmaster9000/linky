$LOAD_PATH.unshift './lib'
require 'linky'

describe Linky, "#link" do
  before do
    @keyword = :keyword
    @html = "<p>some html with keyword and Keyword and <a href='#'>keyword</a></p>"
  end

  it "should require a needle, haystack, and block" do
    proc {Linky.link}.should raise_error
    proc {Linky.link :keyword}.should raise_error
    proc {Linky.link :keyword, @html}.should raise_error
    proc {Linky.link :keyword, @html {|k| "<a href='http://linkhere!'>#{k}</a>"}}.should_not raise_error
  end

  it "should link any keywords not already linked" do
    new_html = Linky.link @keyword, @html {|k| "<a href='http://link.to.somewhere'>#{k}</a>"}
    new_html.should == "<p>some html with <a href='http://link.to.somewhere'>keyword</a> and <a href='http://link.to.somewhere'>Keyword</a> and <a href='#'>keyword</a></p>"
  end
end
