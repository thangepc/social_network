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
        var status = $(this).attr('data-status');
        var url = $(this).attr('data-url');
        if (typeof status != 'undefined' && typeof url != 'undefined') {
            $.ajax({
                url: url,
                type: 'POST',
                data: {status: status},
                success: function(result){
                    console.log(result);
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

     $('body').on('click', '.add-favorite', function(e){
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