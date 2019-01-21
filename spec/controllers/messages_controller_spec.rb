require 'rails_helper'

describe MessagesController do
  # letを利用してテスト中使用するインスタンスを定義
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe '#index' do
    #ログインしている場合のテスト
    context 'log in' do
      before do
        #contoroller_macros.rb
        login user
        get :index, params: { group_id: group.id }
      end
      #@messageはMessage.newで定義された新しいMessageクラスのインスタンス
      #be_a_newマッチャを使って対象が引数で指定したクラスのインスタンスかつ未保存のレコードであるかどうか確かめることができる

      #:messageがMessageクラスのインスタンスかつ未保存かどうか
      it 'assigns @message' do
        expect(assigns(:message)).to be_a_new(Message)
      end
      #:groupとgroupが同一であることを確かめている
      it 'assigns @group' do
        expect(assigns(:group)).to eq group
      end
      #example内でリクエストが行われた時のビューがindexアクションのビューと同じかどうか
      it 'redners index' do
        expect(response).to render_template :index
      end
    end

    #ログインしていない場合のテスト
    context 'not log in' do
      before do
        get :index, params: { group_id: group.id }
      end

      #非ログイン時リダイレクトするか
      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#create' do
    #attributes_forはFactoryBotによって定義されるメソッド オブジェクトを生成せずハッシュを生成する
    let(:params) {{ group_id: group.id, user_id: user.id, message: attributes_for(:message)}}

    #ログインしている場合
    context 'log in' do
      before do
        login user
      end

      #メッセージの保存に成功した場合
      context 'can save' do
        subject {
          post :create,
          params: params
        }

        #Messageモデルのレコードの総数が一個増えたかどうかを確認
        it 'count up message' do
          expect{ subject }.to change(Message, :count).by(1)
        end

        #画面遷移しているか
        it 'redirects to group_messages_path' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      #ログインしているかつメッセージの保存に失敗した場合
      context 'can not save' do
        #contentとimageをnilにしてinvalid_paramsに渡すことでメッセージの保存を失敗させている
        let(:invalid_params) {{ group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil)}}

          subject {
            post :create,
            params: invalid_params
          }

        #Messageモデルのレコード数が変化しないことを確かめる
        it 'does not count up' do
          expect{ subject }.not_to change(Message, :count)
        end

        #メッセージの保存に失敗したらindexのビューをrenderするのを確かめる
        it 'renders index' do
          subject
          expect(response).to render_template :index
        end
      end
    end

    #ログインしていない場合
    context 'not log in' do

      #createアクションをリクエストしたらログイン画面にリダイレクト
      it 'redirects to new_user_session_path' do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end


#beforeブロック内部に各exampleが実行される直前に毎回実行される
#beforeブロックに共通の処理をまとめることで、コードの量が減り読みやすいテストを書くことができる
#今回は[ログインする][擬似的にindexアクションを動かすリクエストを行う]が共通処理
#messagesのルーティングはgroupsにネストされているため、group_idを含んだパスを生成します。そのため、getメソッドの引数として、params: { group_id: group.id }を渡しています。
