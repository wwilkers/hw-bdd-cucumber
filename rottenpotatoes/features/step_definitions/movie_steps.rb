# Add a declarative step here for populating the DB with movies.

count = 0
Given /the following movies exist/ do |movies_table|
     count = 0
  movies_table.hashes.each do |movie|
      Movie.create(movie)
count += 1
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
     page.body =~ /#{e1}.+#{e2}/m

end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
    rating_list.delete!("\"")
  if uncheck.nil?
    rating_list.split(',').each do |field|
      check("ratings["+field.strip+"]")
    end
  else
    rating_list.split(',').each do |field|
      uncheck("ratings["+field.strip+"]")
    end
  end
end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
Then /I should see all of the movies/ do
  page.should have_css("table#movies tbody tr",:count => count.to_i)
end