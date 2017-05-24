Spree::Admin::UsersController.class_eval do

  # Update user's news subscription preferences, and sendgrid and news_subscription models
  # The news subscription model already has the callbacks to sendgrid and the preferences
  # So we should just call that here, and let it take care of the rest
  
  def update_news_subscriptions
    @user = Spree::User.find(params[:id])

    if params[:user][:preferred_newsletter_subscription] == '1'
      Spree::NewsSubscription.find_or_create_by(kind: 'newsletter', email: @user.email, user_id: @user.id)
    else
      Spree::NewsSubscription.newsletter.find_by_user_id(@user.id).try(:destroy)
    end

    if params[:user][:preferred_availability_subscription] == '1'
      Spree::NewsSubscription.find_or_create_by(kind: 'availability', email: @user.email, user_id: @user.id)
    else
      Spree::NewsSubscription.availability.find_by_user_id(@user.id).try(:destroy)
    end

    if params[:user][:preferred_new_product_subscription] == '1'
      Spree::NewsSubscription.find_or_create_by(kind: 'new_product', email: @user.email, user_id: @user.id)
    else
      Spree::NewsSubscription.new_product.find_by_user_id(@user.id).try(:destroy)
    end

    flash[:notice] = "This user's email preferences have been updated"
    redirect_to admin_user_url(@user)
  end

end
