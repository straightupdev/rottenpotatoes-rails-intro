class Movie < ActiveRecord::Base
    
  def self.get_all_ratings
    return ['G','PG','PG-13','R','NC-17']
  end
  
end