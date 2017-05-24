# Add the preferences for communicaitions types to the user model
Spree::User.class_eval do 
  
  preference :newsletter_subscription,   :boolean, default: true
  preference :availability_subscription, :boolean, default: true
  preference :new_product_subscription,  :boolean, default: true

  # Check if the user has subscribed to the newsletter before signing up, if so, update his preference
  # retired with different logic, all new users are automatically subscribed to all subscriptions
  # after_create :check_newsletter_subscriptions
  
  after_create :create_subscriptions
  
  def create_subscriptions
    unless self.email.ends_with?("example.net")
      if newsletter_subscripttion = Spree::NewsSubscription.newsletter.find_by_email(self.email)
        self.preferred_newsletter_subscription = true
        newsletter_subscription.update_attribute(:user_id, self.id)
      else
        Spree::NewsSubscription.find_or_create_by(kind: 'newsletter', email: self.email, user_id: self.id)
      end
      Spree::NewsSubscription.find_or_create_by(kind: 'availability', email: self.email, user_id: self.id)
      Spree::NewsSubscription.find_or_create_by(kind: 'new_product',  email: self.email, user_id: self.id)
    end
  end

  def newsletter_subscription?
    Spree::NewsSubscription.newsletter.find_by(user_id: self.id) ? true : false
  end

  def availability_subscription?
    Spree::NewsSubscription.availability.find_by(user_id: self.id) ? true : false
  end

  def new_product_subscription?
    Spree::NewsSubscription.new_product.find_by(user_id: self.id) ? true : false
  end
  
  def check_newsletter_subscriptions
    if newsletter_subscription = Spree::NewsSubscription.newsletter.find_by_email(self.email)
      self.preferred_newsletter_subscription = true
      newsletter_subscription.update_attribute(:user_id, self.id)
    end
  end
end
