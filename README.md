# WebGIS Authentication

## Dependency
- PostgreSQL
- Redis

## User Login
Request:
```
curl --location 'http://auth.jeypon.com:3003/auth/login' \
--header 'Content-Type: application/json' \
--data '{
  "login_name": "new_user",
  "password": "password123"
}'
```

Response:
```
{
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJjcmVhdGVkX2F0IjoiMjAyNC0xMS0wOSAxOTo1NDo0MiBVVEMiLCJleHBpcmVkX2F0IjoiMjAyNC0xMS0wOSAyMDoyNDo0MiBVVEMiLCJleHAiOjE3MzExODM4ODIsInRva2VuX3R5cGUiOiJhY2Nlc3MiLCJraWQiOiIifQ.rsiH3Du2Ea1_OcBRqITid2t335pkhOIsmgl10BWNu4s",
    "refresh_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJjcmVhdGVkX2F0IjoiMjAyNC0xMS0wOSAxOTo1NDo0MiBVVEMiLCJleHBpcmVkX2F0IjoiMjAyNC0xMS0wOSAyMDo1NDo0MiBVVEMiLCJleHAiOjE3MzExODU2ODIsImZpeF9leHBpcmVkX2F0IjoiMjAyNC0xMS0wOSAyMTo1NDo0MiBVVEMiLCJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImtpZCI6IiJ9.n72msIKHeXuSczLadENE0Mch_y3TKF7nG6faTVzUjOc"
}
```

