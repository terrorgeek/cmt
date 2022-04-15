$(document).ready(function () { 
  $("#form-npi").validate({
    rules: {
      npi: {required: true, digits: true, minlength: 10, maxlength: 11}
    },
    messages: {
      npi: {required: 'Please input NPI', digits: 'NPI should be 10 or 11 digits'}
    },
    errorPlacement: function(error, element) {
      error.insertBefore(element);
    }
  });
})