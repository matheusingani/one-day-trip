class PagesController < ApplicationController
  def home
    @places = Place.all
    @markers = @places.geocoded.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {place: place})
      }
    end

    def show_one_place_per_city
      @best_places =  Place
                      .all
                      .left_outer_joins(:experiences)
                      .select("rating,places.*,experiences.user_id as experience_id")
                      .group_by{ |place| place.city }
                      .transform_values{ |places_per_city|
                        places = places_per_city
                        .group_by { |experience| experience.id }
                        .transform_values { |experiences|
                          overall_ratings = experiences.map { |experience|
                            experience.rating || 0
                          }
                          hash = {rating: overall_ratings.sum(0.0) / overall_ratings.size,
                            place: experiences[0],
                            visited: experiences.any? { |experience|
                              puts [experience.experience_id, current_user.id]
                              experience.experience_id == current_user.id }}
                            hash
                          }
                        .filter { |key, value| !value[:visited] }
                        if places != {}
                          places.max_by { |key, value|  value[:rating] }[1][:place]
                        else
                          nil
                        end
                      }
                      .filter {|city, place| place != nil }


    end

    show_one_place_per_city

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
