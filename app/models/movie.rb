class Movie < ActiveRecord::Base
  
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end
  
  def self.with_ratings(ratings_list)
    query = []
    ratings_list.each do |e|
      if e.is_a? String then
        query.append("rating = '" + e + "'")
      else
        query.append("rating = '" + e[0] + "'")
      end
    end
    Movie.where(query.join(" or "))
  end
  
end
