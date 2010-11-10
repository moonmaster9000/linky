class Linky
  class << self
    def link(keyword, target, html, options={})
      block = proc {|keyword| %{<a href="#{target}" #{options.map {|k,v| %{#{k}="#{v}"}}.join " "}>#{keyword}</a>}}
      html_fragment = Nokogiri::HTML::DocumentFragment.parse html
      real_link keyword.to_s, html_fragment, &block
      html_fragment.to_html
    end

    private
    def real_link(needle, haystack, &block)
      # if we've drilled down all the way to a raw text node,
      # and it contains the needle we're looking for
      if haystack.text? && (match = haystack.content.match(/(#{needle})/i))
        
        # call the block to determine what we'll replace the needle with
        new_needle = block.call match[0]
       
        # break the string into three parts
        prefix, keyword, postfix = break_on_boundary match[0], haystack.to_s 
        
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
      match = string.match /^(.*)(#{boundary})(.*)$/
      return match[1], match[2], match[3]
    end
  end
end
