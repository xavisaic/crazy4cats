class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :create], message: "Debes iniciar sesión para crear un post."



  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    if current_user == @post.user
      # El usuario actual es el propietario del post
      render :edit
    else
      # El usuario no tiene permiso para editar este post
      redirect_to posts_path, alert: 'No tienes permiso para editar este post.'
    end
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: 'Post creado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    if current_user == @post.user
      # El usuario actual es el propietario del post, puede eliminarlo
      @post.destroy
      redirect_to posts_path, notice: 'Post eliminado exitosamente.'
    else
      # El usuario no tiene permiso para eliminar este post
      redirect_to posts_path, alert: 'No tienes permiso para eliminar este post.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:content, :image)
    end
end
