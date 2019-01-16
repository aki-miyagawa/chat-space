class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :messages

  validates :name, presence: true

  def show_last_message
    if (last_message = messages.last).present? #最新メッセージを変数last_messageに代入しつつメッセージが投稿されているかどうか場合分けをしている
      last_message.content? ? last_message.content : '画像が投稿されています。' #三項演算子 [条件式 ? trueの時の値 : falseの時の値]

    else
      'まだメッセージはありません。'
    end
  end
end

# show_last_messageの違う書き方
#   def show_last_message
#     if (last_message = message.last).present?
#       if last_message.content?
#         last_message.content
#       else
#         '画像が投稿されています。'
#       end
#     else
#       'まだメッセージはありません。'
#     end
#   end
