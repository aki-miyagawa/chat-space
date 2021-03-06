require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do

  #メッセージを保存できる場合のテスト
    context 'can save' do #contextでグループ分け

      it "is valid with content" do
        expect(build(:message, image: nil)).to be_valid
      end

      it "is valid with image" do
        expect(build(:message, content: nil)).to be_valid
      end

      it "is valid with content and image" do
        expect(build(:message)).to be_valid
      end
    end

  #メッセージを保存出来ない場合のテスト
    context 'can not save' do

      it 'is invalid without content and image' do
        message = build(:message, content: nil, image: nil)
        message.valid?
        expect(message.errors[:content]).to include("can't be blank")
      end

      it 'is invalid without group_id' do
        message = build(:message, group_id: nil)
        message.valid?
        expect(message.errors[:group]).to include("must exist")
      end

      it 'is invaid without user_id' do
        message = build(:message, user_id: nil)
        message.valid?
        expect(message.errors[:user]).to include('must exist')
      end

    end
  end
end
