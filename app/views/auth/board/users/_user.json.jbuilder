json.extract!(
  user,
  :id,
  :name,
  :locale,
  :timezone,
  :avatar_url
)
json.oauth_users user.oauth_users, :id, :provider, :uid, :appid
json.accounts user.accounts, :identity, :confirmed, :primary
