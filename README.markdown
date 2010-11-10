# Linky

A simple gem for safely linking keywords within HTML (i.e., it's more than a gsub). Built on top of Nokogiri. 

## Installation

    $ gem install linky

## Usage

Call the `Linky.link` method: 

    require 'linky'
    html = "<p>link all occurances of the word "more."</p><div>some more text</div>"
    Linky.link "more", "http://more.com", html, :class => "linky"
    # returns "<p>link the word "<a href="http://more.com" class="linky">more</a>."</p><div>some <a href="http://more.com" class="linky">more</a> text</div>"

## Docs

Docs are on "rdoc.info":http://rdoc.info
