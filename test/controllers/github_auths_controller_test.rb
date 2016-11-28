require 'test_helper'

class GithubAuthsControllerTest < ActionController::TestCase
  test "should get token_request" do
    get :token_request
    assert_response :success
  end

  test "should get token_response" do
    get :token_response
    assert_response :success
  end

end
