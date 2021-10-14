class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings].blank? or (params[:sort].blank? and !session[:sort].blank?) then
      if !session[:ratings].blank?
        @ratings_to_show = YAML.load(session[:ratings])
      else
        @ratings_to_show = Movie.all_ratings
        session[:ratings] = @ratings_to_show.to_yaml
      end
      if !params[:sort].blank? then
        session[:sort] = params[:sort]
        redirect_to movie_path({id: '', params: {sort: params[:sort], 
          ratings: @ratings_to_show}})
        return
      end
      if !session[:sort].blank?
        redirect_to movie_path({id: '', params: {sort: session[:sort], 
          ratings: @ratings_to_show}})
        return
      end
      redirect_to movie_path({id: '', params: {ratings: @ratings_to_show}})
      return
    end
    puts params
    @ratings_to_show = params[:ratings]
    session[:ratings] = @ratings_to_show.to_yaml
    @all_ratings = Movie.all_ratings
    puts @ratings_to_show
    @movies = Movie.with_ratings(@ratings_to_show)
    @title_classes = 'text-primary'
    @date_classes = 'text-primary'
    if !params[:sort].blank? then
      session[:sort] = params[:sort]
      if params[:sort] == 'title' then
        @title_classes = @title_classes + ' hilite'
        @movies = @movies.order(:title)
      else
        @date_classes = @date_classes + ' hilite'
        @movies = @movies.order(:release_date)
      end
    else
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
