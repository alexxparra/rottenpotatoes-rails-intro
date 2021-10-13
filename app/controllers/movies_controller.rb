class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if !params[:ratings].blank? then
      session[:ratings] = params[:ratings].to_yaml()
      @ratings_to_show = YAML.load(session[:ratings])
    else
      if params[:commit].blank? and !session[:ratings].blank?
        @ratings_to_show = YAML.load(session[:ratings])
      else
        @ratings_to_show = []
        session[:ratings] = [].to_yaml
      end
    end
    #@movies = Movie.all
    @all_ratings = Movie.all_ratings
    if @ratings_to_show.blank?
     @movies = Movie.all
    else
     @movies = Movie.with_ratings(@ratings_to_show)
    end
    if !params[:sort].blank? then
      session[:sort] = params[:sort]
    end
    if !session[:sort].blank? then
      if session[:sort] == 'title' then
        @title_classes = 'hilite text-primary'
        @date_classes = 'text-primary'
        @movies = @movies.order(:title)
      else
        @title_classes = 'text-primary'
        @date_classes = 'hilite text-primary'
        @movies = @movies.order(:release_date)
      end
    else
      @title_classes = 'text-primary'
      @date_classes = 'text-primary'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
