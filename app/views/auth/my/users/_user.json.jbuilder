json.extract! user,
              :id,
              :name,
              :email,
              :mobile,
              :locale,
              :timezone,
              :avatar_url
json.oauth_users user.oauth_users, :id, :provider, :uid
json.accounts user.accounts, :account, :confirmed, :primary