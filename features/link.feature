Feature: Linking keywords

  Scenario: Linking a keyword
    Given the html fragment "<p>Help me link <b>keywords</b> in this document.</p><div>can you <a href='jkfldsa'>help</a>?</div>"
    When I link the keyword "help" to "http://help.com"
    Then the html fragement should become "<p><a href="http://help.com">Help</a> me link <b>keywords</b> in this document.</p><div>can you <a href='jkfldsa'>help</a>?</div>"


