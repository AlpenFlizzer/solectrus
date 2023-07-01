module ParamsHandling
  extend ActiveSupport::Concern

  included do
    private

    helper_method def permitted_params
      @permitted_params ||=
        params.permit(:field, :timeframe, :period, :sort, :calc)
    end

    helper_method def period
      permitted_params[:period]
    end

    helper_method def field
      permitted_params[:field]
    end

    helper_method def calc
      permitted_params[:calc]
    end

    helper_method def sort
      return if permitted_params[:sort].blank?

      ActiveSupport::StringInquirer.new(permitted_params[:sort])
    end

    helper_method def timeframe
      return if permitted_params[:timeframe].blank?

      @timeframe ||=
        Timeframe.new(
          permitted_params[:timeframe],
          min_date: Rails.application.config.x.installation_date,
          allowed_days_in_future: 6,
        )
    end
  end
end
