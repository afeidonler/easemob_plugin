var cordova = require('cordova'),
channel = require('cordova/channel');
var Easemob =function(){};

/**
 * 初始化
 * @return {[type]}         [description]
 */
Easemob.prototype.init = function() {
    cordova.exec(null,null,'Easemob','init',[]);
};
/**
 * 设置
 * @param  {Function} success 成功回调函数：成功信息
 * @param  {Function} error   失败回调函数：失败信息
 * @param  {[type]} params  [{
 *                            NotifyBySoundAndVibrate：// 设置是否启用新消息提醒(打开或者关闭消息声音和震动提示),boolean
 *                            NoticeBySound:// 设置是否启用新消息声音提醒,boolean
 *                            NoticedByVibrate:// 设置是否启用新消息震动提醒,boolean
 *                            UseSpeaker:// 设置语音消息播放是否设置为扬声器播放,boolean
 *                            ShowNotificationInBackgroud:// 设置后台接收新消息时是否通通知栏提示,boolean
 *                          }
 *                          ]
 * @return {[type]}         [description]
 */
Easemob.prototype.setting = function(success, error, params) {
    cordova.exec(success,error,'Easemob','setting',params);
};
/**
 * 登录（绑定监听事件）
 * @param  {Function} success 成功回调函数：成功信息
 * @param  {Function} error   失败回调函数：失败信息
 * @param  {Array} params     [user,password]
 * @return {[type]}         [description]
 */
Easemob.prototype.login = function(success,error,params) {
    cordova.exec(success,error,'Easemob','login',params);
};
/**
 * 登出（取消绑定监听事件）
 * @param  {Function} success 成功回调函数：成功信息
 * @param  {Function} error   失败回调函数：失败信息
 * @return {[type]}         [description]
 */
Easemob.prototype.logout = function(success,error) {
    cordova.exec(success,error,'Easemob','logout',[]);
};
/**
 * 发聊天
 * @param  {Function} success 成功回调函数：聊天信息
 * @param  {Function} error   失败回调函数:聊天信息
 * @param  {Array} params     [{chatType,target,contentType,content,extend}]
 *                              chatType:消息类型，single(默认),group
                                target:目标用户的用户名或群的id
                                contentType:消息内容的类型：TXT，VOICE，IMAGE（LOCATION，FILE。。未实现）
                                content 消息内容
                                    TXT：{text:"内容"}，
                                    VOICE：{filePath:"xxx.amr",len:3}，len为语音的秒数，filePath为文件路径
                                    IMAGE：{filePath:"xxx.jpg"}，filePath为文件路径
                                extend:扩展属性{key:value}支持int,boolean,String这三种属性
                                resend:是否重发
                                msgId:消息ID,在消息重发时使用
 * @return {[type]}         [description]
 */
Easemob.prototype.chat = function(success,error,params) {
    cordova.exec(success,error,'Easemob','chat',params);
};
/**
 * 开始录音
 * @param  {Array} params  [target]目标用户的用户名或群的id
 * @return {[type]}         [description]
 */
Easemob.prototype.recordStart = function(params) {
    cordova.exec(null,null,'Easemob','recordstart',params);
};
/**
 * 停止录音并发送消息
 * @param  {Function} success 成功回调函数:消息内容
 * @param  {Function} error   失败回调函数:错误信息
 * @param  {Array} params  [chatType, target]
 *                             chatType:消息类型，single(默认),group
                               target:目标用户的用户名或群的id
 * @return {[type]}         [description]
 */
Easemob.prototype.recordEnd = function(success,error,params) {
    cordova.exec(success,error,'Easemob','recordend',params);
};
/**
 * 取消录音
 * @param  {Function} success 成功回调函数：聊天信息
 * @param  {Function} error   失败回调函数：聊天信息
 * @return {[type]}         [description]
 */
Easemob.prototype.recordCancel = function(success,error) {
    cordova.exec(success,error,'Easemob','recordcancel',params);
};
/**
 * 获取聊天记录
 * @param  {Function} success 成功回调函数：聊天记录数组
 * @param  {Function} error   失败回调函数：错误信息
 * @param  {Array} params  [chatType，target,[startMsgId]]
 *                             chatType:消息类型，single(默认),group
                               target:目标用户的用户名或群的id
                               startMsgId:可选，如果存在则为获取比该消息更早的20条记录，否则为获取最新的20条记录
 * @return {[type]}         [description]
 */
Easemob.prototype.getMessages = function(success,error,params) {
    cordova.exec(success,error,'Easemob','getMessages',params);
};
/**
 * 清零未读消息数
 * @param  {Function} success 成功回调函数
 * @param  {Function} error   失败回调函数（一般不会出现）
 * @param  {Array} params  [chatType, target]
 *                             chatType:消息类型，single(默认),group
                               target:目标用户的用户名或群的id，不存在则清零所有回话的未读消息
 * @return {[type]}         [description]
 */
Easemob.prototype.resetUnreadMsgCount = function(success,error,params) {
    cordova.exec(success,error,'Easemob','resetUnreadMsgCount',params);
};
/**
 * 清空会话聊天记录
 * @param  {Function} success 成功回调函数
 * @param  {Function} error   失败回调函数
 * @param  {Array} params  [chatType, target]
 *                             chatType:消息类型，single(默认),group
                               target:目标用户的用户名或群的id
 * @return {[type]}         [description]
 */
