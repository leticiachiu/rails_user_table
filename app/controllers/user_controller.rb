class UserController < ApplicationController
  before_action :fetch_users_data, only: [:index, :show]

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
    @user = User.find(params[:id])
    render 'show'
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'User not found'
    redirect_to users_path
  end

  private

  def paginated_users(users_per_page, users_offset)
    User.all.limit(users_per_page).offset(users_offset)
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
