require 'rails_helper'

RSpec.describe User, type: :model do
  describe "state transitions" do
    context "from pending" do
      it "can transition to approved" do
        my_user = User.create(state: 'pending')

        expect(my_user.state).to eq('pending')
        my_user.approve
        expect(my_user.state).to eq('approved')
      end

      it "cannot transition to completed" do
        my_user = User.create(state: 'pending')
        expect(my_user.state).to eq('pending')
        expect { my_user.complete }.to raise_error(AASM::InvalidTransition)
      end

      it "cannot transition to approved if condition is not met" do
        my_user = User.create(state: 'completed')
        expect(my_user.state).to eq('completed')
        expect { my_user.approve }.to raise_error(AASM::InvalidTransition)
      end
    end

    context "from approved" do
      it "can transition to completed" do
        my_user = User.create(state: 'approved')

        expect(my_user.state).to eq('approved')
        my_user.complete
        expect(my_user.state).to eq('completed')
      end

      it "cannot transition to rejected" do
        my_user = User.create(state: 'approved')

        expect(my_user.state).to eq('approved')
        expect { my_user.reject }.to raise_error(AASM::InvalidTransition)
      end
    end

    context "test callbacks" do
      it "triggers the 'create_snapshot' callback" do
        my_user = User.create(state: 'pending')
        expect(my_user).to receive(:create_snapshot).once
        my_user.reject!
      end
  
      it "triggers the 'send_rejection_email' callback" do
        my_user = User.create(state: 'pending')
        expect(my_user).to receive(:send_rejection_mail).once
        my_user.reject!
      end
  
      it "does not trigger the 'create_snapshot' callback if the transition fails" do
        my_user = User.create(state: 'pending')
        expect(my_user).not_to receive(:create_snapshot)
        expect { my_user.complete }.to raise_error(AASM::InvalidTransition)
      end
    end
  end
end