Easemob.prototype.clearConversations = function(success,error,params) {
    cordova.exec(success,error,'Easemob','clearConversation',params);
};
/**
 * 删除聊天记录及会话对象
 * @param  {Function} success 成功回调函数
 * @param  {Function} error   失败回调函数
 * @param  {Array} params  [chatType, target]
 *                             chatType:消息类型，single(默认),group
                               target:目标用户的用户名或群的id
 * @return {[type]}         [description]
 */
Easemob.prototype.deleteConversation = function(success,error,params) {
    cordova.exec(success,error,'Easemob','deleteConversation',params);
};
/**
 * 删除会话中的某条聊天记录
 * @param  {Function} success 成功回调函数
 * @param  {Function} error   失败回调函数
 * @param  {Array} params  [chatType, target,msgId]
 *                             chatType:消息类型，single(默认),group
                               target:目标用户的用户名或群的id
                               msgId:该消息的id
 * @return {[type]}         [description]
 */
Easemob.prototype.deleteMessage = function(success,error,params) {
    cordova.exec(success,error,'Easemob','deleteMessage',params);
};
//删除所有会话记录（比较恐怖，还是不加了吧）
// Easemob.prototype.deleteAllConversation = function(success,error,params) {
//     cordova.exec(success,error,'Easemob','deleteAllConversation',params);
// };
/**
 * 获取会话列表
 * @param  {Function} success 成功回调函数：群聊信息
 * @param  {Function} error   失败回调函数：错误信息
 * @return {[type]}         [description]
 */
Easemob.prototype.getAllConversations = function(success,error) {
    cordova.exec(success,error,'Easemob','getAllConversations',[]);
};
/**
 * 获取群聊列表
 * @param  {Function} success 成功回调函数：群聊列表
 * @param  {Function} error   失败回调函数：错误信息
 * @param  {[type]} params  [serverFlag]是否从服务器上获取
 * @return {[type]}         [description]
 */
Easemob.prototype.getGroups = function(success,error,params) {
    cordova.exec(success,error,'Easemob','getGroups',params);
};
/**
 * 获取群聊信息
 * @param  {Function} success 成功回调函数：群聊信息
 * @param  {Function} error   失败回调函数：错误信息
 * @param  {[type]} params  [groupId,serverFlag]群聊id,是否从服务器上获取
 * @return {[type]}         [description]
 */
Easemob.prototype.getGroup = function(success,error,params) {
    cordova.exec(success,error,'Easemob','getGroup',params);
};
/**
 * 获取好友列表
 * @param  {Function} success 成功回调函数：好友列表（只要名称）
 * @param  {Function} error   失败回调函数：错误信息
 * @return {[type]}         [description]
 */
Easemob.prototype.getContacts = function(success, error) {
    cordova.exec(success,error,'Easemob','getContacts',[]);
};
/**
 * 添加好友
 * @param  {Function} success 成功回调函数：成功信息
 * @param  {Function} error   失败回调函数：失败信息
 * @param  {[type]} params  [toUsername,reason]添加的用户名，原因
 * @return {[type]}         [description]
 */
Easemob.prototype.addContact = function(success,error,params) {
    cordova.exec(success,error,'Easemob','addContact',params);
};
/**
 * 删除好友
 * @param  {Function} success 成功回调函数：成功信息
 * @param  {Function} error   失败回调函数：失败信息
 * @param  {[type]} params  [username]删除的用户名
 * @return {[type]}         [description]
 */
Easemob.prototype.deleteContact = function(success,error,params) {
    cordova.exec(success,error,'Easemob','deleteContact',params);
};
/**
 * 接收消息处理函数
 * @param  {Object} chat 收到的chat,一条
 * @return {[type]}      [description]
 */
Easemob.prototype.onReciveMessage = function (chat) {
}
/**
 * 接收离线消息处理函数
 * @param  {Array} chats 收到的chats,一条或者多条
 * @return {[type]}      [description]
 */
Easemob.prototype.onReciveOfflineMessages = function (chats) {
}
/**
 * 点击消息提示框函数
 * @param  {Object/Array} chat 收到的chat,一条或者多条
 * @return {[type]}      [description]
 */
Easemob.prototype.onClickNotification = function (chat) {
}
/**
 * 录音时的函数
 * @param  {object} msg   {what:音量大小}
 * @return {[type]}      [description]
 */
Easemob.prototype.onRecord = function (msg) {
}
/**
 * 断开连接的函数
 * @param  {String} error 错误信息：user_removed,connecttion_conflict,server_disconnect,no_network
 * @return {[type]}      [description]
 */
Easemob.prototype.onDisconneted = function (error) {
}
var easemob = new Easemob();
channel.onCordovaReady.subscribe( function () {
    // The cordova device plugin is ready now
    channel.onCordovaInfoReady.subscribe( function () {
        if (device.platform == 'Android') {
            channel.onPause.subscribe( function () {
                // Necessary to set the state to `background`
                cordova.exec(null, null, 'Easemob', 'pause', []);
            });

            channel.onResume.subscribe( function () {
                // Necessary to set the state to `foreground`
                cordova.exec(null, null, 'Easemob', 'resume', []);
            });

            // Necessary to set the state to `foreground`
            cordova.exec(null, null, 'Easemob', 'resume', []);
        }
    });
});

module.exports = easemob;