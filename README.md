# Oauth2 Demo

## Step1
- サーバーを起動
- `http://localhost:3000/oauth/applications`にて、New Application
- Redirect URIを`http://localhost:4567/auth/test/callback`に設定の上、登録
- Application Id, Secretをメモ

## Step2
- APPLICATION_IDとAPPLICATION_SECRET、APPLICATION_URL、APPLICATION_SCOPESをapp.rbに設定

```app.rb
def client
  OAuth2::Client.new(APPLICATION_ID, APPLICATION_SECRET, site: APPLICATION_URL)
end
```

## Step3
- Sinatraを起動
- [localhost:4567](http://localhost:4567/) へアクセス

```
$ bundle exec ruby app.rb
```

## 参考

[Gazler/Oauth2-Tutorial: A simple Oauth2 Provider using the oauth-plugin gem](https://github.com/Gazler/Oauth2-Tutorial)
