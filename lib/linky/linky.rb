class Linky
  class << self
    # Link a keyword to a target within some HTML. 
    #   * keyword: what you want linked
    #   * target: where you want it linked to
    #   * html: the html you want to look for the keyword in
    #   * options: any extra attributes (besides href) that you want on the link.
    #
    # Here's an example:
    #
    #     require 'linky'
    #     html = "<p>link all occurances of the word "more."</p><div>some more text</div>"
    #     Linky.link "more", "http://more.com", html, :class => "linky"
    #     # returns "<p>link the word "<a href="http://more.com" class="linky">more</a>."</p><div>some <a href="http://more.com" class="linky">more</a> text</div>"
    def link(keyword, target, html, options={})
      options = options.map {|k,v| %{#{k}="#{v}"}}.join " " 
      block = proc {|keyword| %{<a href="#{target}" #{options}>#{keyword}</a>}}
      html_fragment = Nokogiri::HTML::DocumentFragment.parse html
      real_link keyword.to_s, html_fragment, &block
      html_fragment.to_html
    end

    private
    def real_link(needle, haystack, &block)
      # if we've drilled down all the way to a raw text node,
      # and it contains the needle we're looking for
      if haystack.text? && (match = haystack.content.match(/^.*[\ \."'](#{needle})(?:[\ \."'].*)?$/i))
        
        # call the block to determine what we'll replace the needle with
        new_needle = block.call match[1]
       
        # break the string into three parts
        prefix, keyword, postfix = break_on_boundary match[1], haystack.to_s 
        
        haystack.content = prefix
        haystack.add_next_sibling Nokogiri::HTML::DocumentFragment.parse(new_needle)
        if !postfix.nil? and !postfix.empty?
          haystack.next_sibling.add_next_sibling Nokogiri::HTML::DocumentFragment.parse(postfix)
          haystack.next_sibling.next_sibling.content = postfix
        end
      elsif haystack.name != "a" && haystack.respond_to?(:children)
        haystack.children.each do |child|
          real_link needle, child, &block 
        end
      end
    end

    def break_on_boundary(boundary, string)
      match = string.match /^(.*[\ \."'])(#{boundary})([\ \."'].*|)?$/
      return match[1], match[2], match[3]
    end
  end
end
