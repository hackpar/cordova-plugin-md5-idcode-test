module.exports = {
    //type, user_id, dev_id, num
    idCode : function(param1, param2, param3, param4, param5, param6) {
        var type = param1;
        var user_id;
        var dev_id;
        var num;
        var flag = 0;
        
        if (typeof(param2) !== "function") {
            user_id = param2;
            dev_id = param3;
            num = param4;
        }
        else {
            flag = 1;
        }
        
        cordova.exec(successHandler,
                     errorHandler,
                     "generateIDCode",
                     "idCode",
                     [type, user_id, dev_id, num]);
        function successHandler(result) {
            if (flag) {
                param2(result);
            }
            else {
                param5(result);
            }
        }
        
        function errorHandler(result) {
            if (flag) {
                param3(result);
            }
            else {
                param6(result);
            }
        }
    },
    
    shortCode : function(type, successHandler, errorHandler) {
        cordova.exec(successHandler,
                     errorHandler,
                     "generateIDCode",
                     "shortCode",
                     [type]);
    },
        
    devID : function(successHandler, errorHandler) {
        cordova.exec(successHandler,
                     errorHandler,
                     "generateIDCode",
                     "devID",
                     []);
    },
    
    md5 : function(successHandler, errorHandler) {
        cordova.exec(successHandler,
                     errorHandler,
                     "generateIDCode",
                     "md5",
                     []);
    }
};