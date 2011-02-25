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
    new_html.should == "<p>some html with <a href=\"http://link.to.somewhere\" class=\"autolinked\">keyword</a> and Keyword and <a href=\"#\">keyword</a></p>"
  end

  it "should match on whole words (i.e., don't link partial words within words)" do
    html = "hi there, he is funny and he is a he.<div>more he stuff.</div>"
    new_html = Linky.link "he", "#he", html
    new_html.should == "hi there, <a href=\"#he\">he</a> is funny and he is a he.<div>more he stuff.</div>"
  end

  it "should not remove links" do
    html = "<p>California <a href=\"topics/cabernet-sauvignon\">Cabernet Sauvignon</a></p>"
    new_html = Linky.link "California", "topics/california", html
    new_html.should == "<p><a href=\"topics/california\">California</a> <a href=\"topics/cabernet-sauvignon\">Cabernet Sauvignon</a></p>"
  end

  it "should preserve entities" do
    html = "<p>California <a href=\"topics/cabernet-sauvignon\">Cabernet Sauvignon</a>&#151;an awesome wine</p>"
    new_html = Linky.link "California", "topics/california", html
    new_html.should == "<p><a href=\"topics/california\">California</a> <a href=\"topics/cabernet-sauvignon\">Cabernet Sauvignon</a>&#x97;an awesome wine</p>"
  end

  it "should include text after next line char" do
    html = %(Hi.\nI like ice cream. She likes it too.\n I think.)
    new_html = Linky.link "cream", "topics/cream", html
    new_html.should == %(Hi.\nI like ice <a href="topics/cream">cream</a>. She likes it too.\n I think.)
  end

  it "should preserve html entity" do
    html = "apple &amp; orange"
    new_html = Linky.link "apple", "topics/apple", html
    new_html.should == %(<a href="topics/apple">apple</a> &amp; orange)
  end

  it "should process pre parsed html fragment object" do
    html = "apple &amp; orange"
    frag = Nokogiri::HTML::DocumentFragment.parse(html)
    new_html = Linky.link "apple", "topics/apple", frag
    new_html.should == %(<a href="topics/apple">apple</a> &amp; orange)
  end
end
