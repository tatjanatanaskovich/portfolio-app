class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy, :toggle_status]
  before_action :set_sidebar_topics, except: [:update, :create, :destroy, :toggle_status]
  layout "blog"
  access all: [:show, :index], user: {except: [:destroy, :new, :create, :update, :edit, :toggle_status]}, site_admin: :all

  def index
    if logged_in?(:site_admin)
      @blogs = Blog.recent.page(params[:page]).per(5)
    else
      @blogs = Blog.published.recent.page(params[:page]).per(5)
    end
    @page_title = "My Portfolio Blog"
  end

  def show
    if logged_in?(:site_admin) || @blog.published?
      @blog = Blog.includes(:comments).friendly.find(params[:id])
      @comment = Comment.new
      @page_title = @blog.title
      @seo_keywords = @blog.body
    else
      notice = "You are not authorized to access this page"
      redirect_to blogs_path, notice: notice
    end
  end

  def new
    @blog = Blog.new
  end

  def edit
  end

  def create
    @blog = Blog.new(blog_params)
      if @blog.save
        notice ='Your post is now created!'
        redirect_to @blog, notice: notice
      else
        render :new 
      end
  end

  def update
    if @blog.update(blog_params)
      notice = 'Your post was successfully updated.'
      redirect_to @blog, notice: notice
    else
      render :edit
    end
  end

  def destroy
    @blog.destroy
    notice = 'Post was removed.'
    redirect_to blogs_url, notice: notice
  end

  def toggle_status
    if @blog.draft?
      @blog.published!
      elsif @blog.published?
        @blog.draft!
    end
    notice = 'Post status has been updated.'
    redirect_to blogs_url, notice: notice
  end

  private

    def set_blog
      @blog = Blog.friendly.find(params[:id])
    end

    def blog_params
      params.require(:blog).permit(:title, :body, :topic_id, :status)
    end
    
    def set_sidebar_topics
      @sidebar_topics = Topic.with_blogs
    end

end
