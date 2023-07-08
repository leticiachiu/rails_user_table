require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'with valid attributes' do
      let(:user) do
        User.new(name: 'John Doe', age: 25, email: 'john@example.com')
      end

      it 'is valid' do
        expect(user).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'is invalid without a name' do
        user = User.new(age: 30, email: 'jane@example.com')
        expect(user).to be_invalid
        expect(user.errors[:name]).to include("can't be blank")
      end

      it 'is invalid with a negative age' do
        user = User.new(name: 'Jane Smith', age: -10, email: 'jane@example.com')
        expect(user).to be_invalid
        expect(user.errors[:age]).to include('must be greater than or equal to 0')
      end

      it 'is invalid without an email' do
        user = User.new(name: 'Jane Smith', age: 30)
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'is invalid with a duplicate email' do
        User.create(name: 'John Doe', age: 25, email: 'john@example.com')
        user = User.new(name: 'Jane Smith', age: 30, email: 'john@example.com')
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('has already been taken')
      end
    end
  end
end
