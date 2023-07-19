class UserMailer < ApplicationMailer
  def approved_mail
    mail(
        to: 'vinitaksoni0502@yopmail.com',
        from: 'builder.bx_dev@engineer.ai',
        subject: 'Approved Mail') do |format|
      format.html { render 'approved_mail' }
    end
  end

  def rejected_mail
    mail(
      to: 'vinitaksoni0502@yopmail.com',
      from: 'builder.bx_dev@engineer.ai',
      subject: 'Rejected Mail') do |format|
    format.html { render 'rejected_mail' }
  end
  end
end
