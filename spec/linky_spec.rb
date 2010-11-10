$LOAD_PATH.unshift './lib'
require 'linky'

describe Linky, "#link" do
  before do
    @keyword = :keyword
    @html = "<p>some html with keyword and Keyword and <a href='#'>keyword</a></p>"
  end

  it "should require a keyword, a target, some html, and potentially options" do
    proc {Linky.link}.should raise_error
    proc {Linky.link :keyword}.should raise_error
    proc {Linky.link :keyword, "http://link.to_somewhere"}.should raise_error
    proc {Linky.link :keyword, "http://link.to.somewhere", @html, :class => "autolinked"}.should_not raise_error
  end

  it "should link any keywords not already linked" do
    new_html = Linky.link(@keyword, "http://link.to.somewhere", @html)
    new_html.should == "<p>some html with <a href=\"http://link.to.somewhere\">keyword</a> and Keyword and <a href=\"#\">keyword</a></p>"
  end
end
