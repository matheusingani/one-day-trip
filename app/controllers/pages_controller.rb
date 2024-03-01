class PagesController < ApplicationController
  def home
    @places = Place.all
    @markers = @places.geocoded.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude
      }
    end

    def show_one_place_per_city
      @best_places =  Place
                      .all
                      .left_outer_joins(:experiences)
                      .select("rating,places.*")
                      .group_by{ |place| place.city }
                      .transform_values{ |places_per_city| places_per_city
                        .group_by { |experience| experience.id }
                        .transform_values { |experiences|
                          overall_ratings = experiences.map { |experience|
                            experience.rating || 0
                          }
                          [overall_ratings.sum(0.0) / overall_ratings.size, experiences[0]]
                        }
                        .max_by { |key, value|  value }[1][1]
                      }

                      #{"Lisbon"=>{14=>3.5, 15=>1.0}, "London"=>{16=>0.0}}
                      #{"Lisbon"=>14, "London"=>16}

                      puts "WWWWWWWWWWWW"
                      p @best_places
                      puts "******** ******** "
                      # combine the two tables

    end

    # def show_one_place_per_city
    #   allplaces = Place.all
    #   #uniq { |obj| obj.name }.max_by { |obj| obj.rating }
    #   @placepercity = allplaces.group_by { |place| place.city }
    # end

    show_one_place_per_city

    # get rating with place_id from experience table
    # sort it places array according to that ratings average
    # display only the first one

#     SELECT date_trunc('month', purchased_at)::date, SUM(orders_with_amount.amount)
# FROM orders
# JOIN orders_with_amount ON orders.id = orders_with_amount.order_id
# GROUP BY 1

    def show_best_rated_place
      @places = Place.all
      if params[:query].present?
        sql = <<~SQL
          movies.title ILIKE :query
          OR movies.synopsis ILIKE :query
          OR directors.first_name ILIKE :query
          OR directors.last_name ILIKE :query
        SQL
      @movies = @movies.joins(:director).where(sql, query: "%#{params[:query]}%")
      end
    end

  end
end
