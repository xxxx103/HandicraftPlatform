$(function () {
    $("#username").focus();
    
    // 清除表单
    $("#loginForm")[0].reset();
    
    // 防止浏览器自动填充
    setTimeout(function() {
        $("#real_password").val("");
    }, 100);
})

function checkAll() {
    var i = 0;
    $(".must_input").each(function () {
        if($(this).val().trim() == ""){
            $(this).focus()
            i++;
            return false
        }
    })
    if(i != 0){
        return false;
    }
    
    // 显示加载状态
    $(".submit").prop('disabled', true);
    $(".submit").val('登录中...');
    
    // 获取表单数据
    var formData = {
        email: $("#username").val(),
        password: $("#real_password").val(),
        code: $("#changeCode").val()
    };
    
    // 提交表单
    $.ajax({
        url: "/user/login",
        type: "POST",
        data: formData,
        success: function(result) {
            if(result.status != "200") {
                $('#captchaImage').click();
                $(result.error_pos).text(result.msg);
                // 恢复按钮状态
                $(".submit").prop('disabled', false);
                $(".submit").val('登 录');
                // 如果是密码错误，清空密码字段
                if (result.error_pos === "#email_msg") {
                    $("#real_password").val('');
                }
            } else {
                // 登录成功，跳转到首页
                window.location.href = "/";
            }
        },
        error: function() {
            alert('登录请求失败，请稍后重试');
            $(".submit").prop('disabled', false);
            $(".submit").val('登 录');
        }
    });
    
    return false; // 阻止表单默认提交
}

function clear_code_msg() {
    $('#code_msg').text('')
}

function clear_email_msg() {
    $("#email_msg").text('')
}