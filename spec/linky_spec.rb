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
    new_html = Linky.link(@keyword, "http://link.to.somewhere", @html, :class => "autolinked")
    new_html.should == "<p>some html with keyword and <a href=\"http://link.to.somewhere\" class=\"autolinked\">Keyword</a> and <a href=\"#\">keyword</a></p>"
  end

  it "should match on whole words (i.e., don't link partial words within words)" do
    html = "hi there, he is funny."
    new_html = Linky.link "he", "#he", html
    new_html.should == "hi there, <a href=\"#he\">he</a> is funny."
  end
end
