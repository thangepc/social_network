$(document).ready(function(){
  var authenticity_token = $('#authenticity_token').attr('value');
  $.ajaxSetup({
    data: {
      authenticity_token: authenticity_token,
    }
  });

    $('body').on('click', ".sort-order", function(e) {
        e.preventDefault();
        var sort = $(this).attr('data-sort');
        var order = $(this).attr('data-order');
        $('#frmSearch input[name="sort"]').val(sort);
        $('#frmSearch input[name="order"]').val(order);
        $('#frmSearch').submit();
    });

    $('body').on('click', '.update-status-friend', function(e) {
        e.preventDefault();
        var object = $(this);
        var status = object.attr('data-status');
        var url = object.attr('data-url');
        var favoriteId = object.attr('data-favorite-id');
        var dataRemove = object.attr('data-remove');
        var dataRemoveItem = object.attr('data-remove-item');

        if (typeof status != 'undefined' && typeof url != 'undefined') {
            $.ajax({
                url: url,
                type: 'POST',
                data: {status: status},
                success: function(result){
                    if (result.status == 1) {
                        if (typeof favoriteId != 'undefined') {
                            object.addClass('hide');
                            $(favoriteId).removeClass('hide');
                        }
                        if (typeof dataRemove != 'undefined') {
                            object.parents('li').remove();
                        }

                        if (typeof dataRemoveItem != 'undefined') {
                            object.remove();
                        }
                        showNotification('a','Info', 'success', result.message);
                    }
                }
            })
        }
    });
    $('body').on('click', '.add-friend-login', function(e) {
        e.preventDefault();
        var id = $(this).attr('data-id');
        bootbox.dialog({
            title: "LOGIN",
            message: $('#form-login').html(),
            buttons: {
                success: {
                    label: "Login",
                    className: "btn-success",
                    callback: function (result) {
                        var form = $('.bootbox-body form');
                        form.find('#id-item-friend').val(id);
                        $.ajax({
                            url: form.attr('action'),
                            type: 'POST', 
                            data: form.serializeArray(),
                            success: function(result) {
                                if(result.status == 1) {
                                    bootbox.hideAll();
                                    location.href = location.href;
                                } else {
                                    form.find('#message-notification-dialog').removeClass('hide').addClass('show').find('.panel-body').text(result.message);
                                    return false;
                                }
                            }
                        })
                        // $('.bootbox-body form').submit();
                        return false;
                    }
                }
            }
        });
    });

	 $(".typeahead").typeahead({
    onSelect: function(item) {
        console.log(item);
        location.href = '/profile/' + item.value
    },
    ajax: {
        url: '/find-friends',
        timeout: 500,
        displayField: "name",
        triggerLength: 1,
        method: "get",
        loadingClass: "loading-circle",
        preDispatch: function (query) {
            // showLoadingMask(true);
            return {
                query: query
            }
        },
        preProcess: function (data) {
        	console.log(data);
            // showLoadingMask(false);
            if (data.success === false) {
                // Hide the list, there was some error
                return false;
            }
            // We good!
            return data;
        }
    }
});
     $('body').on('click', '.add-friend', function(e){
        e.preventDefault();
        var object = $(this);
        var url = object.attr('data-url');
        var id = object.attr('data-id');
        var removeId = object.attr('data-remove-id');
        if (typeof url !== 'undefined' && typeof id !== 'undefined') {
            $.ajax({
                type: "POST",
                url: url,
                data: {id: id},
                success: function(result) {
                    if(result.status == 1) {
                        object.addClass('hide');
                        $(removeId).removeClass('hide').addClass('show');
                        showNotification('a','Info', 'success', result.message);
                    }
                }
            })
        }
     });

     $('body').on('click', '.add-favorite', function(e){
        e.preventDefault();
        var object = $(this);
        var url = object.attr('data-url');
        var id = object.attr('data-id');
        var removeItem = object.attr('data-remove-item');
        if (typeof url !== 'undefined' && typeof id !== 'undefined') {
            $.ajax({
                type: "POST",
                url: url,
                data: {id: id},
                success: function(result) {
                    if(result.status == 1) {
                        if (typeof removeItem != 'undefined') {
                            object.remove();
                        }
                        showNotification('a','Info', 'success', result.message);
                    }
                }
            })
        }
     });

     $('body').on('click', '.remove-friend', function(e){
        e.preventDefault();
        var object = $(this);
        var url = object.attr('data-url');
        var id = object.attr('data-id');
        if (typeof url !== 'undefined' && typeof id !== 'undefined') {
            $.ajax({
                type: "POST",
                url: url,
                data: {id: id},
                success: function(result) {
                    console.log(result);
                }
            })
        }
     });

     $('body').on('click', '.invite-friend', function(e){
        e.preventDefault();
        var object = $(this);
        var url = object.attr('data-url');
        var id = object.attr('data-id');
        if (typeof url !== 'undefined' && typeof id !== 'undefined') {
            $.ajax({
                type: "POST",
                url: url,
                data: {id: id},
                success: function(result) {
                    console.log(result);
                }
            })
        }
     });


});

function showNotification(object, title, type, message) {
    if (typeof object == 'undefined') {
        object = '#message-notification';
    }

    if (typeof title == 'undefined') {
        title = 'Information';
    }

    if (typeof type == 'undefined') {
        type = 'success';
    }

    if (typeof message == 'undefined') {
        message = 'Message';
    }

    $.notify({
        title: title,
        message: message},{
        type: type,
        animate: {
            enter: 'animated fadeInDown',
            exit: 'animated fadeOutUp'
        },
        placement: {
            from: "top",
            align: "right"
        },
        template: '<div data-notify="container" class="col-xs-11 col-sm-3 alert alert-{0}" role="alert">' +
        '<button type="button" aria-hidden="true" class="close" data-notify="dismiss">×</button>' +
        '<span data-notify="icon"></span> ' +
        '<span data-notify="title">{1}</span> ' +
        '<span data-notify="message">{2}</span>' +
        '<div class="progress" data-notify="progressbar">' +
            '<div class="progress-bar progress-bar-{0}" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>' +
        '</div>' +
        '<a href="{3}" target="{4}" data-notify="url"></a>' +
    '</div>' 
    });
    // var messageNotification = $('#message-notification');
    // if (messageNotification.length) {
        
    // }
}