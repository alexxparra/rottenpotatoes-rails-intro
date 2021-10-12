class Movie < ActiveRecord::Base
  
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end
  
  def self.with_ratings(ratings_list)
    query = []
    ratings_list.each do |e|
      query.append("rating = '" + e[0] + "'")
    end
    Movie.where(query.join(" or "))
  end
  
end
