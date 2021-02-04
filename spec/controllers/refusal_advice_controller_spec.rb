require 'spec_helper'

RSpec.describe RefusalAdviceController do
  describe 'POST #create' do
    let(:info_request) { FactoryBot.create(:info_request) }
    let(:user) { info_request.user }

    let(:params) do
      {
        url_title: info_request.url_title,
        refusal_advice: {
          questions: {
            exemption: 'section-12', question_1: 'no', question_2: 'yes'
          },
          actions: {
            internal_review: { action_1: 'false', action_2: 'true' },
            clarification: { action_3: 'true', action_4: 'false' },
            new_request: { action_5: 'false' }
          },
          button: 'clarification'
        }
      }
    end

    before { session[:user_id] = user&.id }

    context 'valid clarification params' do
      let(:clarification_params) do
        params.deep_merge(refusal_advice: { button: 'clarification' })
      end

      it 'redirects to new request follow up' do
        post :create, params: clarification_params
        expect(response.status).to eq 302
        expect(response).to redirect_to(
          new_request_followup_path(
            request_id: info_request.id,
            anchor: 'followup'
          )
        )
      end
    end

    context 'valid internal review params' do
      let(:internal_review_params) do
        params.deep_merge(refusal_advice: { button: 'internal_review' })
      end

      it 'redirects to new request follow up with internal review param' do
        post :create, params: internal_review_params
        expect(response.status).to eq 302
        expect(response).to redirect_to(
          new_request_followup_path(
            request_id: info_request.id,
            internal_review: '1',
            anchor: 'followup'
          )
        )
      end
    end

    context 'valid params' do
      let(:info_requests) { double(:info_requests) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(user).to receive(:info_requests).and_return(info_requests)
        allow(info_requests).to receive(:find_by!).and_return(info_request)
      end

      it 'finds info request' do
        expect(info_requests).to receive(:find_by!).with(
          url_title: info_request.url_title
        )

        post :create, params: params
      end

      it 'logs event with correctly parsed params' do
        expect(info_request).to receive(:log_event).with(
          'refusal_advice',
          user: user.to_param,
          questions: {
            exemption: 'section-12', question_1: 'no', question_2: 'yes'
          },
          actions: {
            internal_review: { action_1: false, action_2: true },
            clarification: { action_3: true, action_4: false },
            new_request: { action_5: false }
          },
          button: 'clarification'
        )

        post :create, params: params
      end
    end

    context 'invalid params' do
      let(:invalid_params) do
        params.deep_merge(refusal_advice: { invalid: true })
      end

      it 'raises error' do
        expect { post :create, params: invalid_params }.to raise_error(
          ActionController::UnpermittedParameters
        )
      end
    end

    context 'missing params' do
      let(:missing_params) {}

      it 'raises error' do
        expect { post :create, params: missing_params }.to raise_error(
          ActionController::ParameterMissing
        )
      end
    end

    context 'when logged in as non-request owner' do
      let(:user) { FactoryBot.create(:user) }

      it 'cannot find info request' do
        expect { post :create, params: params }.to raise_error(
          ActiveRecord::RecordNotFound
        )
      end
    end

    context 'when logged out' do
      let(:user) { nil }

      it 'redirects to sign in form' do
        post :create, params: params
        expect(response.status).to eq 302
      end

      it 'saves post redirect' do
        post :create, params: params
        expect(get_last_post_redirect.uri).to eq '/refusal_advice'
      end
    end
  end
end
