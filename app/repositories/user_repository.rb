class UserRepository
  def self.find(id)
    User.find(id)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def self.all
    User.all
  end
end
