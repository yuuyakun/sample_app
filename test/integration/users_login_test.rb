
require 'test helper'

  class UsersLoginTest < ActionDispatch::integrationTest

    def setup
      @user = users(:michael)

    end


  test "login with invalid infomation" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session:{ email:"",password:""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
