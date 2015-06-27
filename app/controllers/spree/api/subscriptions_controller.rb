module Spree
  module Api
    class SubscriptionsController < Spree::Api::BaseController
      before_action :find_subscription
      before_action :authenticate_user

      def skip_next_order
        @subscription.skip_next_order

        render json: @subscription.to_json
      end

      def undo_skip_next_order
        @subscription.undo_skip_next_order

        render json: @subscription.to_json
      end

      def cancel
        @subscription.cancel

        render json: @subscription.to_json
      end

      def show
        render json: @subscription.to_json
      end

      def update
        result = @subscription.update_attributes(subscription_params)

        if result
          render json: @subscription.to_json
        else
          invalid_resource!(@subscription)
        end
      end

      def update_address
        result = @subscription.send(params[:attribute]).update_attributes(address_params)
        if result
          @subscription.touch

          render json: @subscription.to_json
        else
          invalid_resource!(@subscription)
        end
      end

      private
      
      def find_subscription
        @subscription = Spree::Subscription.find(params[:id])
      end

      def address_params
        params.require(:address).permit(permitted_address_params)
      end

      def subscription_params
        params.require(:subscription).permit(permitted_subscription_attributes)
      end

      def permitted_address_params
        [:firstname, :lastname, :address1, :address2, :city, :phone, :zipcode, :state_id, :state_name, :country_id]
      end

      def permitted_subscription_attributes
        [
          :interval, :credit_card_id
        ]
      end

      def address_attributes
        [:id, :firstname, :lastname, :address1, :address2, :city, :phone, :zipcode, :state_id, :state_name, :country_id]
      end

    end
  end
end
