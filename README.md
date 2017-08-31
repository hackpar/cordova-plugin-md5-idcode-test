##cordova-plugin-md5-idcode

**Cordova / PhoneGap ID产生插件**：根据时间、用户ID、设备ID、序列号等信息产生ID信息

## 安装

#### 从Github安装最新版本

```
cordova plugin add https://github.com/bl905060/cordova-plugin-md5-idcode
```

## 使用

### 产生ID信息

```js
//传入类型、用户ID、设备ID、4位数序列号
generateIDCode.idCode("TP", "user001", "dev001", 1, successCallBack, errorCallBack);

//只传入类型，用户ID、设备ID将自动读取本地profile文件，4位序列号由sqlite数据库保存
generateIDCode.idCode("TP", successCallBack, errorCallBack);

function successCallBack(result) {
    alert(result);
}

function errorCallBack() {
//do something
}
```

### 产生短ID信息

```js
\\传入类型、3位数序列号
generateIDCode.shortCode("TP", 1, successCallBack, errorCallBack);

\\传入类型，3位序列号由sqlite数据库保存
generateIDCode.shortCode("TP", successCallBack, errorCallBack);

function successCallBack(result) {
    alert(result);
}

function errorCallBack() {
//do something
}
```

### 产生MD5信息

```js
//传入需要生成MD5信息的字符串
generateIDCode.md5("test text", successCallBack, errorCallBack);

function successCallBack(result) {
    alert(result);
}

function errorCallback(error) {
    alert(error);
}
```

## 平台支持

iOS (7+) only.