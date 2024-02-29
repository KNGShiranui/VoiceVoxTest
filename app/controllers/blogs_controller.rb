class BlogsController < ApplicationController
  include HTTParty
  before_action :set_blog, only: %i[ show edit update destroy ]

  def index
    @blogs = Blog.all
  end

  def my_index
    @blogs = current_user.blogs
  end

  def show
  end

  def read_blog
    blog = Blog.find(params[:id])
    voice_data = VoicevoxService.text_to_speech(blog.content, 3)

    if voice_data
      send_data voice_data, type: 'audio/wav', disposition: 'inline'
    else
      render plain: "音声合成に失敗しました。", status: :internal_server_error
    end
  end

  def new
    @blog = Blog.new
  end

  def edit
  end

  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to blog_url(@blog), notice: "Blog was successfully created." }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to blog_url(@blog), notice: "Blog was successfully updated." }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to blogs_url, notice: "Blog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :content, :user_id)
  end
end
