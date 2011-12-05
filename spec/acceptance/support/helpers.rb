module HelperMethods
  
# ------ User related

  def primary_user
    @primary ||= User.first
  end

  def other_user
    @other ||= User.last
  end

  def users
    @users ||= []
  end
  
  def logged_in_as(login)
    user = User.find_by_login(login)
    users << Factory(:user, :login => login, :name => "Default User") unless user
    visit login_page
    fill_in("user_login", :with => login)
    fill_in("user_password", :with => "123456")
    click_button("Sign In")
  end
  
  def few_users_registered
    20.times do
      new_user = Factory(:user)
      new_user.update_status("Hello from #{new_user.name}")
      users << new_user
    end
  end
  
  def user_following_other_users
    users[0..2].each do |user|
      primary_user.follow!(user)
    end
  end
  
  def user_has_some_followers
    users[0..2].each do |user|
      user.follow!(primary_user)
    end
  end
  
  def follow_other_user
    primary_user.follow!(other_user)
  end

# ------ Group related

	def default_group
		@default_group ||= Group.create(:leader => User.find_by_login("default"), :name => "Test Group")
	end
	
	def default_forum
		@default_forum ||= Factory(:forum, :group => self.default_group)
	end
	
	def other_group
		@other_group ||= Factory(:group)
	end
	
	def other_forum
		@other_forum ||= Factory(:forum, :group => self.other_group)
	end
	
	def generate_posts_for(forum)
		topic = Factory(:topic, :forum => forum)
		10.times do |n|
			Factory(:post, :topic => topic)
		end
	end
  
end

RSpec.configuration.include HelperMethods, :type => :acceptance
