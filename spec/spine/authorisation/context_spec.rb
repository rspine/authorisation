require 'spine/authorisation'

module Spine
  module Authorisation
    module Restriction
      extend self

      def restricted?(context)
        true
      end
    end

    permissions do
      define(:user).grant(:read, :all).grant(:write, :data)
    end

    restrictions do
      register(Restriction).restrict(:write, :all)
    end

    describe Context do
      subject { double(subject: user, role: role).extend(Context) }
      let(:user) { double }
      let(:role) { :user }
      let(:listener) { double }

      before(:each) do
        subject.subscribe(listener)
      end

      it 'grants authorization' do
        expect(listener).to receive(:notify).with(:granted, subject, :read, :data)
        expect(subject.authorize(:read, :data)).to be true
      end

      it 'denies authorisation' do
        expect(listener).to receive(:notify).with(:denied, subject, :delete, :data)
        expect(subject.authorize(:delete, :data)).to be false
      end

      it 'restricts authorization' do
        expect(listener).to receive(:notify)
          .with(:restricted, subject, Restriction, :write, :data)
        expect(subject.authorize(:write, :data)).to be false
      end
    end
  end
end
