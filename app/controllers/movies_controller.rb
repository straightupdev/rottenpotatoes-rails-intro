class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by ID
  end

  def index
    
    if !params[:sort].nil?
      session[:sort] = params[:sort]
    elsif !session[:sort].nil?
      params[:sort] = session[:sort]
    end
    
    if !params[:ratings].nil?
      begin
        session[:ratings] = params[:ratings].keys
      rescue
        session[:ratings] = params[:ratings]
      end
    elsif
      params[:ratings] = session[:ratings]
    end

    @all_ratings = Movie.get_all_ratings
    
    if session[:ratings].nil?
      @filtering = String.new # initialize string to prevent view exceptions
      @movies = Movie.all
    else
      @filtering = session[:ratings]
      @movies = Movie.with_ratings(@filtering)
    end
    
    if session[:sort] == 'title'
      @movies.order!(:title)
    elsif session[:sort] == 'date'
      @movies.order!(:release_date)
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

end
