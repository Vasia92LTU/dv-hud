--[[ 
*******   ********       **      **           **     **       ********** **     **
/**////** /**/////       /**     /**          ****   /**      /////**/// /**    /**
/**    /**/**            /**     /**         **//**  /**          /**    /**    /**
/**    /**/*******  *****//**    **  *****  **  //** /**          /**    /**    /**
/**    /**/**////  /////  //**  **  /////  **********/**          /**    /**    /**
/**    ** /**              //****         /**//////**/**          /**    /**    /**
/*******  /********         //**          /**     /**/********    /**    //******* 
///////   ////////           //           //      // ////////     //      ///////   
]]
fx_version 'cerulean'
game 'gta5'

author 'De-V-aLtu'
description 'DV-HUD'
version '1.0'

lua54 'yes'

shared_scripts {
    "speedoconfig.lua" , 
}

client_scripts {
    'Client/*.lua',
}

ui_page {
    'html/index.html',
}

files {
    'html/*.png',
    'html/*.html',
    "html/css/*.css",
    'html/fonts/*.ttf',
    'html/js/*.js',


}
