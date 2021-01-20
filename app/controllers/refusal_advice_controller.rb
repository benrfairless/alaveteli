##
# Controller to store advice, from the refusal advice wizard, given to users
# after their Info Requests are marked as refused/rejected.
#
class RefusalAdviceController < ApplicationController
  before_action :authenticated?

  def create
    log_event

    case parsed_refusal_advice_params.fetch(:button)
    when 'clarification'
      redirect_to new_request_followup_path(
        request_id: info_request.id, anchor: 'followup'
      )

    when 'internal_review'
      redirect_to new_request_followup_path(
        request_id: info_request.id, internal_review: '1', anchor: 'followup'
      )

      # TODO: there are other actions - define what to do in the refusal advice
      # YAML?
    end
  end

  private

  def info_request
    @info_request ||= current_user.info_requests.
      find_by!(url_title: params.require(:url_title))
  end

  def log_event
    info_request.log_event(
      'refusal_advice',
      parsed_refusal_advice_params.merge(user: current_user.to_param).to_h
    )
  end

  def refusal_advice_params
    params.require('refusal_advice').permit(:button, questions: {}, actions: {})
  end

  def parsed_refusal_advice_params
    refusal_advice_params.merge(
      actions: refusal_advice_params.fetch(:actions).
        each_pair do |_, suggestions|
          suggestions.transform_values! { |v| v == 'true' }
        end
    )
  end
end
