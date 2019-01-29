$(function(){
  function buildHTML(message){
    var image = (message.image === null) ? "" : `<img src="${message.image}" class="lower-message__image">`
    var html = `<div class="upper-message" data-message-id="${message.id}">
                  <p class="upper-message__user-name">
                    ${message.user_name}
                  </p>
                  <p class="upper-message__date">
                    ${message.created_at}
                  </p>
                  <p class="lower-message__image">
                    ${message.content}
                    ${image}
                  </p>
                </div>`

    return html;
  }

  $('#new_message').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var url  = $(this).attr('action');
    var form = $(this);

    $.ajax({
      url:         url,
      type:        "POST",
      data:        formData,
      dataType:    'json',
      processData: false,
      contentType: false
    })

    .done(function(data){
      var html = buildHTML(data);
      $(".message").append(html)
      form[0].reset()
      $(".messages").animate({scrollTop: $(".messages")[0].scrollHeight}, 'fast');
    })

    .fail(function(){
      alert('error');
    })

    .always(function() {
      $(".form__submit").prop('disabled', false)
    })
  });

  var interval = setInterval(function(){
    if(window.location.href.match(/\/groups\/\d+\/messages/)){
      var id = $('.upper-message:last').data('message-id')
      $.ajax({
        url: location.href,
        type: 'GET',
        dataType: 'json',
        data: {id: id}
      })
      .done(function(messages){
        messages.forEach(function(message){
         $(".message").append(buildHTML(message));
         });
         $(".messages").animate({scrollTop: $(".messages")[0].scrollHeight}, 'fast');
      })
      .fail(function(data){
        alert('自動更新に失敗しました')
      })
    }else{
      clearInterval(interval);
    }}, 5000);

});
