require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires a username and a password upon creation' do
      user1 = build(:user, username: nil, password: nil)
      user2 = build(:user, password: nil)
      user3 = build(:user, username: nil)

      expect(user1.valid?).to equal(false)
      expect(user1.errors.full_messages).to eq([
        "Password can't be blank",
        "Username can't be blank"
        ])

      expect(user2.valid?).to equal(false)
      expect(user2.errors.full_messages).to eq([
        "Password can't be blank"
        ])

      expect(user3.valid?).to equal(false)
      expect(user3.errors.full_messages).to eq([
        "Username can't be blank"
        ])
    end

    it 'requires that the username be unique' do
      create(:user)
      user = build(:user)

      expect(user.valid?).to equal(false)
      expect(user.errors.full_messages).to eq([
        "Username has already been taken"
        ])
    end

  end

  describe 'on save' do
    it 'hashes a password' do
      user = build(:user)
      user.save

      expect(user.password_digest).not_to eq(user.password)
    end
  end

  describe 'relationships' do
    it 'has many applications' do
      user = create(:user)
      user.applications.create(company: "Google", action: "email", complete: false)

      expect(user.applications.first).not_to eq(nil)
    end
  end

end
