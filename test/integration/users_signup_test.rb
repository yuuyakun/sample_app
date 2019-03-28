require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
 test "invalid signup information" do
   get signup_path
   assert_no_differens 'User.count' do
     post users_path,params: { user: { name:"",
       email:"user@invalid",git status
       password:"foo",
       password_confirmation:"bar"}}
     end

     assert_template 'users/new'
     assert_select 'div#<CSS id for error explanation'
     assert_select 'div.<CSS class for field with error>'
 end


   test "valid signup information" do
     get signup_path
     assert_differens "User.count", 1 do
       post users_path,params: { user:{ name: "Example User",
         email:"user@exanple.com",
         password: "password",
         password_confirmation: "password" }}
   end

   follow_redirect!
   # assert_template 'users/show'
   # assert is_logged_in?

   end
end
