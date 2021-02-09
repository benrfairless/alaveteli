# Controller for managing OutgoingMessage::Snippet records
class Admin::OutgoingMessages::SnippetsController < AdminController
  before_action :set_snippet, except: %i[index]

  def index
    @title = 'Listing Snippets'
    @snippets = OutgoingMessage::Snippet.
      paginate(page: params[:page], per_page: 25)
  end

  def edit
    @title = 'Edit snippet'
  end

  def update
    if @snippet.update(snippet_params)
      redirect_to admin_snippets_path, notice: 'Snippet successfully updated.'
    else
      @title = 'Edit snippet'
      render action: :edit
    end
  end

  private

  def snippet_params
    params.require(:snippet).permit(:name, :body, :tag_string)
  end

  def set_snippet
    @snippet ||= OutgoingMessage::Snippet.find(params[:id])
  end
end
