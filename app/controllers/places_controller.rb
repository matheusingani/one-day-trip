class PlacesController < ApplicationController
  before_action :set_place, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  # GET /places or /places.json

  def index
    @places = Place.all
    show_one_place_per_city
  end

  # GET /places/1 or /places/1.json
  def show
    puts "@@@@"
    @place = Place.find(params[:id])
    @experience = @place.experiences.build
    @experiences = @place.experiences
    @average_rating = @experiences.average(:rating)
    @rating = rand(5)
  end


  def create_experience
    puts "\n\n\n\n\n\n@@@@@@@@@@\n\n\n\n\n"

    @experience = Experience.new(experience_params)
    puts @experience.rating
    puts "\n\n\n\n\n\n@@@@@@@@@@\n\n\n\n\n"
    @experience.user_id = current_user.id
    @place = Place.find(params[:experience][:place_id])
    if @experience.save
      redirect_to @place, notice: 'Rating was successfully submitted.'
    else
      render :show
    end
  end
  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end



  # POST /places or /places.json
  def create
    @place = Place.new(place_params)
    @place.user_id = current_user.id
    respond_to do |format|
      if @place.save
        format.html { redirect_to place_url(@place), notice: "Place was successfully created." }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1 or /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to place_url(@place), notice: "Place was successfully updated." }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1 or /places/1.json
  def destroy
    @place.destroy!
    @experience.destroy!
    respond_to do |format|
      format.html { redirect_to places_url, notice: "Place was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def place_params
      params.require(:place).permit(:title, :city, :address, :description, :user_id, :photo)
    end

    def experience_params
      params.require(:experience).permit(:rating, :comment, :place_id)
    end
end
