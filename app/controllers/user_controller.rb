class UserController < ApplicationController
  def index
    users_per_page = UserConstants::PER_PAGE
    current_page = params[:page].to_i || 1
    total_users = User.count
    total_pages = calculate_total_pages(total_users, users_per_page)
    users_offset = calculate_users_offset(current_page, users_per_page)

    @data = paginated_users(users_per_page, users_offset)

    @pagination = {
      current_page: current_page,
      total_pages: total_pages
    }
  end

  def show
    @user = UserRepository.find(params[:id])

    if @user.nil?
      flash[:danger] = 'User not found'
      redirect_to users_path
    else
      render 'show'
    end
  end

  private

  def paginated_users(users_per_page, users_offset)
    UserRepository.all.limit(users_per_page).offset(users_offset)
  end

  def calculate_total_pages(total_users, users_per_page)
    (total_users.to_f / users_per_page).ceil
  end

  def calculate_users_offset(current_page, users_per_page)
    (current_page - 1) * users_per_page
  end

  def fetch_users_data
    users_data = UserService.consume_api
    users_data['users'].map { |user_data| build_user(user_data) }
  end

  def build_user(user_data)
    User.new(user_data).tap(&:save)
  end
end
