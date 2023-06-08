class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show update edit destroy ]
  before_action :authenticate_user!, except: [:index, :show]

#  before_action only: [:update, :show] do
#    authorize_request(["normal_user", "admin"])
#  end
  before_action only: [:new, :edit, :create, :destroy] do
        authorize_request(["admin"])
  end

  # GET /photos or /photos.json
  def index
    @photos = Photo.all
    @comments = Comment.all
    @user = User.new
  end

  # GET /photos/1 or /photos/1.json
  def show
    @comment = Comment.new
#    @photo.comments.build
  end

  # GET /photos/new
  def new
    @photo = Photo.new
#    @photo.comments.build
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos or /photos.json
  def create
    @photo = Photo.new(photo_params)
    respond_to do |format|
      if @photo.save
        format.html { redirect_to photo_url(@photo), notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    if params[:photo]   # Para caso de modificar foto (Solo Karina)
      respond_to do |format|
        if @photo.update(photo_params)
          format.html { redirect_to photo_url(@photo), notice: "Photo was successfully updated." }
          format.json { render :show, status: :ok, location: @photo }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @photo.errors, status: :unprocessable_entity }
        end
      end
    elsif params[:comment]  # Para agregar comentario a Fotos (Todos los usuarios registrados)
      @comment = Comment.new
      @comment.user_id = current_user.id
      @comment.photo_id = @photo.id
      @comment.post = params[:comment][:post]
      respond_to do |format|
        if @comment.save!
          format.html { redirect_to photos_path, notice: "Comment was successfully added." }
          format.json { render :show, status: :ok, location: @photo }
        else
          format.html { render :show, status: :unprocessable_entity }
          format.json { render json: @photo.errors, status: :unprocessable_entity }
        end
      end
    end

    
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to photos_url, notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.require(:photo).permit(:id, :image, :legend)
    end
end
