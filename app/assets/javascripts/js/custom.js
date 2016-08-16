$(document).ready(function(){
  var authenticity_token = $('#authenticity_token').attr('value');
  $.ajaxSetup({
    data: {
      authenticity_token: authenticity_token,
    }
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