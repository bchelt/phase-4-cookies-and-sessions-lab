class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :set_session

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    if session[:page_views] < 3
      article = Article.find(params[:id])
      render json: article
    else
      render :json => {error: "Maximum pageview limit reached"}, :status => 401
    end
    session[:page_views] += 1
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def set_session
    session[:page_views] ||= 0
  end
end
