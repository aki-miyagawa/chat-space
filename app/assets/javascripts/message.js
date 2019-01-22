$(function(){

  function buildHTML(message){
    var imagePresent = "";
    if (message.image) {
      imagePresent = `<img class="lower-message__image" src=${message.image}>`
    }
    var html = `<div class="messages">
                  <div class="message">
                    <div class="upper-message>
                      <div class="upper-message__user-name">
                        ${message.name}
                      </div>
                      <div class="upper-message__date">
                        ${message.created_at}
                      </div>
                    </div>
                    <div class="lower-message">
                      <div class="lower-message__content">
                      ${message.content}
                      ${imagePresent}
                      </div>
                    </div>
                  </div>
                </div>`

    return html;
  }

  $('#new_message').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action')
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
      $('.messages').append(html)
      $('#new_message')[0].reset()
    })
    .fail(function(){
      alert('error')
    })
    .always(() => {
      $(".form__submit").removeAttr("disabled");
    })
  })
});
