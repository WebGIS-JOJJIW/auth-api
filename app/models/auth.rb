class Auth
  TOKEN_EXPIRY = 30.minutes
  REFRESH_TOKEN_EXPIRY = 1.hour
  REFRESH_TOKEN_FIX_EXPIRY = 2.hour
  TOKEN_ALGORITHM = 'HS256'
  SECRET_KEY = ENV.fetch('SECRET_KEY_BASE') { "!&#my-secret!&#" }

  def self.create_token(user)
    expiry_time = Time.current + TOKEN_EXPIRY
    token = Auth.encode_jwt({
      user_id: user.id,
      created_at: Time.current,
      expired_at: expiry_time,
      exp: expiry_time.to_i,
      token_type: 'access'
    })
    AuthenticationApi.redis.set(token, true, ex: TOKEN_EXPIRY)
    token
  end

  def self.create_refresh_token(user, fix_expired_at = Time.current + REFRESH_TOKEN_FIX_EXPIRY)
    expiry_time = Time.current + REFRESH_TOKEN_EXPIRY
    token = Auth.encode_jwt({
      user_id: user.id,
      created_at: Time.current,
      expired_at: expiry_time,
      exp: expiry_time.to_i,
      fix_expired_at: fix_expired_at,
      token_type: 'refresh'
    })
    AuthenticationApi.redis.set(token, true, ex: REFRESH_TOKEN_EXPIRY)
    token
  end

  def self.destroy_token(token)
    AuthenticationApi.redis.del(token)
  end

  def self.valid_token?(token)
    if AuthenticationApi.redis.get(token)
      data = Auth.decode_jwt(token)
      if (data['token_type'].to_s == 'access' && Time.current <= data['expired_at']) || (data['token_type'].to_s == 'refresh' && Time.current <= data['expired_at'] && Time.current <= data['fix_expired_at'])
        return true
      end
    end
  end

  def self.find_user_by_token(token)
    if AuthenticationApi.redis.get(token)
      data = Auth.decode_jwt(token)
      if data
        return User.find_by(id: data['user_id'])
      end
    end
  end

  def self.renew_token(refresh_token)
    data = Auth.decode_jwt(refresh_token)

    if valid_token?(refresh_token) && data['token_type'].to_s == 'refresh' && data['fix_expired_at'].present?
      fix_expired_at = data['fix_expired_at']
      user = User.find_by(id: data['user_id'])

      new_token = create_token(user)
      new_refresh_token = create_refresh_token(user, fix_expired_at)

      return { token: new_token, refresh_token: new_refresh_token }
    else
      return nil
    end
  end

  private

  def self.encode_jwt(payload)
    kid, secret_key, token_algorithm = get_secret
    payload["kid"] = kid
    JWT.encode(payload, secret_key, token_algorithm)
  end

  def self.decode_jwt(token)
    kid, secret_key, token_algorithm = get_secret
    begin
      JWT.decode(token, secret_key, true, algorithm: token_algorithm).first
    rescue JWT::DecodeError
      nil
    end
  end

  def self.get_secret
    begin
      # get secret key, algorithm and kid from api gateway
      payload = {}
      headers = {
        "Authorization" => "Bearer #{ENV.fetch('API_GATEWAY_TOKEN') { "" }}"
      }
      resp = $api_gateway_conn.get('/consumers/loginserverissuer/jwt', payload, headers )
      data = JSON.parse(resp.body)["data"].first
      kid = data['key']
      secret_key = data['secret']
      token_algorithm = data['algorithm']
    rescue => e
      Rails.logger.error "Error: #{e.message}"
    end

    kid ||= ""
    secret_key ||= SECRET_KEY
    token_algorithm ||= TOKEN_ALGORITHM

    return kid, secret_key, token_algorithm
  end

end