class User < ApplicationRecord
  include AASM

  aasm column: 'state' do
    state :pending, initial: true
    state :approved
    state :rejected
    state :completed

    event :approve do
      transitions from: :pending, to: :approved, after: :send_approval_mail, guards: :uncompleted_user?
    end

    # event :reject do
    #   transitions from: :pending, to: :rejected, before: :create_snapshot, after: :send_rejection_mail, guards: :uncompleted_user?
    # end

    event :reject, before: :create_snapshot, after: :send_rejection_mail do
      transitions from: :pending, to: :rejected, guards: :uncompleted_user?
    end


    event :complete do
      transitions from: [:approved, :rejected], to: :completed
    end
  end

  def send_approval_mail
    UserMailer.approved_mail.deliver_now
  end

  def send_rejection_mail
    UserMailer.rejected_mail.deliver_now
  end

  # guards basically used for additional check before transitions
  def uncompleted_user? 
    self.state.in?(['pending', 'approved', 'rejected'])
  end

  def create_snapshot
    puts "*"*90
    puts "Create stapshots"
    puts "*"*90
  end
end
