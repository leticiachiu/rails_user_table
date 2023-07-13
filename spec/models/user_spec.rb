require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'with valid attributes' do
      let(:user) { build_stubbed :user }
      it 'is valid' do
        expect(user).to be_valid
      end
    end

    context 'with invalid attributes' do
      let(:user_invalid_name) { build_stubbed :user, name: nil }
      let(:user_negative_age) { build_stubbed :user, age: -20 }
      let(:user_blank_email) { build_stubbed :user, email: nil }

      it 'is invalid without a name' do
        expect(user_invalid_name).to be_invalid
        expect(user_invalid_name.errors[:name]).to include("can't be blank")
      end

      it 'is invalid with a negative age' do
        expect(user_negative_age).to be_invalid
        expect(user_negative_age.errors[:age]).to include('must be greater than or equal to 0')
      end

      it 'is invalid without an email' do
        expect(user_blank_email).to be_invalid
        expect(user_blank_email.errors[:email]).to include("can't be blank")
      end

      subject(:user) { build_stubbed :user }
      it 'is invalid with a duplicate email' do
        FactoryBot.create(:user, email: 'john@example.com')
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('has already been taken')
      end
    end
  end
end
