require 'anemone'

# Patterns
ANYPAGE            = %r[ty=as&ak=&rk=&s=100&p=\d+]               # ty=as&ak=&rk=&s=100&p=<page number>
ANYPATTERN         = Regexp.union ANYPAGE

File.open('ipropcontact.txt', 'w') do |file|

  Anemone.crawl("http://www.iproperty.com.sg/realestate/findanagent.aspx?ty=as&ak=&rk=&s=100&p=1") do |anemone|  #page to start

    anemone.focus_crawl do |page|
      page.links.keep_if { |link| link.to_s.match(ANYPATTERN) } # crawl only links that matches the pattern
    end
    count = 1
    anemone.on_pages_like(ANYPAGE) do |page|
      page.doc.xpath("//a[starts-with(@href, 'mailto')]").each do |txt|         #grab all the xpath required off the page
        contactNo = txt.text
        contactNo = contactNo.delete(' ')
        puts "#{page.url} contact: #{count+=1} #{contactNo}"
        if contactNo
          file.puts contactNo
        end
      end

    end

  end

end
