class DepositsController < WebclientController
	def index
		unless params[:has_history].blank?
			with_history = !params[:has_history].nil?
			@deposits = @deposits.where(has_history: with_history)
		end
		unless params[:psd_type].blank?
			@deposits = @deposits.where(psd_type: params[:psd_type])
		end
		unless params[:psd_origin_bank].blank?
			@deposits = @deposits.where(psd_origin_bank: params[:psd_origin_bank])
		end
		unless params[:psd_origin_user_rut].blank?
			@deposits = @deposits.where(psd_origin_user_rut: params[:psd_origin_user_rut])
		end
		render json: PaginatedBatch.new(@deposits)
	end
end
