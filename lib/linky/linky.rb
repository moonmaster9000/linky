class Linky
  class << self
    def link(keyword, html, &block)
      html_fragment = Nokogiri::HTML::DocumentFragment.parse html
      real_link keyword.to_s, haystack, &block
    end

    private
    def real_link(needle, haystack, &block)
      if haystack.text? && (match = haystack.content.match(/(#{needle})/i))
        new_needle = block.call match[0]
        haystack.after new_needle
        haystack.after haystack.content.gsub(/.*[\ .]#{match[0]}/, "")
        haystack.content = haystack.content.gsub(/(.*)#{match[0]}/, "\1")
      elsif haystack.name != "a" && haystack.respond_to?(:children)
        haystack.children.each do |child|
          real_link needle, child, &block 
        end
      end
    end
  end
end
