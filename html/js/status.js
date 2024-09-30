window.addEventListener("message", function (event) {
    const v = event.data;

    switch (v.action) {
        case "updateStatus":
            $('.status').show(); 
            $('.needs-status').show(); 
            $('.oxygen-stamina-status').show(); 
            $('.vidajs').html(`${v.health}%`);
            $('.vestjs').html(`${v.armor}%`);
            $('.runjs').html(`${Math.round(v.stamina)}%`);
            $('.burgerjs').html(`${Math.round(v.hunger)}%`);
            $('.waterjs').html(`${Math.round(v.thirst)}%`);
            $('.oxyjs').html(`${Math.round(v.oxigen)}%`);
            break;

        case "ShowAllHud": 
            $('.status').show();
            $('.needs-status').show();
            $('.oxygen-stamina-status').show();
            $('#minimap').show(); 
            $('.burgerjs').show();
            $('.waterjs').show();
            $('.oxyjs').show();
            $('.vidajs').show();
            $('.vestjs').show();
            $('.runjs').show();


            break;

        case "hideAllHud": 
            $('.status').hide();
            $('.needs-status').hide();
            $('.oxygen-stamina-status').hide();
            $('#minimap').hide();
            $('.burgerjs').hide();
            $('.waterjs').hide();
            $('.oxyjs').hide();
            $('.vidajs').hide();
            $('.vestjs').hide();
            $('.runjs').hide();


            break;
    }
});
