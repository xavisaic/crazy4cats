class LikesController < ApplicationController

    before_action :authenticate_user!

    def create
        @post = Post.find(params[:post_id])
        existing_like = @post.likes.find_by(user: current_user)
        if existing_like
        existing_like.update(anonymous: params[:anonymous])
        redirect_to @post, notice: 'Like actualizado.'
        else
        @like = @post.likes.build(user: current_user, anonymous: params[:anonymous])
        if @like.save
            redirect_to @post, notice: 'Like creado exitosamente.'
        else
            redirect_to @post, alert: 'No se pudo crear el like.'
        end
        end
    end

    def destroy
        @like = Like.find(params[:id])
        if @like.user == current_user
        @like.destroy
        redirect_to @like.post, notice: 'Like eliminado exitosamente.'
        else
        redirect_to @like.post, alert: 'No tienes permiso para eliminar este like.'
        end
    end
end
