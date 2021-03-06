require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
	def setup 
		@user = users(:alex)
		@other_user = users(:archer)
		@not_activated_user = users(:notactive)
	end

	test "index as admin including pagination and delete links" do
		log_in_as(@user)
		get users_path
		assert_template 'users/index'
		assert_select 'div.pagination', count: 2
		User.paginate(page: 1).each do |user|
			if user.activated?
				assert_select 'a[href=?]', user_path(user), text: user.name
				unless user == @user
					assert_select 'a[href=?]', user_path(user), text: 'delete'
				end
			end
		end
		assert_difference 'User.count', -1 do
			delete user_path(@other_user)
		end
	end

	test "index as non-admin" do
		log_in_as(@other_user)
		get users_path
		assert_select 'a', text: 'delete', count: 0
	end
	
	test "index only activated users" do
		log_in_as(@user)
		get users_path
		assert_select 'a[href=?]', user_path(@other_user)
		assert_select 'a[href=?]', user_path(@not_activated_user), count: 0
	end

end
