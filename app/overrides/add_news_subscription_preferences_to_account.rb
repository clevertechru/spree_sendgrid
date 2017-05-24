Deface::Override.new(virtual_path: 'spree/users/show',
                     name: 'add_news_subscription_to_account',
                     insert_after: '[data-hook="account_my_orders"]',
                     partial: 'spree/users/news_subscriptions',
                     disabled: false)

Deface::Override.new(virtual_path: 'spree/admin/users/edit',
                     name: 'add_news_subscription_to_admin_user_show',
                     insert_after: '[data-hook="admin_user_edit_general_settings"]',
                     partial: 'spree/admin/users/news_subscriptions',
                     disabled: false)
                     