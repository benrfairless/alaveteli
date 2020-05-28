require 'spec_helper'

RSpec.shared_context 'Project::Queue context' do
  let(:project) do
    FactoryBot.create(:project,
                      contributors_count: 2,
                      classifiable_requests_count: 2,
                      extractable_requests_count: 2)
  end

  let(:current_user) { project.contributors.last }

  let(:session) { {} }

  let(:queue) { described_class.new(project, current_user, session) }
end

RSpec.shared_examples 'Project::Queue' do
  describe '#skip' do
    subject { queue.skip(info_request) }

    context 'when the skipped list is empty' do
      let(:info_request) { double(id: 1) }
      it { is_expected.to match_array(%w(1)) }
    end

    context 'when adding to the skipped list' do
      let(:info_request) { double(id: 1) }
      before { queue.skip(double(id: 2)) }
      it { is_expected.to match_array(%w(2 1)) }
    end
  end

  describe '#==' do
    subject { queue == other_queue }

    context 'when the queue is the same' do
      let(:other_queue) { described_class.new(project, current_user, session) }
      it { is_expected.to eq(true) }
    end

    context 'with a different project' do
      let(:other_queue) { described_class.new(double, current_user, session) }
      it { is_expected.to eq(false) }
    end

    context 'with a different user' do
      let(:other_queue) { described_class.new(project, double, session) }
      it { is_expected.to eq(false) }
    end

    context 'with a different session' do
      let(:other_queue) { described_class.new(project, current_user, double) }
      it { is_expected.to eq(false) }
    end
  end
end
