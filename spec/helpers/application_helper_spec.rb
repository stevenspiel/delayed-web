require 'spec_helper'

describe Delayed::Web::ApplicationHelper, type: :helper do
  describe '#execution_class' do
    subject { helper.execution_class(time) }

    context 'when time is nil' do
      let(:time) { nil }

      it { is_expected.to be_nil }
    end

    context 'when time is an empty string' do
      let(:time) { '' }

      it { is_expected.to be_nil }
    end

    context 'when time is yesterday' do
      let(:time) { Time.now.utc - 1.day }

      it { is_expected.to eq 'immediately' }
    end

    context 'when time is in 5 seconds' do
      let(:time) { Time.now.utc + 5.seconds }

      it { is_expected.to eq 'soon' }
    end

    context 'when time is in 23 hours' do
      let(:time) { Time.now.utc + 23.hours }

      it { is_expected.to eq 'soon' }
    end

    context 'when time is in 25 hours' do
      let(:time) { Time.now.utc + 25.hours }

      it { is_expected.to eq '' }
    end
  end
end
