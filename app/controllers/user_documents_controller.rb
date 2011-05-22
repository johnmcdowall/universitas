class UserDocumentsController < InheritedResources::Base
	defaults :route_collection_name => 'documents', :route_instance_name => 'document'
	before_filter :authenticate_user!, :except => [:index, :show]
	before_filter :check_uploader, :only => [:edit, :update] 
	belongs_to :user
	
	def create
		params[:user_document][:document_attributes].merge!(:uploader => current_user)
		create! do |success, failure|
			success.html{redirect_to collection_url}
		end
	end
	
	def add
		if current_user.has_document?(params[:id])
			redirect_to :back, :alert => I18n.t("users.documents.already_exists")
		else
			current_user.add_document(params[:id])
			redirect_to :back, :notice => I18n.t("users.documents.added_collection")
		end
	end
	
	def remove
		current_user.remove_document(params[:id])
		redirect_to :back, :notice => I18n.t("users.documents.removed_collection")
	end
	
	private

	def resource
		@user_document = if params[:id]
			parent.documents.find(params[:id])
		else
			@user_document.errors.blank? ? UserDocument.new(:document => Document.new) : @user_document
		end
	end

	def collection
		@user_documents = paginate(parent.documents)
	end
	
	def check_uploader
		unless current_user.uploaded_document?(resource.document)
			flash[:error] = t('users.documents.no_permission')
			redirect_to user_documents_path(current_user)
		end
	end
	
	def set_breadcrumbs
		add_breadcrumb(parent.name, :parent_url) if parent?
		add_breadcrumb(I18n.t("documents.all"), :collection_path)
		add_breadcrumb(I18n.t("documents.new"), :new_resource_path)
	end

end