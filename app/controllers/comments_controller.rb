class CommentsController < ApplicationController
    
    before_action :authenticate_user!


    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.build(comment_params)
        @comment.user = current_user
        if @comment.save
            redirect_to @post, notice: 'Comentario creado exitosamente.'
        else
            redirect_to @post, alert: 'No se pudo crear el comentario.'
        end
    end
    
        def destroy
            @comment = Comment.find(params[:id])
            if @comment.user == current_user
                @comment.destroy
                redirect_to @comment.post, notice: 'Comentario eliminado exitosamente.'
            else
                redirect_to @comment.post, alert: 'No tienes permiso para eliminar este comentario.'
            end
        end
    
        private
    
        def comment_params
            params.require(:comment).permit(:content)
        end
end
