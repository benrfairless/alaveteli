require 'spec_helper'

RSpec.describe RefusalAdviceController do
  describe 'POST #create' do
    let(:params) do
      {
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

    context 'valid params' do
      it 'returns a success' do
        post :create, params: params
        expect(response).to be_successful
      end

      it 'parses params correctly' do
        post :create, params: params

        expect(assigns(:params).to_h).to match(
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
  end
end
