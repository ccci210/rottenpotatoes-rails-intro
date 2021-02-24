class MoviesController < ApplicationController
  
  
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

 def index
    @movies = Movie.all
    @all_ratings =  ['G', 'PG', 'PG-13','R']
    @ratings_to_show  = @all_ratings
    
    puts @ratings_to_show 
    #if no rating 
    if session[:ratings].nil?
      session[:ratings] =@all_ratings
    end
    if session[:sort].nil?
       session[:sort] ='id' #default by id
    end
    
     if params[:sort] == 'title'
      @title_h = 'hilite'
      @ordering='title'
      #@movies = Movie.where({rating: @ratings_to_show }).order('title')
      session[:sort]=params[:sort]
    end
    
    if params[:sort] == 'release_date'
      @release_h = 'hilite'
      @ordering='release_date'
      #@movies = Movie.where({rating: @ratings_to_show }).order('release_date')
      session[:sort]=params[:sort]
    #  @movies = Movie.order(params[:sort]).all
    end
    if params[:ratings]
      @ratings_to_show  = params[:ratings].keys #check selected rating
      puts @ratings_to_show 
      session[:ratings] = @ratings_to_show  
    elsif session[:ratings]
      @ratings_to_show  = session[:ratings]
    end 
    
    if session[:ratings]
      @movies = Movie.where({rating: @ratings_to_show }).order(session[:sort])  
    end
  
   
    @movies = Movie.where({rating: @ratings_to_show }).order(@ordering)
    
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
