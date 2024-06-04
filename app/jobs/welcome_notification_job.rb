class WelcomeNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    NotificationMailer.welcome(user).deliver_now
  end
end
