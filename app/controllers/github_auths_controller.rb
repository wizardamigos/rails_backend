class GithubAuthsController < ApplicationController

  TEST_CODE = "123798"
  def access_token
    code      = params["code"] #GITHUB TOKEN PARAMS
    promocode = params["promocode"] #INIVITATION CODE PARAMS
    Rails.logger.debug("This is code: #{code}")
    Rails.logger.debug("This is promocode: #{promocode}")

    token      = get_token(code)
    validPromo = verify_promocode(promocode)

    if (token && !validPromo)
      user = get_user(token)
      id = user.github_id if user.present?
      if (user) # CASE: Already registered user
        created_at = user.created_at
        response = { token: token, validPromo: true, id: id, createdAt: created_at }
      else # CASE: Github User without promocode (aka Faker)
        response = { token: nil, validPromo: validPromo, id: nil }
      end
    elsif (token && validPromo)
      user = get_user(token)
      if (!user) # CASE: New User
        github_user = get_github_user(token)
        user = create_new_user(github_user, token, promocode)
        created_at = user.created_at
        Promocode.find_by_code(promocode).destroy if promocode != TEST_CODE
        response = { token: token, validPromo: validPromo, id: user.github_id, createdAt: created_at }
      else # CASE: registered user wants to register again
        created_at = user.created_at
        response = { token: token, validPromo: validPromo, id: user.github_id, createdAt: created_at }
      end
    elsif (!token && validPromo) || (!token && !validPromo)  #User sends just a promocode
      response = { token: token, validPromo: validPromo, id: nil }
    end
    Rails.logger.debug("This is response: #{response}")
    render json: response
  end

  def get_token (code)
    res = HTTP.post("https://github.com/login/oauth/access_token", :params => {:client_id => ENV["client_id"], :client_secret => ENV["client_secret"], :code => code}, )
    res_string = "#{res}"
    token_res = res_string.split(/=(.*?)&/)[1]
    if token_res == "bad_verification_code"
      return nil
    end
    token_res
  end

  def verify_promocode (promocode)
    promocodes = [TEST_CODE]    # @TODO: Change
    Promocode.all.each do |promocode|
      promocodes << promocode.code
    end
    validPromo = promocodes.include?promocode
  end

  def get_github_user (token)
    res = HTTP.get("https://api.github.com/user?access_token="+token)
    res_string = "#{res}"
    res_hash = JSON[res_string]
  end

  def get_user (token)
    github_user = get_github_user(token)
    id = github_user["id"]
    user = User.find_by_github_id(id)
  end

  def create_new_user (github_user, token, promocode)
    name = github_user["name"]
    email = github_user["email"]
    id = github_user["id"]
    if name.to_s.empty? != true
      first_name = name.split(" ").first
      last_name = name.split(" ").last
    end
    city = github_user["location"]
    User.create(
      email: email,
      first_name: first_name,
      last_name: last_name,
      city: city,
      github_id: id,
      promocode: promocode )
  end


end
