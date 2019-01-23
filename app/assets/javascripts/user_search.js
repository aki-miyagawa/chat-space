$(function(){
  function appendUser(user){
    var html = `<div class="chat-group-user clearfix">
                  <p class="chat-group-user__name">${user.name}</p>
                  <a class="user-search-add chat-group-user__btn chat-group-user__btn--add" data-user-id="${user.id}" data-user-name="${user.name}">追加</a>
                </div>`
    return html;
  }

  function appendNoUser(message){
    var display = `<div class="chat-group-users clearfix">
                    <p class="chat-group-user__name">${message}</p>
                  </div>`
     return display;
  }
  function removeUser(userId, name) {
    var html = `<div class='chat-group-user clearfix js-chat-member' id='chat-group-user-8'>
                  <input name='group[user_ids][]' type='hidden' value=${userId}>
                  <p class='chat-group-user__name'>${name}</p>
                  <a class='user-search-remove chat-group-user__btn chat-group-user__btn--remove js-remove-btn'>削除</a>
                </div>`
    return html
  }

  $("#user-search-field").on("keyup", function() {
    var input = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/users',
      data: { keyword: input },
      dataType: 'json'
    })

    .done(function(data) {
      $("#chat-group-users").empty();
      if (data.length !== 0) {
        data.forEach(function(user){
          var html = appendUser(user);
          $('#chat-group-users').append(html);
        })
      }
      else {
        var display = appendNoUser("一致するユーザーはいません");
        $('#chat-group-users').append(display);
      }
    })
    .fail(function(){
      alert('ユーザー検索に失敗しました');
    });
  });

  $('#chat-group-users').on('click', '.user-search-add', function(){
    var userId = $(this).attr('data-user-id');
    var name = $(this).attr('data-user-name');
    console.log(userId);
    console.log(name);
    $(this).parent().remove();
    var html = removeUser(userId, name);
    $('#chat-group-users').append(html);
  });
  $('#chat-group-users').on('click', '.user-search-remove', function(){
    $(this).parent().remove();
  });
});
