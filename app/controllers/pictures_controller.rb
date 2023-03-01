class PicturesController < ApplicationController
  before_action :set_picture, only: %i[ show edit update destroy ]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @pictures = Picture.all
  end
  
  def new
    @picture = Picture.new
  end

  def create
    @picture = current_user.pictures.build(picture_params)
    return render :new if params[:back]
    if @picture.save
      ContactMailer.contact_mail(@picture).deliver  
      redirect_to pictures_path, notice: '画像を投稿しました'
    else
      render :new
    end
  end

  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end


  def edit
  end


  def update
    @picture = Picture.find(params[:id])
    if @picture.update(picture_params)
      redirect_to pictures_path, notice: '投稿を編集しました'
    else
    render :edit
    end
  end

  def destroy
    @picture.destroy
    redirect_to pictures_path, notice:"ブログを削除しました！"
  end

  def confirm
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  private

  def set_picture
    @picture = Picture.find(params[:id])
  end

  def picture_params
    params.require(:picture).permit(:content, :image, :image_cache, :user_id)
  end

  def ensure_correct_user
    @picture = Picture.find_by(id: params[:id])
    if @current_user.id != @picture.user_id
      flash[:notice] = "権限がありません"
      redirect_to pictures_path
    end
  end
end    