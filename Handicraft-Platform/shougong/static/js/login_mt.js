function checkAll_motai() {
    var i = 0;
    $(".must_input").each(function () {
        if ($(this).val().trim() == "") {
            $(this).focus()
            i++;
            return false
        }
    })
    if (i != 0) {
        return false;
    } else {
        // 显示加载状态
        $("#login").prop('disabled', true);
        $("#login").text('登录中...');
        
        $.ajax({
            url: "/user/login",
            type: "POST",
            data: $('#my_Form_mt').serialize(),
            success: function(result) {
                console.log(result);
                if (result.status != "200") {
                    $('#captchaImage1').click();
                    $(result.error_pos).text(result.msg);
                    // 恢复按钮状态
                    $("#login").prop('disabled', false);
                    $("#login").text('登录');
                } else {
                    // 登录成功，刷新页面
                    window.location.reload();
                }
            },
            error: function() {
                zlalert.alertError('登录请求失败，请稍后重试');
                $("#login").prop('disabled', false);
                $("#login").text('登录');
            }
        });
    }
}

function clear_code_msg() {
    $('#code_msg').text('')
}

function clear_email_msg() {
    $("#email_msg").text('')
}
