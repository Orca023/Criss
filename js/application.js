"user strict";


////////////////////////////////////////////////////////////////////////////////

// Title: Node.js server v20161211
// Explain: Node.js file server, Node.js http server, Node.js http client
// Author: 趙健
// E-mail: 283640621@qq.com
// Telephont number: +86 18604537694
// E-mail: chinaorcaz@gmail.com
// Date: 歲在丙申
// Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30
// Interpreter: node-v16.11.0-x64.msi
// Interpreter: node-v16.11.0-linux-x64.tar.xz, node-v16.11.0-linux-x64.deb
// Operating system: google-pixel-2 android-11 termux-0.118 ubuntu-22.04-LTS-rootfs arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280
// Interpreter: node-v16.11.0-linux-arm64.tar.xz, node-v16.11.0-linux-arm64.deb

// 使用説明：
// 控制臺命令列運行指令：
// C:\Criss> C:/Criss/NodeJS/nodejs-16.11.0/node.exe C:/Criss/js/application.js configFile=C:/Criss/js/config.txt interface_Function=file_Monitor webPath=C:/Criss/html/ host=::0 port=10001 Key=username:password number_cluster_Workers=0 is_monitor=false delay=20 number_Worker_threads=0 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt temp_cache_IO_data_dir=C:/Criss/temp/
// root@localhost:~# /usr/bin/node /home/Criss/js/application.js configFile=/home/Criss/js/config.txt interface_Function=file_Monitor webPath=/home/Criss/html/ host=::0 port=10001 Key=username:password number_cluster_Workers=0 is_monitor=false delay=20 number_Worker_threads=0 monitor_dir=/home/Criss/Intermediary/ monitor_file=C:/home/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt temp_cache_IO_data_dir=/home/Criss/temp/

////////////////////////////////////////////////////////////////////////////////


// 1、載入自定義的其它模塊（模塊前需要寫明載入路徑）
const Interface = require('./Interface.js');  // require(require('path').join(require('path').resolve("."), "Interface.js")); require('path').resolve("..").toString().concat("/temp/"); 當加載自定義的模塊時，引用模塊需要包括路徑和模塊名的完整引用，只寫模塊名會報錯;
const Interface_file_Monitor = Interface.file_Monitor;  // 使用「Interface.js」模塊中的成員「file_Monitor(monitor_file, monitor_dir, do_Function_obj, return_obj, monitor, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value, temp_NodeJS_cache_IO_data_dir)」函數, 用於建立讀取硬盤文檔接口;
const Interface_http_Server = Interface.http_Server;  // 使用「Interface.js」模塊中的成員「http_Server(host, port, number_cluster_Workers, Key, Session, do_Function_JSON)」函數, 用於建立網卡http協議監聽服務器接口;
const Interface_http_Client = Interface.http_Client;  // 使用「Interface.js」模塊中的成員「http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_JSON, callback)」函數, 用於建立網卡http協議客戶端請求接口;
const isStringJSON = Interface.isStringJSON;  // 使用「Interface.js」模塊中的成員「isStringJSON(str)」函數, 用於判斷一個字符串是否爲 JSON 格式的字符串;
const Base64 = new Interface.Base64();  // 使用「Interface.js」模塊中的成員「Base64()」函數, 用於對字符串進行Base64()編解碼操作；解碼：str = new Base64().decode(base64)，編碼：base64 = new Base64().encode(str);
// const Base64 = Interface.Base64;  // 使用「Interface.js」模塊中的成員「Base64()」函數, 用於對字符串進行Base64()編解碼操作；解碼：str = new Base64().decode(base64)，編碼：base64 = new Base64().encode(str);
// 解碼：str = new Base64().decode(base64) ，編碼：base64 = new Base64().encode(str);
const deepCopy = Interface.deepCopy;  // 使用「Interface.js」模塊中的成員「deepCopy(obj)」函數, 用於使用遞歸遍歷的方法深拷貝（複製傳值）對象類型變量（例如，數組和JSON對象等類型的數據），實現思路：拷貝的時候判斷屬性值的類型，如果是物件，繼續遞迴呼叫深拷貝函數;
const deleteDirSync = Interface.deleteDirSync;  // 使用「Interface.js」模塊中的成員「deleteDirSync(absolute_path_String)」函數, 用於同步遞歸刪除非空文件夾，首先獲取到該資料夾裡面所有的資訊，遍歷裡面的資訊，判斷是文檔還是資料夾，如果是文檔直接刪除，如果是資料夾，進入資料夾，遞歸重複上述過程;
const CheckString = Interface.CheckString;  // 使用「Interface.js」模塊中的成員「CheckString(letters, fork)」函數, 用於使用正則函數的方法檢查字符串中的字符類型，用於檢驗用戶輸入參數的合規性;
const where = Interface.where;  // 使用「Interface.js」模塊中的成員「where()」函數, 用於使用返回調用時函數的名字;

//console.log(`${OS.platform()},${OS.hostname()},${IP.address()}`); //查看服務器系統信息用於調試;

// // 控制臺傳參檢查埠號（port）是否已經被占用，控制臺傳參，其中「port」為需要檢測的端口號，運行方式示例：node PortIsOccupied 80;
// if (typeof (process.argv[2]) === 'undefined') {
//     console.log('端口參數未輸入，請正確輸入待測試端口號.');
// } else if (!CheckString(process.argv[2], 'arabic_numerals') || Number(process.argv[2]) >= 65535 || Number(process.argv[2]) <= 0) {
//     console.log(`端口參數「${process.argv[2]}」類型輸入錯誤，請正確輸入「1 ~ 65535」的數字端口進行測試.`);
// } else {
//     let port = Number(parseInt(process.argv[2]));
//     //console.log(port);
//     const Server = net.createServer().listen(port);
//     function PortIsOccupied(port) {
//         Server.on('listening', function () {
//             Server.close(); // 關閉服務;
//             console.log(`端口「${port}」可以使用.`);
//         });
//         Server.on('error', function (error) {
//             if (error.code === 'EADDRINUSE') {
//                 // 端口已被占用
//                 console.log(`端口「${port}」已經被占用，請更換端口重試.`);
//             } else {
//                 console.log(JSON.stringify(error));
//             };
//         });
//     };

//     // 執行
//     PortIsOccupied(port);
// };




// 處理從硬盤文檔讀取到的JSON對象數據，然後返回處理之後的結果JSON對象;
function do_data(data_Str) {

    let response_data_String = "";
    let require_data_JSON = {};
    // 使用自定義函數isStringJSON(data_Str)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    if (isStringJSON(data_Str)) {
        require_data_JSON = JSON.parse(data_Str);  // 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
        // str = JSON.stringify(jsonObj);
        // Obj = JSON.parse(jsonStr);
    } else {
        require_data_JSON = {
            "Client_say": data_Str,
        };
    };

    // console.log(require_data_JSON);
    // console.log(typeof(require_data_JSON));
    // console.log(typeof (require_data_JSON) === 'object' && Object.prototype.toString.call(require_data_JSON).toLowerCase() === '[object object]' && !(require_data_JSON.length));

    let Client_say = "";
    // 使用函數 (typeof (require_data_JSON) === 'object' && Object.prototype.toString.call(require_data_JSON).toLowerCase() === '[object object]' && !(require_data_JSON.length)) 判斷傳入的參數 require_data_JSON 是否為 JSON 格式對象;
    if (typeof (require_data_JSON) === 'object' && Object.prototype.toString.call(require_data_JSON).toLowerCase() === '[object object]' && !(require_data_JSON.length)) {
        // 使用 JSON.hasOwnProperty("key") 判断某个"key"是否在JSON中;
        if (require_data_JSON.hasOwnProperty("Client_say")) {
            Client_say = require_data_JSON["Client_say"];
        } else {
            Client_say = "";
            // console.log('客戶端發送的請求 JSON 對象中無法找到目標鍵(key)信息 ["Client_say"].');
            // console.log(require_data_JSON);
        };
    } else {
        Client_say = require_data_JSON;
        // isStringJSON(request_data_JSON);
        // text = JSON.stringify(JsonObject); sonObject = JSON.parse(String);
    };

    let Server_say = Client_say;  // "require no problem.";
    // if (Client_say === "How are you" || Client_say === "How are you." || Client_say === "How are you!" || Client_say === "How are you !") {
    //     Server_say = "Fine, thank you, and you ?";
    // } else {
    //     Server_say = "我現在只會説：「 Fine, thank you, and you ? 」，您就不能按規矩說一個：「 How are you ! 」";
    // };

    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
    // console.log(now_date);
    let response_data_JSON = {
        "Server_say": Server_say,
        "time": String(now_date)
    };
    response_data_String = JSON.stringify(response_data_JSON);
    // isStringJSON(request_data_JSON);
    // text = JSON.stringify(JsonObject); sonObject = JSON.parse(String);

    return response_data_String;
};


// let is_monitor = true;  // Boolean;
// // let is_Monitor_Concurrent = "";  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
// let monitor_dir = String(require('path').join(String(__dirname), "Intermediary"));  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// let monitor_file = String(require('path').join(String(monitor_dir), "intermediary_write_C.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_C.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
// let do_Function = do_data;  // function (argument) { return argument; };  // 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
// let output_dir = String(require('path').join(String(__dirname), "Intermediary"));  // path.normalize(p)。path.join([path1][, path2][, ...])，path.resolve('main.js') 用於輸出傳值的媒介目錄 "../temp/";
// let output_file = String(require('path').join(String(output_dir), "intermediary_write_Nodejs.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_Nodejs.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
// let to_executable = "";  // require('path').join(require('path').resolve(".."), "Python", "python39/python.exe");  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\Python\\Python39\\python.exe";
// let to_script = "";  // require('path').join(require('path').resolve(".."), "js", "test.js");  // 用於對返回數據執行功能的被調用的脚本文檔 "../py/test.py";
// let delay = parseInt(100);  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay)，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
// let number_Worker_threads = parseInt(0);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
// let Worker_threads_Script_path = "";  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
// let Worker_threads_eval_value = null;  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
// let temp_NodeJS_cache_IO_data_dir = require('path').join(require('path').resolve(".."), "Intermediary");  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";

// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     // try {
//                     //     // CheckString(delay, 'positive_integer');  // 自定義函數檢查輸入合規性;
//                     //     // CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
//                     //     if (process.argv[i].split("=")[0] !== "do_Function") {
//                     //         eval(process.argv[i] + ";");
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "do_Function" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                     //     } else {
//                     //         do_Function = null;
//                     //     };
//                     //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     // } catch (error) {
//                     //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     console.log(error);
//                     // };
//                     switch (process.argv[i].split("=")[0]) {
//                         case "monitor_file": {
//                             monitor_file = String(process.argv[i].split("=")[1]);  // 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                             // console.log("monitor file: " + monitor_file);
//                             break;
//                         }
//                         case "monitor_dir": {
//                             monitor_dir = String(process.argv[i].split("=")[1]);  // 用於輸入傳值的媒介目錄 "../temp/";
//                             // console.log("monitor dir: " + monitor_dir);
//                             break;
//                         }
//                         case "do_Function": {
//                             // "function() {};" 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
//                             if (Object.prototype.toString.call(do_Function = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                                 do_Function = eval(process.argv[i].split('=')[1]);
//                             } else {
//                                 do_Function = null;
//                             };
//                             // console.log("do Function: " + do_Function);
//                             break;
//                         }
//                         case "output_dir": {
//                             output_dir = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介目錄 "../temp/";
//                             // console.log("output dir: " + output_dir);
//                             break;
//                         }
//                         case "output_file": {
//                             output_file = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                             // console.log("output file: " + output_file);
//                             break;
//                         }
//                         case "to_executable": {
//                             to_executable = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
//                             // console.log("to executable: " + to_executable);
//                             break;
//                         }
//                         case "to_script": {
//                             to_script = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
//                             // console.log("to script: " + to_script);
//                             break;
//                         }
//                         case "temp_NodeJS_cache_IO_data_dir": {
//                             temp_NodeJS_cache_IO_data_dir = String(process.argv[i].split("=")[1]);  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";
//                             // console.log("temp NodeJS cache Input/Output data dir: " + temp_NodeJS_cache_IO_data_dir);
//                             break;
//                         }
//                         case "delay": {
//                             delay = parseInt(process.argv[i].split("=")[1]);  // delay = 500;  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
//                             // console.log("delay: " + delay);
//                             break;
//                         }
//                         case "is_monitor": {
//                             // is_monitor = Boolean(process.argv[i].split("=")[1]);  // "true", "false"; // 選擇是否啓動監聽服務器，還是只運行一次即結束退出;
//                             is_monitor = eval(String(process.argv[i].split("=")[1]));  // "true", "false"; // 選擇是否啓動監聽服務器，還是只運行一次即結束退出;
//                             // console.log("Is Monitor: " + is_monitor);
//                             // console.log("Is Monitor: " + process.argv[i].split("=")[1]);
//                             break;
//                         }
//                         // case "is_Monitor_Concurrent": {
//                         //     is_Monitor_Concurrent = String(process.argv[i].split("=")[1]);  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
//                         //     // console.log("is_Monitor_Concurrent: " + number_Worker_threads);
//                         //     break;
//                         // }
//                         case "number_Worker_threads": {
//                             CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
//                             number_Worker_threads = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
//                             // console.log("number_Worker_threads: " + number_Worker_threads);
//                             break;
//                         }
//                         case "Worker_threads_Script_path": {
//                             Worker_threads_Script_path = process.argv[i].split("=")[1];  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                             // console.log("Worker threads Script path: " + Worker_threads_Script_path);
//                             break;
//                         }
//                         case "Worker_threads_eval_value": {
//                             Worker_threads_eval_value = Boolean(process.argv[i].split("=")[1]);  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
//                             // console.log("Worker threads eval value: " + Worker_threads_eval_value);
//                             break;
//                         }
//                         default: {
//                             console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                             break;
//                         }
//                     };
//                 };
//             };
//         };
//     };
// };


// // 硬盤文檔監聽函數 file_Monitor() 使用説明;
// // file_Monitor(is_monitor, monitor_file, monitor_dir, do_Function_obj, return_obj, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value, temp_NodeJS_cache_IO_data_dir);
// if (require('worker_threads').isMainThread) {
//     // const child_process = require('child_process');  // Node原生的創建子進程模組;
//     // const os = require('os');  // Node原生的操作系統信息模組;
//     // const net = require('net');  // Node原生的網卡網絡操作模組;
//     // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
//     // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
//     // const qs = require('querystring');
//     // const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
//     // const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
//     // const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
//     // const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
//     // const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
//     // const cluster = require('cluster');  // Node原生的支持多進程模組;
//     // // const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
//     // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
    
//     // // 可以先改變工作目錄到 static 路徑;
//     // console.log('Starting directory: ' + process.cwd());
//     // try {
//     //     process.chdir('D:\\tmp\\');
//     //     console.log('New directory: ' + process.cwd());
//     // } catch (error) {
//     //     console.log('chdir: ' + error);
//     // };

//     // // 同步讀取指定文件夾的内容 fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false });
//     // try {
//     //     console.log(fs.readdirSync(monitor_dir, { encoding: "utf8", withFileTypes: false }));
//     // } catch (error) {
//     //     console.log(error);
//     // };

//     let monitor_dir = require('path').join(require('path').resolve(".."), "Intermediary");  //require('path').resolve("..").toString().concat("/temp/")，"D:\\temp\\" "../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
//     let monitor_file = require('path').join(monitor_dir, "intermediary_write_Python.txt");  // "../temp/intermediary_write_Python.txt" 用於接收傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
//     let do_Function = do_data;  // 用於接收執行功能的函數;
//     let output_dir = require('path').join(require('path').resolve(".."), "Intermediary");  // "D:\\temp\\" "../temp/"，path.resolve("../temp/") 轉換爲絕對路徑;
//     let output_file = require('path').join(output_dir, "intermediary_write_Node.txt");  // "../temp/intermediary_write_Node.txt" 用於輸出傳值的媒介文檔，path.join('C:\\', '/test', 'test1', 'file.txt') 拼接路徑字符串;
//     let to_executable = require('path').join(require('path').resolve(".."), "Python", "python39/python.exe");  // require('path').resolve("..").toString().concat("/Python/", "python39/python.exe")，"../Python/python39/python.exe"，path.resolve("../Python/python39/python.exe") 轉換爲絕對路徑;
//     let to_script = require('path').join(require('path').resolve(".."), "js", "test.js");  // require('path').resolve("..").toString().concat("/js/", "test.js")，"../js/test.js"，path.resolve("../js/test.js") 轉換爲絕對路徑;
//     let do_Function_obj = {
//         "do_Function": do_Function  // 用於接收執行功能的函數;
//     };
//     let return_obj = {
//         "output_dir": output_dir,  // 需要注意目錄操作權限 "./temp/" 用於傳值的媒介目錄;
//         "output_file": output_file,  // "./temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
//         "to_executable": to_executable,  // 用於對返回數據執行功能的解釋器可執行文件;
//         "to_script": to_script  // "./js/test.js" 用於執行功能的被調用的脚步文檔;
//     };
//     let is_monitor = true;  // 用於判斷只運行一次，還是保持文檔監聽;
//     let delay = 50;  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
//     let number_Worker_threads = 1;  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
//     let Worker_threads_Script_path = "";  // process.argv[1]; // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值;
//     let Worker_threads_eval_value = "";  // true; // new Worker(Worker_threads_Script_path, { eval: true }); 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值;
//     let temp_NodeJS_cache_IO_data_dir = require('path').join(require('path').resolve(".."), "Intermediary");  // require('os').tmpdir().concat(require('path').sep, "temp_NodeJS_cache_IO_data", require('path').sep);  // "C:\\Users\\china\\AppData\\Local\\Temp\\temp_NodeJS_cache_IO_data\\" 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾;
//     // let temp_NodeJS_cache_IO_data_dir = fs.mkdtempSync(require('os').tmpdir().concat(require('path').sep), { encoding: 'utf8' });  // 返回值為臨時文件夾路徑字符串，fs.mkdtempSync(path.join(os.tmpdir(), 'node_temp_'), {encoding: 'utf8'}) 同步創建，一個唯一的臨時文件夾;
//     // fs.rmdirSync(temp_NodeJS_cache_IO_data_dir, { maxRetries: 0, recursive: false, retryDelay: 100 });  // 同步刪除目錄 fs.rmdirSync(path[, options]) 返回值 undefined;
//     // console.log(temp_NodeJS_cache_IO_data_dir);

//     let data = Interface_file_Monitor({
//         "is_monitor": is_monitor,
//         "monitor_file": monitor_file,
//         "monitor_dir": monitor_dir,
//         // "do_Function_obj": do_Function_obj,
//         "do_Function": do_Function,
//         // "return_obj": return_obj,
//         "output_dir": output_dir,
//         "output_file": output_file,
//         "to_executable": to_executable,
//         "to_script": to_script,
//         "delay": delay,
//         "number_Worker_threads": number_Worker_threads,
//         "Worker_threads_Script_path": Worker_threads_Script_path,
//         "Worker_threads_eval_value": Worker_threads_eval_value,
//         "temp_NodeJS_cache_IO_data_dir": temp_NodeJS_cache_IO_data_dir
//     });
//     // let data = Interface_file_Monitor({
//     //     "is_monitor": is_monitor,
//     //     "monitor_file": monitor_file,
//     //     "do_Function": do_Function,
//     //     "output_file": output_file,
//     // });
// };



// 自定義具體處理 GET 或 POST 請求的執行函數;
function do_Request_Router(
    request_url,
    request_POST_String,
    request_headers,
    callback
){
// async function do_Request_Router(
//     request_url,
//     request_POST_String,
//     request_headers
// ){

    // Check the file extension required and set the right mime type;
    // try {
    //     fs.readFileSync();
    //     fs.writeFileSync();
    // } catch (error) {
    //     console.log("硬盤文件打開或讀取錯誤.");
    // } finally {
    //     fs.close();
    // };

    let response_body_String = "";
    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
    // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
    let response_data_JSON = {
        "time": String(now_date),
        "request_url": request_url,
        "request_POST": request_POST_String,
        // "request_Authorization": request_headers["authorization"],  // "username:password";
        // "request_Cookie": request_headers["cookie"],  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
        "Server_Authorization": Key,  // "username:password";
        "Database_say": "",
    };
    // console.log(request_headers);
    if (typeof (request_headers) === 'object' && Object.prototype.toString.call(request_headers).toLowerCase() === '[object object]' && !(request_headers.length)) {
        if (request_headers.hasOwnProperty("authorization")) {
            response_data_JSON["request_Authorization"] = Base64.decode(String(request_headers["authorization"]).split(" ")[1]);  // "username:password";
            // console.log(response_data_JSON["request_Authorization"]);
        };
        if (request_headers.hasOwnProperty("cookie")) {
            response_data_JSON["request_Cookie"] = request_headers["cookie"];  // String(request_headers["cookie"]).split("=")[0].concat("=", Base64.decode(String(request_headers["cookie"]).split("=")[1]));  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
            // console.log(response_data_JSON["request_Cookie"]);
        };
    };
    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
    // String = JSON.stringify(JSON); JSON = JSON.parse(String);

    // console.log(request_POST_String);
    let request_POST_JSON = {};
    // // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
    // // if (request_POST_String !== "" && isStringJSON(request_POST_String)) {
    //     try {
    //         if (request_POST_String !== "") {
    //             request_POST_JSON = JSON.parse(request_POST_String, true);
    //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
    //         };
    //     } catch (error) {
    //         console.error(error);
    //         response_data_JSON["Database_say"] = String(error);
    //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
    //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
    //         if (callback) { callback(response_body_String, null); };
    //         return response_body_String;
    //     } finally {};
    //     // console.log(request_POST_JSON);
    // // };

    // console.log(request_url);
    // let request_url_JSON = url.parse(request_url, true);
    const request_url_JSON = new URL(request_url, `http://${request_headers["host"]}`);  // http://127.0.0.1:8000
    // console.log(request_url_JSON);
    const url_search_JSON = new URLSearchParams(request_url_JSON.search);
    // console.log(url_search_JSON);
    const request_url_path = String(request_url_JSON.pathname);
    // console.log(request_url_path);
    // console.log(webPath);
    let web_path = String(path.join(webPath, request_url_path));
    // console.log(web_path);

    // // try {
    // //     // 異步寫入硬盤文檔;
    // //     fs.writeFile(
    // //         web_path,
    // //         data,
    // //         function (error) {
    // //             if (error) { return console.error(error); };
    // //         }
    // //     );
    // //     // 同步讀取硬盤文檔;
    // //     // fs.writeFileSync(web_path, data);
    // // } catch (error) {
    // //     console.log("硬盤文檔打開或寫入錯誤.");
    // // } finally {
    // //     fs.close();
    // // };

    let file_data = null;
    // try {
    //     // // 異步讀取硬盤文檔;
    //     // fs.readFile(
    //     //     web_path,
    //     //     function (error, data) {
    //     //         if (error) {
    //     //             console.error(error);
    //     //             response_body_String = String(error);
    //     //             if (callback) { callback(response_body_String, null); };
    //     //         };
    //     //         if (data) {
    //     //             // console.log("異步讀取文檔: " + data.toString());
    //     //             file_data = data;
    //     //             response_body_String = file_data.toString();
    //     //             // console.log(response_body_String);
    //     //             if (callback) { callback(null, response_body_String); };
    //     //         };
    //     //     }
    //     // );
    //     // 同步讀取硬盤文檔;
    //     file_data = fs.readFileSync(web_path);
    //     // console.log("同步讀取文檔: " + file_data.toString());
    //     response_body_String = file_data.toString();
    //     // console.log(response_body_String);
    //     if (callback) { callback(null, response_body_String); };
    //     return response_body_String;
    // } catch (error) {
    //     console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
    //     response_body_String = String(error);
    //     if (callback) { callback(response_body_String, null); };
    //     return response_body_String;
    // } finally {
    //     // fs.close();
    // };

    let fileName = "";
    if (url_search_JSON.has("fileName")) {
        fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待替換的文件路徑全名;
    };

    if (url_search_JSON.has("Key")) {
        Key = String(url_search_JSON.get("Key"));  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
    };
    if (url_search_JSON.has("dbUser")) {
        dbUser = String(url_search_JSON.get("dbUser"));  // 'admin_test20220703'; // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
    };
    if (url_search_JSON.has("dbPass")) {
        dbPass = String(url_search_JSON.get("dbPass"));  // 'admin'; // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
    };
    // UserPass = dbUser.concat(":", dbPass);  // 'admin_test20220703:admin';  // ['root:root', 'administrator:administrator', 'admin_test20220703:admin', 'user_test20220703:user'];  // 鏈接 MongoDB 數據庫的驗證賬號密碼;
    if (url_search_JSON.has("dbName")) {
        dbName = String(url_search_JSON.get("dbName"));  // 'testWebData'; // ['admin', 'testWebData'];  // 定義數據庫名字變量用於儲存數據庫名，將數據庫名設為形參，這樣便於日後修改數據庫名，Mongodb 要求數據庫名稱首字母必須為大寫單數;
    };
    if (url_search_JSON.has("dbTableName")) {
        dbTableName = String(url_search_JSON.get("dbTableName"));  // 'test20220703'; // ['test20220703'];  // MongoDB 數據庫包含的數據集合（表格）;
    };

    switch (request_url_path) {

        case "/": {

            web_path = String(path.join(webPath, "/index.html"));
            file_data = null;

            Select_Statistical_Algorithms_HTML_path = String(path.join(webPath, "/SelectStatisticalAlgorithms.html"));  // 拼接本地當前目錄下的請求文檔名;
            Select_Statistical_Algorithms_HTML = ""  // '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>';
            Input_HTML_path = String(path.join(webPath, "/InputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
            Input_HTML = ""  // '<table id="LC5PFitInputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitInputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表頭名稱</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表頭名稱</th></tr></thead><tfoot id="LC5PFitInputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表足名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表足名稱</td></tr></tfoot><tbody id="LC5PFitInputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Input-1名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-2名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-3名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Input-4名稱</td></tr></tbody></table>';
            Output_HTML_path = String(path.join(webPath, "/OutputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
            Output_HTML = ""  // '<table id="LC5PFitOutputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitOutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表頭名稱</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表頭名稱</th></tr></thead><tfoot id="LC5PFitOutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表足名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表足名稱</td></tr></tfoot><tbody id="LC5PFitOutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Output-1名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-2名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-3名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Output-4名稱</td></tr></tbody></table><canvas id="LC5PFitOutputCanvas" width="300" height="150" style="display: block;"></canvas>';

            try {

                // 異步讀取硬盤文檔;
                fs.readFile(
                    web_path,
                    function (error, data) {

                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };

                        if (data) {
                            // console.log("異步讀取文檔: " + "\\n" + data.toString());
                            file_data = data;  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            response_body_String = file_data.toString();
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Select_Statistical_Algorithms_HTML = fs.readFileSync(Select_Statistical_Algorithms_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Select_Statistical_Algorithms_HTML = Select_Statistical_Algorithms_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Select_Statistical_Algorithms_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML);
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Input_HTML = fs.readFileSync(Input_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Input_HTML = Input_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Input_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Input_HTML -->", Input_HTML);
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Output_HTML = fs.readFileSync(Output_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Output_HTML = Output_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Output_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Output_HTML -->", Output_HTML);
                            // console.log(response_body_String);

                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } catch (error) {
                console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                console.error(error);
                response_data_JSON["Database_say"] = String(error);
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            } finally {
                // fs.close();
            };

            return response_body_String;
        }

        case "/index.html": {

            // web_path = String(path.join(webPath, "/index.html"));
            file_data = null;

            Select_Statistical_Algorithms_HTML_path = String(path.join(webPath, "/SelectStatisticalAlgorithms.html"));  // 拼接本地當前目錄下的請求文檔名;
            Select_Statistical_Algorithms_HTML = ""  // '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>';
            Input_HTML_path = String(path.join(webPath, "/InputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
            Input_HTML = ""  // '<table id="LC5PFitInputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitInputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表頭名稱</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表頭名稱</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表頭名稱</th></tr></thead><tfoot id="LC5PFitInputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Input-1表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-2表足名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Input-3表足名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Input-4表足名稱</td></tr></tfoot><tbody id="LC5PFitInputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Input-1名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-2名稱</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Input-3名稱</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Input-4名稱</td></tr></tbody></table>';
            Output_HTML_path = String(path.join(webPath, "/OutputHTML.html"));  // 拼接本地當前目錄下的請求文檔名;
            Output_HTML = ""  // '<table id="LC5PFitOutputTable" style="border-collapse:collapse; display: block;"><thead id="LC5PFitOutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表頭名稱</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表頭名稱</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表頭名稱</th></tr></thead><tfoot id="LC5PFitOutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">輸入Output-1表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-2表足名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Output-3表足名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Output-4表足名稱</td></tr></tfoot><tbody id="LC5PFitOutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">輸入Output-1名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-2名稱</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 0px solid black; border-right: 1px solid black; border-bottom: 0px solid black;">Output-3名稱</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 0px solid black; border-right: 0px solid black; border-bottom: 0px solid black;">Output-4名稱</td></tr></tbody></table><canvas id="LC5PFitOutputCanvas" width="300" height="150" style="display: block;"></canvas>';

            try {

                // 異步讀取硬盤文檔;
                fs.readFile(
                    web_path,
                    function (error, data) {

                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };

                        if (data) {
                            // console.log("異步讀取文檔: " + "\\n" + data.toString());
                            file_data = data;  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            response_body_String = file_data.toString();
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Select_Statistical_Algorithms_HTML = fs.readFileSync(Select_Statistical_Algorithms_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Select_Statistical_Algorithms_HTML = Select_Statistical_Algorithms_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Select_Statistical_Algorithms_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML);
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Input_HTML = fs.readFileSync(Input_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Input_HTML = Input_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Input_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Input_HTML -->", Input_HTML);
                            // console.log(response_body_String);

                            // 同步讀取硬盤文檔;
                            Output_HTML = fs.readFileSync(Output_HTML_path);  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            Output_HTML = Output_HTML.toString();
                            // console.log("同步讀取文檔: " + "\\n" + Output_HTML.toString());
                            response_body_String = response_body_String.replace("<!-- Output_HTML -->", Output_HTML);
                            // console.log(response_body_String);

                            if (callback) { callback(null, response_body_String); };
                            // return response_body_String;
                        };
                    }
                );

            } catch (error) {
                console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                console.error(error);
                response_data_JSON["Database_say"] = String(error);
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            } finally {
                // fs.close();
            };

            return response_body_String;
        }

        case "/administrator.html": {

            // web_path = String(path.join(webPath, "/administrator.html"));
            file_data = null;

            try {

                // // 同步讀取硬盤文檔;
                // file_data = fs.readFileSync(web_path);
                // // console.log("同步讀取文檔: " + file_data.toString());
                // let filesName = fs.readdirSync(webPath);
                // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
                // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                // filesName.forEach(
                //     function (item) {
                //         // console.log("異步讀取文件夾目錄: " + item.toString());
                //         let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
                //         if (statsObj.isFile()) {
                //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
                //         } else if (statsObj.isDirectory()) {
                //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
                //         } else {};
                //     }
                // );
                // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
                // // console.log(response_body_String);
                // // return response_body_String;

                // 異步讀取硬盤文檔;
                fs.readFile(
                    web_path,
                    function (error, data) {

                        if (error) {
                            console.error(error);
                            response_data_JSON["Database_say"] = String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };

                        if (data) {
                            file_data = data;  // 返回值爲：二進制字節碼（Byte）緩衝區（Buffer）類型，可以通過 .toString() 方法轉換爲字符串;
                            // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                            fs.readdir(
                                webPath,
                                function (error, filesName) {

                                    if (error) {
                                        console.error(error);
                                        response_data_JSON["Database_say"] = String(error);
                                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                        if (callback) { callback(response_body_String, null); };
                                        // return response_body_String;
                                    };

                                    if (filesName) {
                                        let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>';
                                        // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                                        filesName.forEach(
                                            function (item) {
                                                // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve("/", item.toString())), search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve("/", item.toString())), search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve("/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
                                                let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
                                                // console.log("異步讀取文件夾目錄: " + item.toString());
                                                let statsObj = fs.statSync(String(path.join(webPath, item)), {bigint: false});
                                                if (statsObj.isFile()) {
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
                                                    directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                } else if (statsObj.isDirectory()) {
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
                                                    directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                    // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                } else {};
                                            }
                                        );
                                        response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
                                        // console.log(response_body_String);
                                        if (callback) { callback(null, response_body_String); };
                                        // return response_body_String;
                                    };
                                }
                            );
                        };
                    }
                );

            } catch (error) {
                console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                console.error(error);
                response_data_JSON["Database_say"] = String(error);
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            } finally {
                // fs.close();
            };

            return response_body_String;
        }

        case "/uploadFile": {

            // fileName = "";
            // if (url_search_JSON.has("fileName")) {
            //     fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待替換的文件路徑全名;
            // };
            if (fileName === "" || fileName === null) {
                console.log("上傳參數錯誤，目標替換文檔名稱字符串 file = { " + String(fileName) + " } 爲空.");
                response_data_JSON["Database_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file = { " + String(fileName) + " } 爲空.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                return response_body_String;
            };

            web_path = String(path.join(webPath, fileName));
            file_data = request_POST_String;

            let file_data_Uint8Array_String = JSON.parse(file_data);  // JSON.stringify(file_data_Uint8Array);
            let file_data_Uint8Array = new Array();
            for (let i = 0; i < file_data_Uint8Array_String.length; i++) {
                if (Object.prototype.toString.call(file_data_Uint8Array_String[i]).toLowerCase() === '[object string]') {
                    // file_data_Uint8Array.push(parseInt(file_data_Uint8Array_String[i], 2));  // 函數 parseInt("11100101", 2) 表示將二進制數字的字符串轉爲十進制的數字，例如 parseInt("11100101", 2) === 二進制的：11100101 也可以表示爲（0b11100101）=== 十進制的：229;
                    file_data_Uint8Array.push(parseInt(file_data_Uint8Array_String[i], 10));  // 函數 parseInt("229", 10) 表示將十進制數字的字符串轉爲十進制的數字，例如 parseInt("229", 10) === 十進制的：229 === 二進制的：11100101 也可以表示爲（0b11100101）;
                } else {
                    file_data_Uint8Array.push(file_data_Uint8Array_String[i]);
                };
            };
            // let file_data_bytes = new Uint8Array(Buffer.from(file_data_String));  // 轉換為 Buffer 二進制對象;
            let file_data_bytes = Buffer.from(new Uint8Array(file_data_Uint8Array));  // 轉換為 Buffer 二進制對象;
            // let file_data_Buffer = Buffer.allocUnsafe(file_data_Uint8Array.length);  // 字符串轉Buffer數組，注意，如果是漢字符數組，則每個字符占用兩個字節，即 .length * 2;
            // let file_data_bytes = new Uint8Array(file_data_Buffer);  // 轉換為 Buffer 二進制對象;
            // for (let i = 0; i < file_data_Uint8Array.length; i++) {
            //     file_data_bytes[i] = file_data_Uint8Array[i];
            // };
            // bytes = file_data.split("")[0].charCodeAt().toString(2);  // 字符串中的第一個字符轉十進制Unicode碼後轉二進制編碼;
            // bytes = file_data.split("")[0].charCodeAt();  // 字符串中的第一個字符轉十進制Unicode碼;
            // char = String.fromCharCode(bytes);  // 將十進制的Unicode碼轉換爲字符;
            // buffer = new ArrayBuffer(str.length * 2);  // 字符串轉Buffer數組，每個字符占用兩個字節;
            // bufView = new Uint16Array(buffer);  // 使用UTF-16編碼;
            // str = String.fromCharCode.apply(null, new Uint16Array(buffer));  // Buffer數組轉字符串;
            let file_data_len = file_data_Uint8Array.length;
            // let file_data_len = Buffer.byteLength(file_data);

            // let statsObj = fs.statSync(web_path, {bigint: false});
            // if (statsObj.isFile()) {} else if (statsObj.isDirectory()) {} else {};
            if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {
                // console.log("文檔路徑全名: " + web_path);
                // console.log("文檔大小: " + String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB"));
                // console.log("文檔修改日期: " + statsObj.mtime.toLocaleString());
                // console.log("文檔操作權限值: " + String(statsObj.mode));

                // 同步判斷指定的目標文檔權限，當指定的目標文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                try {
                    // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                    // console.log("文檔: " + web_path + " 可以讀寫.");
                } catch (error) {
                    // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                    try {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                        fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                        // console.log("文檔: " + web_path + " 操作權限修改為可以讀寫.");
                        // 常量                    八進制值    說明
                        // fs.constants.S_IRUSR    0o400      所有者可讀
                        // fs.constants.S_IWUSR    0o200      所有者可寫
                        // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                        // fs.constants.S_IRGRP    0o40       群組可讀
                        // fs.constants.S_IWGRP    0o20       群組可寫
                        // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                        // fs.constants.S_IROTH    0o4        其他人可讀
                        // fs.constants.S_IWOTH    0o2        其他人可寫
                        // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                        // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                        // 數字	說明
                        // 7	可讀、可寫、可執行
                        // 6	可讀、可寫
                        // 5	可讀、可執行
                        // 4	唯讀
                        // 3	可寫、可執行
                        // 2	只寫
                        // 1	只可執行
                        // 0	沒有許可權
                        // 例如，八進制值 0o765 表示：
                        // 1) 、所有者可以讀取、寫入和執行該文檔；
                        // 2) 、群組可以讀和寫入該文檔；
                        // 3) 、其他人可以讀取和執行該文檔；
                        // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                        // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                    } catch (error) {
                        console.log("指定的待替換的文檔 [ " + web_path + " ] 無法修改為可讀可寫權限.");
                        console.error(error);
                        response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;
                    };
                };

                // 向指定的目標文檔同步寫入數據;
                // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                try {

                    // // console.log(file_data);
                    // // fs.writeFileSync(
                    // //     web_path,
                    // //     file_data,
                    // //     {
                    // //         encoding: "utf8",
                    // //         mode: 0o777,
                    // //         flag: "w+"
                    // //     }
                    // // );  // 返回值為 undefined;
                    // let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    // fs.writeFileSync(
                    //     web_path,
                    //     file_data_bytes,
                    //     {
                    //         mode: 0o777,
                    //         flag: "w+"
                    //     }
                    // );  // 返回值為 undefined;
                    // // console.log(file_data_bytes);
                    // // // let buffer = new Buffer(8);
                    // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
                    // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
                    // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
                    // // console.log(data_Str);
                    // // console.log("目標文檔: " + web_path + " 寫入成功.");
                    // // response_body_String = JSON.stringify(result);
                    // response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                    // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    // if (callback) { callback(null, response_body_String); };
                    // // return response_body_String;

                    fs.writeFile(
                        web_path,
                        file_data_bytes,  // file_data,
                        {
                            // encoding: "utf8",
                            mode: 0o777,
                            flag: "w+"
                        },
                        function (error) {

                            if (error) {

                                console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
                                console.error(error);
                                response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;

                            } else {

                                // console.log("目標文檔: " + web_path + " 寫入成功.");
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } catch (error) {

                    console.log("目標待替換文檔: " + web_path + " 無法寫入數據.");
                    console.error(error);
                    response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法寫入數據." + "\n" + String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };

            } else {

                // 截取目標寫入目錄;
                let writeDirectory = "";
                if (fileName.indexOf("/") === -1) {
                    writeDirectory = "/";
                } else {
                    let tempArray = new Array();
                    tempArray = fileName.split("/");
                    if (tempArray.length <= 2) {
                        writeDirectory = "/";
                    } else {
                        for(let i = 0; i < parseInt(parseInt(tempArray.length) - parseInt(1)); i++){
                            if (i === 0) {
                                writeDirectory = tempArray[i];
                            } else {
                                writeDirectory = writeDirectory + "/" + tempArray[i];
                            };
                        };
                    };
                };
                writeDirectory = String(path.join(webPath, writeDirectory));

                // 判斷目標寫入目錄是否存在，如果不存在則創建;
                try {
                    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(writeDirectory)方法判斷指定的目標寫入目錄是否存在以及是否為文件夾;
                    if (!(fs.existsSync(writeDirectory) && fs.statSync(writeDirectory, { bigint: false }).isDirectory())) {
                        // 同步創建目錄fs.mkdirSync(path, { mode: 0o777, recursive: false });，返回值 undefined;
                        fs.mkdirSync(writeDirectory, { mode: 0o777, recursive: true });  // 同步創建目錄，返回值 undefined;
                        // console.log("目錄: " + writeDirectory + " 創建成功.");
                    };
                    // 判斷指定的目標寫入目錄是否創建成功;
                    if (!(fs.existsSync(writeDirectory) && fs.statSync(writeDirectory, { bigint: false }).isDirectory())) {
                        console.log("無法創建指定的目標寫入目錄: { " + String(writeDirectory) + " }." + "\n" + "Unable to create the directory = { " + String(writeDirectory) + " }.");
                        response_data_JSON["Database_say"] = "無法創建或識別指定的目標寫入目錄 directory = { " + String(writeDirectory) + " }." + "\n" + "Unable to create the directory = { " + String(writeDirectory) + " }.";
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        return response_body_String;
                    };
                } catch (error) {
                    console.log("無法創建或識別指定的目標寫入目錄: { " + String(writeDirectory) + " }." + "\n" + "Unable to create or recognize the directory = { " + String(writeDirectory) + " }.");
                    console.error(error);
                    response_data_JSON["Database_say"] = "無法創建或識別指定的目標寫入目錄 directory = { " + String(writeDirectory) + " }." + "\n" + String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    return response_body_String;
                };

                // 同步創建指定的目標文檔，並向文檔寫入數據;
                // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                try {

                    // // console.log(file_data);
                    // // fs.writeFileSync(
                    // //     web_path,
                    // //     file_data,
                    // //     {
                    // //         encoding: "utf8",
                    // //         mode: 0o777,
                    // //         flag: "w+"
                    // //     }
                    // // );  // 返回值為 undefined;
                    // let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    // fs.writeFileSync(
                    //     web_path,
                    //     file_data_bytes,
                    //     {
                    //         mode: 0o777,
                    //         flag: "w+"
                    //     }
                    // );  // 返回值為 undefined;
                    // // console.log(web_path_bytes);
                    // // // let buffer = new Buffer(8);
                    // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
                    // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
                    // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
                    // // console.log(data_Str);

                    fs.writeFile(
                        web_path,
                        file_data_bytes,  // file_data,
                        {
                            // encoding: "utf8",
                            mode: 0o777,
                            flag: "w+"
                        },
                        function (error) {

                            if (error) {

                                console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
                                console.error(error);
                                response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;

                            } else {

                                // console.log("目標文檔: " + web_path + " 寫入成功.");
                                // response_body_String = JSON.stringify(result);
                                response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(null, response_body_String); };
                                // return response_body_String;
                            };
                        }
                    );

                } catch (error) {
                    console.log("目標待替換文檔: " + web_path + " 無法寫入數據.");
                    console.error(error);
                    response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 無法寫入數據." + "\n" + String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };
            };

            return response_body_String;
        }

        case "/deleteFile": {

            // fileName = "";
            // if (url_search_JSON.has("fileName")) {
            //     fileName = String(url_search_JSON.get("fileName"));  // "/Nodejs2MongodbServer.js" 自定義的待刪除的文件路徑全名;
            // };
            if (fileName === "" || fileName === null) {
                console.log("上傳參數錯誤，目標刪除文檔名稱字符串 file = { " + String(fileName) + " } 爲空.");
                response_data_JSON["Database_say"] = "上傳參數錯誤，目標刪除文檔名稱字符串 file = { " + String(fileName) + " } 爲空.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                return response_body_String;
            };

            if (fileName !== "" && fileName !== null) {

                web_path = String(path.join(webPath, fileName));
                file_data = request_POST_String;

                let file_data_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                // bytes = file_data.split("")[0].charCodeAt().toString(2);  // 字符串中的第一個字符轉十進制Unicode碼後轉二進制編碼;
                // bytes = file_data.split("")[0].charCodeAt();  // 字符串中的第一個字符轉十進制Unicode碼;
                // char = String.fromCharCode(bytes);  // 將十進制的Unicode碼轉換爲字符;
                // buffer = new ArrayBuffer(str.length * 2);  // 字符串轉Buffer數組，每個字符占用兩個字節;
                // bufView = new Uint16Array(buffer);  // 使用UTF-16編碼;
                // str = String.fromCharCode.apply(null, new Uint16Array(buffer));  // Buffer數組轉字符串;
                let file_data_len = Buffer.byteLength(file_data);

                // let statsObj = fs.statSync(web_path, {bigint: false});
                // if (statsObj.isFile()) {} else if (statsObj.isDirectory()) {} else {};
                if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {
                    // console.log("文檔路徑全名: " + web_path);
                    // console.log("文檔大小: " + String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB"));
                    // console.log("文檔修改日期: " + statsObj.mtime.toLocaleString());
                    // console.log("文檔操作權限值: " + String(statsObj.mode));

                    // 同步判斷文檔權限，後面所有代碼都是，當指定的文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    try {
                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                        // console.log("文檔: " + web_path + " 可以讀寫.");
                    } catch (error) {
                        // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                        try {
                            // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                            fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                            // console.log("文檔: " + web_path + " 操作權限修改為可以讀寫.");
                            // 常量                    八進制值    說明
                            // fs.constants.S_IRUSR    0o400      所有者可讀
                            // fs.constants.S_IWUSR    0o200      所有者可寫
                            // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                            // fs.constants.S_IRGRP    0o40       群組可讀
                            // fs.constants.S_IWGRP    0o20       群組可寫
                            // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                            // fs.constants.S_IROTH    0o4        其他人可讀
                            // fs.constants.S_IWOTH    0o2        其他人可寫
                            // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                            // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                            // 數字	說明
                            // 7	可讀、可寫、可執行
                            // 6	可讀、可寫
                            // 5	可讀、可執行
                            // 4	唯讀
                            // 3	可寫、可執行
                            // 2	只寫
                            // 1	只可執行
                            // 0	沒有許可權
                            // 例如，八進制值 0o765 表示：
                            // 1) 、所有者可以讀取、寫入和執行該文檔；
                            // 2) 、群組可以讀和寫入該文檔；
                            // 3) 、其他人可以讀取和執行該文檔；
                            // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                            // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                        } catch (error) {
                            console.log("指定的待刪除的文檔 [ " + web_path + " ] 無法修改為可讀可寫權限.");
                            console.error(error);
                            response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                    };

                    // 同步刪除指定的文檔;
                    // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    try {

                        // 同步刪除指定的文檔;
                        fs.unlinkSync(web_path);  // 同步刪除，返回值為 undefined;
                        // Get the files in current diectory;
                        // after deletion;
                        // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

                        // console.log("指定待刪除文檔: " + web_path + " 已被刪除.");
                        response_data_JSON["Database_say"] = `指定的待刪除的文檔 file = { ${fileName} } 已被刪除.\nDeleted file: ${web_path} .`;
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;

                        // // 異步刪除指定的文檔;
                        // fs.unlink(
                        //     web_path,
                        //     function (error) {
                        //         if (error) {
                        //             console.log("目標待刪除文檔: " + web_path + " 無法刪除.");
                        //             console.error(error);
                        //             response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         } else {
                        //             // console.log(`\nDeleted file:\n${web_path}`);
                        //             // // Get the files in current diectory;
                        //             // // after deletion;
                        //             // console.log("\nFiles present in directory:");
                        //             // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        //             // filesNameArray.forEach( (value, index, array) => { console.log(value); } ); 

                        //             // console.log("指定待刪除文檔: " + web_path + " 已被刪除.");
                        //             response_data_JSON["Database_say"] = `指定的待刪除的文檔 file = { ${fileName} } 已被刪除.\nDeleted file: ${web_path} .`;
                        //             // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             // if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         };
                        //     }
                        // );

                        // 同步寫入文檔;
                        // // console.log(file_data);
                        // fs.writeFileSync(
                        //     web_path,
                        //     file_data,
                        //     { encoding: "utf8", mode: 0o777, flag: "w+" }
                        // );  // 返回值為 undefined;
                        // // // web_path_bytes = new Uint8Array(Buffer.from(web_path));  // 轉換為 Buffer 二進制對象;
                        // // fs.writeFileSync(web_path, web_path_bytes, { mode: 0o777, flag: "w+" });  // 返回值為 undefined;
                        // // console.log(web_path_bytes);
                        // // // let buffer = new Buffer(8);
                        // // let buffer_data = fs.readFileSync(web_path, { encoding: null, flag: "r+" });
                        // // data_Str = buffer_data.toString("utf8");  // 將Buffer轉換爲String;
                        // // // buffer_data = Buffer.from(data_Str, "utf8");  // 將String轉換爲Buffer;
                        // // console.log(data_Str);
                        // console.log("目標文檔: " + web_path + " 寫入成功.");
                        // // response_body_String = JSON.stringify(result);
                        // response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                        // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        // if (callback) { callback(null, response_body_String); };
                        // // return response_body_String;

                        // fs.writeFile(
                        //     web_path,
                        //     file_data,
                        //     {
                        //         encoding: "utf8",
                        //         mode: 0o777,
                        //         flag: "w+"
                        //     },
                        //     function (error) {
                        //         if (error) {
                        //             console.log("目標待替換文檔: " + web_path + " 寫入數據錯誤.");
                        //             console.error(error);
                        //             response_data_JSON["Database_say"] = "指定的待替換的文檔 file = { " + String(fileName) + " } 寫入數據錯誤." + "\n" + String(error);
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         } else {
                        //             console.log("目標文檔: " + web_path + " 寫入成功.");
                        //             // response_body_String = JSON.stringify(result);
                        //             response_data_JSON["Database_say"] = "指定的目標文檔 file = { " + String(fileName) + " } 寫入成功.";
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(null, response_body_String); };
                        //             // return response_body_String;
                        //         };
                        //     }
                        // );

                    } catch (error) {

                        console.log("目標待刪除文檔: " + web_path + " 無法刪除.");
                        console.error(error);
                        response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;
                    };

                } else if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

                    // 同步判斷文檔權限，後面所有代碼都是，當指定的文件夾存在時的動作，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                    try {
                        // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
                        fs.accessSync(web_path, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
                        // console.log("文件夾: " + web_path + " 可以讀寫.");
                    } catch (error) {
                        // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
                        try {
                            // 同步修改文件夾權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                            fs.fchmodSync(web_path, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                            // console.log("文件夾: " + web_path + " 操作權限修改為可以讀寫.");
                            // 常量                    八進制值    說明
                            // fs.constants.S_IRUSR    0o400      所有者可讀
                            // fs.constants.S_IWUSR    0o200      所有者可寫
                            // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                            // fs.constants.S_IRGRP    0o40       群組可讀
                            // fs.constants.S_IWGRP    0o20       群組可寫
                            // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                            // fs.constants.S_IROTH    0o4        其他人可讀
                            // fs.constants.S_IWOTH    0o2        其他人可寫
                            // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                            // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                            // 數字	說明
                            // 7	可讀、可寫、可執行
                            // 6	可讀、可寫
                            // 5	可讀、可執行
                            // 4	唯讀
                            // 3	可寫、可執行
                            // 2	只寫
                            // 1	只可執行
                            // 0	沒有許可權
                            // 例如，八進制值 0o765 表示：
                            // 1) 、所有者可以讀取、寫入和執行該文檔；
                            // 2) 、群組可以讀和寫入該文檔；
                            // 3) 、其他人可以讀取和執行該文檔；
                            // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                            // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
                        } catch (error) {
                            console.log("指定的待刪除的文件夾 [ " + web_path + " ] 無法修改為可讀可寫權限.");
                            console.error(error);
                            response_data_JSON["Database_say"] = "指定的待刪除的文件夾 Directory = { " + String(fileName) + " } 無法修改為可讀可寫權限." + "\n" + String(error);
                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                            if (callback) { callback(response_body_String, null); };
                            // return response_body_String;
                        };
                    };

                    // 同步刪除指定的文件夾;
                    // web_path_bytes = new Uint8Array(Buffer.from(file_data));  // 轉換為 Buffer 二進制對象;
                    try {

                        // 同步刪除指定的文件夾;
                        fs.rmdirSync(web_path, { recursive: true, maxRetries: 0, retryDelay: 100 });  // 同步刪除，返回值為 undefined;
                        // Get the current filenames;
                        // in the directory to verify;
                        // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

                        // console.log("指定待刪除文件夾: " + web_path + " 已被刪除.");
                        response_data_JSON["Database_say"] = `指定的待刪除的文件夾 directory = { ${fileName} } 已被刪除.\nDeleted directory: ${web_path} .`;
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;

                        // // 異步刪除指定的文件夾;
                        // fs.rmdir(
                        //     web_path,
                        //     { 
                        //         recursive: true,
                        //         maxRetries: 0,
                        //         retryDelay: 100
                        //     },
                        //     function (error) {
                        //         if (error) {
                        //             console.log("目標待刪除文件夾: " + web_path + " 無法刪除.");
                        //             console.error(error);
                        //             response_data_JSON["Database_say"] = "指定的待刪除的文件夾 directory = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        //             response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         } else {
                        //             // console.log(`\nDeleted file:\n${web_path}`);
                        //             // // Get the files in current diectory;
                        //             // // after deletion;
                        //             // console.log("\nFiles present in directory:");
                        //             // let filesNameArray = fs.readdirSync(__dirname, { encoding: "utf8", withFileTypes: false });
                        //             // filesNameArray.forEach( (value, index, array) => { console.log(value); } );

                        //             // console.log("指定待刪除文件夾: " + web_path + " 已被刪除.");
                        //             response_data_JSON["Database_say"] = `指定的待刪除的文件夾 directory = { ${fileName} } 已被刪除.\nDeleted directory: ${web_path} .`;
                        //             // response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        //             // // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        //             // if (callback) { callback(response_body_String, null); };
                        //             // return response_body_String;
                        //         };
                        //     }
                        // );

                        // // 同步創建文件夾;
                        // fs.mkdirSync(web_path, 0777);
                        // // 伊布創建文件夾;
                        // fs.mkdir(
                        //     web_path,
                        //     {
                        //         recursive: true
                        //     },
                        //     function (error) {
                        //         if (error) {
                        //             console.error(err);
                        //         } else {
                        //             console.log('Directory created successfully!');
                        //         };
                        //     }
                        // );

                    } catch (error) {

                        console.log("目標待刪除文件夾: " + web_path + " 無法刪除.");
                        console.error(error);
                        response_data_JSON["Database_say"] = "指定的待刪除的文件夾 directory = { " + String(fileName) + " } 無法刪除." + "\n" + String(error);
                        response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                        // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                        if (callback) { callback(response_body_String, null); };
                        // return response_body_String;
                    };

                } else {

                    console.log("指定的待刪除的文檔: " + String(web_path) + " 不存在或無法識別." + "\n" + "file = { " + String(web_path) + " } can not found.");
                    response_data_JSON["Database_say"] = "指定的待刪除的文檔 file = { " + String(fileName) + " } 不存在或無法識別." + "\n" + "file = { " + String(fileName) + " } can not found.";
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                };
            };

            // let web_path_index_Html = String(path.join(webPath, "/administrator.html"));
            // file_data = request_POST_String;
            // // web_path = String(path.join(webPath, request_url_path));
            // let currentDirectory = "";
            // if (fileName === "" || fileName === null) {
            //     currentDirectory = "/";
            // } else {
            //     if (fileName.indexOf("/") !== -1) {
            //         let tempArray = new Array();
            //         tempArray = fileName.split("/");
            //         for(let i = 0; i < parseInt(parseInt(tempArray.length) - parseInt(1)); i++){
            //             if (i === 0) {
            //                 currentDirectory = tempArray[i];
            //             } else {
            //                 currentDirectory = currentDirectory + "/" + tempArray[i];
            //             };
            //         };
            //     } else {
            //         currentDirectory = "/";
            //     };
            // };
            // web_path = String(path.join(webPath, currentDirectory));

            // if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

            //     try {

            //         // // 同步讀取硬盤文檔;
            //         // file_data = fs.readFileSync(web_path_index_Html);
            //         // // console.log("同步讀取文檔: " + file_data.toString());
            //         // let filesName = fs.readdirSync(web_path);
            //         // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
            //         // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
            //         // filesName.forEach(
            //         //     function (item) {
            //         //         // console.log("異步讀取文件夾目錄: " + item.toString());
            //         //         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
            //         //         if (statsObj.isFile()) {
            //         //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
            //         //         } else if (statsObj.isDirectory()) {
            //         //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
            //         //         } else {};
            //         //     }
            //         // );
            //         // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
            //         // // console.log(response_body_String);
            //         // // return response_body_String;

            //         // 異步讀取硬盤文檔;
            //         fs.readFile(
            //             web_path_index_Html,
            //             function (error, data) {

            //                 if (error) {
            //                     console.error(error);
            //                     response_data_JSON["Database_say"] = String(error);
            //                     response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                     // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                     if (callback) { callback(response_body_String, null); };
            //                     // return response_body_String;
            //                 };

            //                 if (data) {
            //                     file_data = data;
            //                     // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
            //                     fs.readdir(
            //                         web_path,
            //                         function (error, filesName) {

            //                             if (error) {
            //                                 console.error(error);
            //                                 response_data_JSON["Database_say"] = String(error);
            //                                 response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //                                 // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //                                 if (callback) { callback(response_body_String, null); };
            //                                 // return response_body_String;
            //                             };

            //                             if (filesName) {
            //                                 let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>';
            //                                 // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
            //                                 filesName.forEach(
            //                                     function (item) {
            //                                         // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve(currentDirectory, item.toString())), search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
            //                                         let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve(currentDirectory, item.toString())), search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
            //                                         let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve(currentDirectory, item.toString()) + "&Key=" + Key), hash: ""}));
            //                                         let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
            //                                         let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
            //                                         // console.log("異步讀取文件夾目錄: " + item.toString());
            //                                         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
            //                                         if (statsObj.isFile()) {
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
            //                                         directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
            //                                         // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
            //                                         } else if (statsObj.isDirectory()) {
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
            //                                         directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
            //                                         // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
            //                                         } else {};
            //                                     }
            //                                 );
            //                                 response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
            //                                 // console.log(response_body_String);
            //                                 if (callback) { callback(null, response_body_String); };
            //                                 // return response_body_String;
            //                             };
            //                         }
            //                     );
            //                 };
            //             }
            //         );

            //     } catch (error) {
            //         console.log(`硬盤文檔 ( ${web_path_index_Html} ) 打開或讀取錯誤.`);
            //         console.error(error);
            //         response_data_JSON["Database_say"] = String(error);
            //         response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
            //         // String = JSON.stringify(JSON); JSON = JSON.parse(String);
            //         if (callback) { callback(response_body_String, null); };
            //         // return response_body_String;
            //     } finally {
            //         // fs.close();
            //     };
            // };

            return response_body_String;
        }

        default: {

            let web_path_index_Html = String(path.join(webPath, "/administrator.html"));
            // web_path = String(path.join(webPath, request_url_path));
            file_data = null;

            if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isFile()) {

                try {

                    // // 同步讀取硬盤文檔;
                    // file_data = fs.readFileSync(web_path);
                    // // console.log("同步讀取文檔: " + file_data.toString());
                    // response_body_String = file_data.toString();
                    // // console.log(response_body_String);
                    // // return response_body_String;

                    // 異步讀取硬盤文檔;
                    fs.readFile(
                        web_path,
                        function (error, data) {

                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };

                            if (data) {

                                let file_data_Buffer = data;
                                // let buffer = new ArrayBuffer(TemporaryPublicVariableCollectResultStoredStringArray.length);  // 字符串轉Buffer數組，注意，如果是漢字符數組，則每個字符占用兩個字節，即 .length * 2;
                                // let file_data_bytes_Uint8Array = new Uint8Array(buffer);  // 轉換為 Buffer 二進制對象;
                                // for (let i = 0; i < TemporaryPublicVariableCollectResultStoredStringArray.length; i++) {
                                //     file_data_bytes_Uint8Array[i] = TemporaryPublicVariableCollectResultStoredStringArray[i];
                                // };
                                // file_data_String = file_data_bytes_Uint8Array.toString();
                                file_data_Buffer = new Uint8Array(file_data_Buffer);
                                // console.log(file_data_Buffer);
                                // file_data = file_data_Buffer.toString();
                                // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                                // file_data = JSON.stringify(file_data_Buffer);  // JSON.parse(file_data);
                                let file_data_Uint8Array = new Array();
                                for (let i = 0; i < file_data_Buffer.length; i++) {
                                    file_data_Uint8Array.push(file_data_Buffer[i]);
                                    // file_data_Uint8Array.push(String(file_data_Buffer[i]));
                                };
                                file_data = JSON.stringify(file_data_Uint8Array);  // JSON.parse(file_data);
                                response_body_String = file_data;
                                // console.log(response_body_String);
                                if (callback) { callback(null, response_body_String); };
                            };
                        }
                    );

                } catch (error) {
                    console.log(`硬盤文檔 ( ${web_path} ) 打開或讀取錯誤.`);
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                } finally {
                    // fs.close();
                };

            } else if (fs.existsSync(web_path) && fs.statSync(web_path, {bigint: false}).isDirectory()) {

                try {

                    // // 同步讀取硬盤文檔;
                    // file_data = fs.readFileSync(web_path_index_Html);
                    // // console.log("同步讀取文檔: " + file_data.toString());
                    // let filesName = fs.readdirSync(web_path);
                    // let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位 kB）</td><td>文檔修改時間</td></tr>';
                    // // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                    // filesName.forEach(
                    //     function (item) {
                    //         // console.log("異步讀取文件夾目錄: " + item.toString());
                    //         let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
                    //         if (statsObj.isFile()) {
                    //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${String(Date.parse(statsObj.mtime) / parseInt(1000))}</td></tr>`;
                    //         } else if (statsObj.isDirectory()) {
                    //             directoryHTML = directoryHTML + `<tr><td><a href="#">${item.toString()}</a></td><td></td><td></td></tr>`;
                    //         } else {};
                    //     }
                    // );
                    // response_body_String = file_data.toString().replace("directoryHTML", directoryHTML);
                    // // console.log(response_body_String);
                    // // return response_body_String;

                    // 異步讀取硬盤文檔;
                    fs.readFile(
                        web_path_index_Html,
                        function (error, data) {

                            if (error) {
                                console.error(error);
                                response_data_JSON["Database_say"] = String(error);
                                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                if (callback) { callback(response_body_String, null); };
                                // return response_body_String;
                            };

                            if (data) {
                                file_data = data;
                                // console.log("異步讀取文檔: " + "\\n" + file_data.toString());
                                fs.readdir(
                                    web_path,
                                    function (error, filesName) {

                                        if (error) {
                                            console.error(error);
                                            response_data_JSON["Database_say"] = String(error);
                                            response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                                            // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                                            if (callback) { callback(response_body_String, null); };
                                            // return response_body_String;
                                        };

                                        if (filesName) {
                                            let directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>';
                                            // console.log("異步讀取文件夾目錄清單: " + "\\n" + filesName.toString());
                                            filesName.forEach(
                                                function (item) {
                                                    // let name_href_url_string = String(url.format({protocol: "http", auth: Key, hostname: String(host), port: String(port), pathname: String(url.resolve(request_url_path + "/", item.toString())), search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                    let name_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: String(url.resolve(request_url_path + "/", item.toString())), search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                    let delete_href_url_string = String(url.format({protocol: "http", auth: Key, host: String(request_headers["host"]), pathname: "/deleteFile", search: String("fileName=" + url.resolve(request_url_path + "/", item.toString()) + "&Key=" + Key), hash: ""}));
                                                    let downloadFile_href_string = `fileDownload('post', 'UpLoadData', '${name_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '${item.toString()}', function(error, response){})`;
                                                    let deleteFile_href_string = `deleteFile('post', 'UpLoadData', '${delete_href_url_string}', parseInt(30000), '${Key}', 'Session_ID=request_Key->${Key}', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})`;
                                                    // console.log("異步讀取文件夾目錄: " + item.toString());
                                                    let statsObj = fs.statSync(String(path.join(web_path, item)), {bigint: false});
                                                    if (statsObj.isFile()) {
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td></tr>`;
                                                        directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                        // directoryHTML = directoryHTML + `<tr><td><a onclick="${downloadFile_href_string}" href="javascript:void(0)">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="javascript:${downloadFile_href_string}">${item.toString()}</a></td><td>${String(parseInt(statsObj.size) / parseInt(1000)).concat(" kB")}</td><td>${statsObj.mtime.toLocaleString()}</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    } else if (statsObj.isDirectory()) {
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="javascript:void(0)">${item.toString()}</a></td><td></td><td></td></tr>`;
                                                        directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="javascript:${deleteFile_href_string}">刪除</a></td></tr>`;
                                                        // directoryHTML = directoryHTML + `<tr><td><a href="${name_href_url_string}">${item.toString()}</a></td><td></td><td></td><td><a href="${delete_href_url_string}">刪除</a></td></tr>`;
                                                    } else {};
                                                }
                                            );
                                            response_body_String = file_data.toString().replace("<!-- directoryHTML -->", directoryHTML);
                                            // console.log(response_body_String);
                                            if (callback) { callback(null, response_body_String); };
                                            // return response_body_String;
                                        };
                                    }
                                );
                            };
                        }
                    );

                } catch (error) {
                    console.log(`硬盤文檔 ( ${web_path_index_Html} ) 打開或讀取錯誤.`);
                    console.error(error);
                    response_data_JSON["Database_say"] = String(error);
                    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                    if (callback) { callback(response_body_String, null); };
                    // return response_body_String;
                } finally {
                    // fs.close();
                };

            } else {

                console.log("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + String(web_path) + " } 無法識別.");
                response_data_JSON["Database_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + String(fileName) + " } 無法識別.";
                response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
                // String = JSON.stringify(JSON); JSON = JSON.parse(String);
                if (callback) { callback(response_body_String, null); };
                // return response_body_String;
            };

            return response_body_String;
        }
    };
};


// // 媒介服務器函數服務端（後端） http_Server() 使用説明;
// // const child_process = require('child_process');  // Node原生的創建子進程模組;
// // const os = require('os');  // Node原生的操作系統信息模組;
// // const net = require('net');  // Node原生的網卡網絡操作模組;
// // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const qs = require('querystring');
// const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
// // const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
// const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
// const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
// // const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
// // const cluster = require('cluster');  // Node原生的支持多進程模組;
// // // const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
// // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
// let host = "::0";  // "::0", "::1", "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
// let port = 10001;  // 1 ~ 65535 監聽端口;
// let webPath = String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// // let webPath = String(require('path').join(String(__dirname), "html"));
// let number_cluster_Workers = parseInt(0);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目，取 0 值表示不開啓多進程集群;
// // console.log(number_cluster_Workers);
// let Key = "username:password";  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
// // { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
// let Session = {
//     "request_Key->username:password": Key
// };
// let do_Request = do_Request_Router;  // 用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// // let do_Request = do_Request_Router;  // function (argument) { return argument; };  // 函數對象字符串，用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// let do_Function_JSON = {
//     "do_Request": do_Request.toString(),  // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
// };
// let exclusive = false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
// let backlog = 511;  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
// // 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
// let readableAll = false;  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
// let writableAll = false;  // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
// let ipv6Only = false;  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。


// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     // try {
//                     //     if (process.argv[i].split("=")[0] !== "do_Request" && process.argv[i].split("=")[0] !== "Session" && process.argv[i].split("=")[0] !== "port" && process.argv[i].split("=")[0] !== "number_cluster_Workers") {
//                     //         eval(process.argv[i] + ";");
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "port" && process.argv[i].split("=")[0] === "number_cluster_Workers") {
//                     //         // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
//                     //         eval(process.argv[i].split("=")[0]) = parseInt(process.argv[i].split('=')[1]);
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "Session") {
//                     //         if (isStringJSON(process.argv[i].split('=')[1])) {
//                     //             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
//                     //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                     //             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                     //         } else {
//                     //             eval(process.argv[i] + ";");
//                     //         };
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                     //     } else {
//                     //         do_Request = null;
//                     //     };
//                     //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     // } catch (error) {
//                     //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     console.log(error);
//                     // };
//                     switch (process.argv[i].split("=")[0]) {
//                         case "Key": {
//                             Key = String(process.argv[i].split("=")[1]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
//                             // console.log("Server UserName and PassWord: " + Key);
//                             break;
//                         }
//                         case "host": {
//                             host = String(process.argv[i].split("=")[1]);  // // "0.0.0.0" or "localhost"; 監聽主機域名;
//                             // console.log("Host domain name: " + host);
//                             break;
//                         }
//                         case "port": {
//                             port = parseInt(process.argv[i].split("=")[1]);  // 8000; 監聽端口;
//                             // console.log("listening Port: " + port);
//                             break;
//                         }
//                         case "webPath": {
//                             webPath = String(process.argv[i].split("=")[1]);  // "C:\Criss\js\"; 監聽端口;
//                             // console.log("http Server root directory: " + webPath);
//                             break;
//                         }
//                         case "number_cluster_Workers": {
//                             number_cluster_Workers = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目;
//                             // console.log("number cluster Workers: " + number_cluster_Workers);
//                             break;
//                         }
//                         case "Session": {
//                             if (isStringJSON(process.argv[i].split('=')[1])) {
//                                 Session = JSON.parse(process.argv[i].split('=')[1]);
//                             } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                                 Session[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                             } else {
//                                 Session = null;
//                             };
//                             // console.log("Server Session: " + Session);
//                             break;
//                         }
//                         case "do_Request": {
//                             // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
//                             if (Object.prototype.toString.call(do_Request = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                                 do_Request = eval(process.argv[i].split('=')[1]);
//                             } else {
//                                 do_Request = null;
//                             };
//                             // console.log("do_Request: " + do_Request);
//                             break;
//                         }
//                         default: {
//                             console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                             break;
//                         }
//                     };
//                 };
//             };
//         };
//     };
// };


// let Server = Interface_http_Server({
//     "host": host,
//     "port": port,
//     "number_cluster_Workers": number_cluster_Workers,
//     "Key": Key,
//     "Session": Session,
//     // "do_Function_JSON": do_Function_JSON,
//     "do_Request": do_Request,
//     "exclusive": exclusive,
//     "backlog": backlog,
//     "readableAll": readableAll,
//     "writableAll": writableAll,
//     "ipv6Only": ipv6Only
// });
// // let Server = Interface_http_Server({
// //     "do_Request": do_Request,
// //     "Session": Session,
// //     "Key": Key,
// //     "number_cluster_Workers": number_cluster_Workers,
// // });



// 自定義具體處理從服務端返回的響應值數據的執行函數;
function do_Response_Router(
    response_status,
    response_headers,
    response_POST_String,
    callback
){
// async function do_Request_Router(
//     response_status,
//     response_headers,
//     response_POST_String
// ){

    // console.log(response_status);
    // console.log(response_headers);
    // console.log(response_POST_String);

    // Check the file extension required and set the right mime type;
    // try {
    //     fs.readFileSync();
    //     fs.writeFileSync();
    // } catch (error) {
    //     console.log("硬盤文件打開或讀取錯誤.");
    // } finally {
    //     fs.close();
    // };

    let response_body_String = "";
    // let now_date = new Date().toLocaleString('chinese', { hour12: false });
    let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
    // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
    let response_data_JSON = {
        "response_status": response_status,
        "response_headers": response_headers,
        "response_POST_String": response_POST_String,
        // "response_Cookie": response_headers["Set-Cookie"],  // cookie_string = "session_id=".concat("request_Key->", String(request_Key), "; expires=", String(after_30_Days), "; path=/;");
        // "Server_Authorization": response_headers["WWW-Authenticate"],  // "username:password";
        "time": String(now_date)
    };
    // console.log(response_data_JSON);

    response_body_String = JSON.stringify(response_data_JSON);  // 將JOSN對象轉換為JSON字符串;
    // String = JSON.stringify(JSON); JSON = JSON.parse(String);
    // console.log(response_body_String);

    // // let filePath = String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
    // // console.log(filePath);
    // let file_path = String(path.join(filePath, response_url_path));
    // // console.log(file_path);

    // // try {
    // //     // 異步寫入硬盤文檔;
    // //     fs.writeFile(
    // //         file_path,
    // //         data,
    // //         function (error) {
    // //             if (error) { return console.error(error); };
    // //         }
    // //     );
    // //     // 同步讀取硬盤文檔;
    // //     // fs.writeFileSync(file_path, data);
    // // } catch (error) {
    // //     console.log("硬盤文檔打開或寫入錯誤.");
    // // } finally {
    // //     fs.close();
    // // };

    if (callback) { callback(response_body_String, null); };
    return response_body_String;
};


// // http_Client_「http」;
// let Host = "localhost";
// let Port = "10001";
// let URL = "/"; // "http://localhost:10001"，"http://usename:password@localhost:10001/";
// let Method = "POST";  // "GET"; // 請求方法;
// let time_out = 1000;  // 500 設置鏈接超時自動中斷，單位毫秒;
// let request_Auth = "username:password";
// let request_Cookie = "Session_ID=request_Key->username:password";
// // request_Cookie = request_Cookie.split("=")[0].concat("=", new Base64().encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
// let do_Response = do_Response_Router;  // 函數對象字符串，用於執行對接收到的服務端返回的響應處理功能的函數 "do_Response_Router";
// // let do_Response = function (argument) { return argument; };  // 函數對象字符串，用於執行對接收到的服務端返回的響應處理功能的函數 "do_Response_Router";
// let do_Function_JSON = {
//     "do_Response": do_Response.toString(),  // "function() {};" 函數對象字符串，JSON 對象，用於執行對接收到的服務端返回的響應處理功能的函數 "do_Response_Router";
// };

// // 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// // console.log(typeof(process.argv));
// // console.log(process.argv);
// // 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
// if (process.argv.length > 2) {
//     for (let i = 0; i < process.argv.length; i++) {
//         console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
//         if (i > 1) {
//             // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
//             if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
//                 if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
//                     // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
//                 } else {
//                     // try {
//                     //     if (process.argv[i].split("=")[0] !== "do_Request" && process.argv[i].split("=")[0] !== "Session" && process.argv[i].split("=")[0] !== "port" && process.argv[i].split("=")[0] !== "number_cluster_Workers") {
//                     //         eval(process.argv[i] + ";");
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "port" && process.argv[i].split("=")[0] === "number_cluster_Workers") {
//                     //         // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
//                     //         eval(process.argv[i].split("=")[0]) = parseInt(process.argv[i].split('=')[1]);
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "Session") {
//                     //         if (isStringJSON(process.argv[i].split('=')[1])) {
//                     //             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
//                     //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
//                     //             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
//                     //         } else {
//                     //             eval(process.argv[i] + ";");
//                     //         };
//                     //     };
//                     //     if (process.argv[i].split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                     //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
//                     //     } else {
//                     //         do_Request = null;
//                     //     };
//                     //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
//                     // } catch (error) {
//                     //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                     //     console.log(error);
//                     // };
//                     switch (process.argv[i].split("=")[0]) {
//                         case "host": {
//                             // host = String(process.argv[i].split("=")[1]);  // // "0.0.0.0" or "localhost"; 監聽主機域名;
//                             // // console.log("Host domain name: " + host);
//                             Host = String(process.argv[i].split("=")[1]);  // // "0.0.0.0" or "localhost"; 監聽主機域名;
//                             // console.log("Host domain name: " + Host);
//                             break;
//                         }
//                         case "port": {
//                             // port = parseInt(process.argv[i].split("=")[1]);  // 8000; 監聽端口;
//                             // // console.log("listening Port: " + port);
//                             Port = parseInt(process.argv[i].split("=")[1]);  // 8000; 監聽端口;
//                             // console.log("listening Port: " + Port);
//                             break;
//                         }
//                         case "URL": {
//                             URL = String(process.argv[i].split("=")[1]);  // "http://usename:password@localhost:10001/"; 請求的網址字符串;
//                             // console.log("request URL: " + URL);
//                             break;
//                         }
//                         case "method": {
//                             // method = String(process.argv[i].split("=")[1]);  // "POST"; 請求的類型;
//                             Method = String(process.argv[i].split("=")[1]);  // "POST"; 請求的類型;
//                             // console.log("request Method: " + Method);
//                             break;
//                         }
//                         case "time_out": {
//                             time_out = parseInt(process.argv[i].split("=")[1]);  // 1000; 設置鏈接超時自動中斷，單位毫秒;
//                             // console.log("request out time: " + time_out);
//                             break;
//                         }
//                         case "request_Auth": {
//                             request_Auth = String(process.argv[i].split("=")[1]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
//                             // console.log("Client UserName and PassWord: " + request_Auth);
//                             break;
//                         }
//                         case "request_Cookie": {
//                             request_Cookie = String(process.argv[i].split("=")[1]);  // "Session_ID=request_Key->username:password" 自定義的訪問網站時發送的請求 Cookie 值;
//                             // console.log("Client request Cookie: " + request_Cookie);
//                             break;
//                         }
//                         case "output_dir": {
//                             output_dir = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介目錄 "../temp/";
//                             // console.log("output dir: " + output_dir);
//                             break;
//                         }
//                         case "output_file": {
//                             output_file = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
//                             // console.log("output file: " + output_file);
//                             break;
//                         }
//                         case "to_executable": {
//                             to_executable = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
//                             // console.log("to executable: " + to_executable);
//                             break;
//                         }
//                         case "to_script": {
//                             to_script = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
//                             // console.log("to script: " + to_script);
//                             break;
//                         }
//                         case "do_Response": {
//                             // "function() {};" 函數對象字符串，// 函數對象字符串，用於執行對接收到的服務端返回的響應處理功能的函數 "do_Response_Router";
//                             if (Object.prototype.toString.call(do_Response = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
//                                 do_Response = eval(process.argv[i].split('=')[1]);
//                             } else {
//                                 do_Response = null;
//                             };
//                             // console.log("do_Response: " + do_Response);
//                             break;
//                         }
//                         default: {
//                             console.log("Don't recognize argument [ " + process.argv[i] + " ].");
//                             break;
//                         }
//                     };
//                 };
//             };
//         };
//     };
// };


// // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
// // const qs = require('querystring');
// // const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
// // 這裏是需要向Python服務器發送的參數數據JSON對象;
// // let now_date = new Date().toLocaleString('chinese', { hour12: false });
// let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
// // let nowDate = new Date();
// // let time = nowDate.getFullYear() + "-" + (parseInt(nowDate.getMonth()) + parseInt(1)).toString() + "-" + nowDate.getDate() + "-" + nowDate.getHours() + "-" + nowDate.getMinutes() + "-" + nowDate.getSeconds() + "-" + nowDate.getMilliseconds();
// // console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
// let post_Data_JSON = {"Column_1" : "b-1", "Column_2" : "一級", "Column_3" : "b-1-1", "Column_4" : "二級", "Column_5" : "b-1-2", "Column_6" : "二級", "Column_7" : "b-1-3", "Column_8" : "二級", "Column_9" : "b-1-4", "Column_10" : "二級", "Column_11" : "b-1-5", "Column_12" : "二級"};
// let post_Data_String = JSON.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;
// let Host = "localhost";
// let Port = "8000";
// let URL = "/index.html";  // "http://localhost:8000"，"http://usename:password@localhost:8000/";
// let Method = "POST";  // "GET", "POST"; // 請求方法;
// let time_out = 1000;  // 500 設置鏈接超時自動中斷，單位毫秒;
// let request_Auth = "username:password";
// let request_Cookie = "Session_ID=request_Key->username:password";
// request_Cookie = request_Cookie.split("=")[0].concat("=", Base64.encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(Base64.encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));

// Interface_http_Client({
//     "Host": Host,
//     "Port": Port,
//     "URL": URL,
//     "Method": Method,
//     "time_out": time_out,
//     "request_Auth": request_Auth,
//     "request_Cookie": request_Cookie,
//     "post_Data_String": post_Data_String
// }, (error, response) => {
//     // console.log(response);

//     let response_status_String = response[0];
//     // console.log(response_status_String);
//     let response_head_String = response[1];
//     // console.log(response_head_String);

//     let response_body_String = response[2];
//     console.log(response_body_String);
//     // // // response_body_String = {
//     // // //     "request Nikename": request_Nikename,
//     // // //     "request Passwork": request_Password,
//     // // //     "request_Authorization": Key,  // "username:password";
//     // // //     "Server_say": "Fine, thank you, and you ?",
//     // // //     "time": "2021-02-03 20:21:25.136"
//     // // // };

//     // // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
//     // let data_JSON = {};
//     // if (isStringJSON(response_body_String)) {
//     //     data_JSON = JSON.parse(response_body_String);
//     // } else {
//     //     data_JSON = {
//     //         "Server_say": response_body_String
//     //     };
//     // };

//     // console.log("Server say: " + data_JSON["Server_say"]);
// });









// 函數使用示例;
// 控制臺命令行使用:
// C:\> C:\Criss\NodeJS\nodejs-14.4.0\node.exe C:/Criss/js/application.js

// 配置預設值;
let interface_Function = Interface_http_Server;  // Interface_file_Monitor or Interface_http_Server or Interface_http_Client;
let interface_Function_name_str = "Interface_http_Server";  // "Interface_file_Monitor" or "Interface_http_Server" or "Interface_http_Client";
let do_Function_name_str_data = "do_Request";  // "do_data" or "do_Request" or "do_Response";

// 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
let is_monitor = true;  // Boolean;
// let is_Monitor_Concurrent = "";  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
let monitor_dir = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "Intermediary"));  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
let monitor_file = String(require('path').join(String(monitor_dir), "intermediary_write_C.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_C.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
let output_dir = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "Intermediary"));  // path.normalize(p)。path.join([path1][, path2][, ...])，path.resolve('main.js') 用於輸出傳值的媒介目錄 "../temp/";
let output_file = String(require('path').join(String(output_dir), "intermediary_write_Nodejs.txt"));  // String(require('path').join(String(__dirname), "Intermediary", "intermediary_write_Nodejs.txt"));  // path.dirname(p)，path.basename(p[, ext])，path.extname(p)，path.parse(pathString) 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
let temp_NodeJS_cache_IO_data_dir = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "temp"));  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";
let to_executable = "";  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\Python\\Python39\\python.exe";
let to_script = "";  // 用於對返回數據執行功能的被調用的脚本文檔 "../py/test.py";
let delay = parseInt(100);  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay)，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
let number_Worker_threads = parseInt(0);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
let do_Function = do_data;  // function (argument) { return argument; };  // 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
let Worker_threads_Script_path = "";  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
let Worker_threads_eval_value = null;  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });

// 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
let host = "::0";  // "::0", "::1", "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
let port = 10001;  // 1 ~ 65535 監聽端口;
let webPath = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "html"));  // String(__dirname);  // process.cwd(), path.resolve("../"),  __dirname, __filename;  // 定義一個網站保存路徑變量;
// let webPath = String(require('path').join(String(__dirname), "html"));
let number_cluster_Workers = parseInt(0);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目，取 0 值表示不開啓多進程集群;
// console.log(number_cluster_Workers);
let Key = "username:password";  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
// { "request_Key->username:password": Key }; 自定義 session 值，JSON 對象;
let Session = {
    "request_Key->username:password": Key
};
let do_Request = do_Request_Router;  // function (argument) { return argument; };  // 用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
let do_Function_JSON = {
    "do_Request": do_Request.toString(),  // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Request_Router";
};
let exclusive = false;  // 如果 exclusive 是 false（默認），則集群的所有進程將使用相同的底層控制碼，允許共用連接處理任務。如果 exclusive 是 true，則控制碼不會被共用，如果嘗試埠共用將導致錯誤;
let backlog = 511;  // 預設值:511，backlog 參數來指定待連接佇列的最大長度;
// 以 root 身份啟動 IPC 伺服器可能導致無特權使用者無法訪問伺服器路徑。 使用 readableAll 和 writableAll 將使所有用戶都可以訪問伺服器;
let readableAll = false;  // readableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可讀。預設值: false。
let writableAll = false;  // writableAll <boolean> 對於 IPC 伺服器，使管道對所有用戶都可寫。預設值: false。
let ipv6Only = false;  // ipv6Only <boolean> 對於 TCP 伺服器，將 ipv6Only 設置為 true 將會禁用雙棧支援，即綁定到主機:: 不會使 0.0.0.0 綁定。預設值: false。

// 接收當 interface_Function = Interface_http_Client 時的傳入參數值;
let Host = "localhost";
let Port = "8000";
let URL = "/"; // "http://localhost:8000"，"http://usename:password@localhost:8000/";
let Method = "POST";  // "GET"; // 請求方法;
let time_out = 1000;  // 500 設置鏈接超時自動中斷，單位毫秒;
let request_Auth = "username:password";
let request_Cookie = "Session_ID=request_Key->username:password";
// request_Cookie = request_Cookie.split("=")[0].concat("=", new Base64().encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
request_Cookie = request_Cookie.split("=")[0].concat("=", Base64.encode(request_Cookie.split("=")[1]));  // "Session_ID=".concat(new Base64().encode("request_Key->username:password")); "Session_ID=".concat(escape("request_Key->username:password"));
// let filePath = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__dirname)))), "html"));
let do_Response = do_Response_Router;  // function (argument) { return argument; };  // 用於接收執行處理響應值（response）處理功能的函數 "do_Response_Router";
do_Function_JSON["do_Response"] = do_Response.toString();  // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 或 POST 請求處理功能的函數 "do_Response_Router";

// let now_date = new Date().toLocaleString('chinese', { hour12: false });
let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
// let nowDate = new Date();
// let time = nowDate.getFullYear() + "-" + (parseInt(nowDate.getMonth()) + parseInt(1)).toString() + "-" + nowDate.getDate() + "-" + nowDate.getHours() + "-" + nowDate.getMinutes() + "-" + nowDate.getSeconds() + "-" + nowDate.getMilliseconds();
// console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
let argument = "How_are_you_!";
let post_Data_JSON = {
    "Client_say": argument.replace(new RegExp("\\_", "g"), " "),
    "time": String(now_date)
};
let post_Data_String = JSON.stringify(post_Data_JSON); // 使用'querystring'庫的querystring.stringify()函數，將JSON對象轉換為JSON字符串;


// 用於輸入運行參數的配置文檔路徑全名;
let configFile = String(require('path').join(String(require('path').dirname(require('path').dirname(String(__filename)))), "config.txt"));  // "C:/Criss/js/config.txt"; // "/home/Criss/js/config.txt";
// let configFile = String(String(require('path').join(String(require('path').dirname(require('path').dirname(String(__filename)))), "config.txt")).replace("\\", "/"));  // "C:/Criss/js/config.txt"; // "/home/Criss/js/config.txt";
// console.log(configFile);
// 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// console.log(typeof(process.argv));
// console.log(process.argv);
// 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
if (process.argv.length > 2) {
    for (let i = 0; i < process.argv.length; i++) {
        // console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
        if (i > 1) {
            // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
            if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
                if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
                    // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
                } else {
                    // try {
                    //     if (process.argv[i].split("=")[0] !== "do_Request" && process.argv[i].split("=")[0] !== "Session" && process.argv[i].split("=")[0] !== "port" && process.argv[i].split("=")[0] !== "number_cluster_Workers") {
                    //         eval(process.argv[i] + ";");
                    //     };
                    //     if (process.argv[i].split("=")[0] === "port" && process.argv[i].split("=")[0] === "number_cluster_Workers") {
                    //         // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
                    //         eval(process.argv[i].split("=")[0]) = parseInt(process.argv[i].split('=')[1]);
                    //     };
                    //     if (process.argv[i].split("=")[0] === "Session") {
                    //         if (isStringJSON(process.argv[i].split('=')[1])) {
                    //             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
                    //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
                    //             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
                    //         } else {
                    //             eval(process.argv[i] + ";");
                    //         };
                    //     };
                    //     if (process.argv[i].split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
                    //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
                    //     } else {
                    //         do_Request = null;
                    //     };
                    //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
                    // } catch (error) {
                    //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
                    //     console.log(error);
                    // };
                    if (process.argv[i].split("=")[0] === "configFile") {
                        configFile = String(process.argv[i].split("=")[1]);  // 用於輸入運行參數的配置文檔路徑全名; // "C:/Criss/js/config.txt"; // "/home/Criss/js/config.txt";
                        // console.log("Config file: " + configFile);
                        break;
                    };
                    // switch (process.argv[i].split("=")[0]) {
                    //     case "configFile": {
                    //         configFile = String(process.argv[i].split("=")[1]);  // 用於輸入運行參數的配置文檔路徑全名; // "C:/Criss/js/config.txt"; // "/home/Criss/js/config.txt";
                    //         // console.log("Config file: " + configFile);
                    //         break;
                    //     }
                    //     default: {
                    //         // console.log("Don't recognize argument [ " + process.argv[i] + " ].");
                    //         break;
                    //     }
                    // };
                };
            };
        };
    };
};

// 讀取配置文檔（config.txt）裏的參數;
// "/home/StatisticalServer/StatisticalServerJavaScript/config.txt";
// "C:/StatisticalServer/StatisticalServerJavaScript/config.txt";
if (Object.prototype.toString.call(configFile).toLowerCase() === '[object string]' && configFile !== "") {

    // 同步判斷，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔;
    let file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
    try {
        // 同步判斷，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔;
        file_bool = fs.existsSync(configFile) && fs.statSync(configFile, { bigint: false }).isFile();
        // console.log("文檔: " + configFile + " 存在.");
    } catch (error) {
        console.error("Config file = [ " + String(configFile) + " ] unrecognized.");
        // console.error("無法確定用於輸入運行參數的配置文檔: " + configFile + " 是否存在.");
        console.error(error);
        // file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        // return configFile;
    };
    // 同步判斷，當用於輸入運行參數的配置文檔不存在時直接退出函數，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔;
    if (!file_bool) {
        console.log("Config file = [ " + String(configFile) + " ] absent.");
        // console.log("用於輸入運行參數的配置文檔 " + configFile + " 不存在.");
        // return configFile;
    };

    if (file_bool) {

        // 同步判斷文檔權限，後面所有代碼都是，當用於輸入運行參數的配置文檔存在時的動作，使用Node.js原生模組fs的fs.accessSync(configFile, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
        try {
            // 同步判斷文檔權限，使用Node.js原生模組fs的fs.accessSync(configFile, fs.constants.R_OK | fs.constants.W_OK)方法判斷文檔或目錄是否可讀fs.constants.R_OK、可寫fs.constants.W_OK、可執行fs.constants.X_OK;
            fs.accessSync(configFile, fs.constants.R_OK | fs.constants.W_OK);  // fs.constants.X_OK 可以被執行，fs.constants.F_OK 表明文檔對調用進程可見，即判斷文檔存在;
            // console.log("文檔: " + configFile + " 可以讀寫.");
        } catch (error) {
            // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫;
            try {
                // 同步修改文檔權限，使用Node.js原生模組fs的fs.fchmodSync(fd, mode)方法修改文檔或目錄操作權限為可讀可寫 0o777;
                fs.fchmodSync(configFile, fs.constants.S_IRWXO);  // 0o777 返回值為 undefined;
                // console.log("文檔: " + configFile + " 操作權限修改為可以讀寫.");
                // 常量                    八進制值    說明
                // fs.constants.S_IRUSR    0o400      所有者可讀
                // fs.constants.S_IWUSR    0o200      所有者可寫
                // fs.constants.S_IXUSR    0o100      所有者可執行或搜索
                // fs.constants.S_IRGRP    0o40       群組可讀
                // fs.constants.S_IWGRP    0o20       群組可寫
                // fs.constants.S_IXGRP    0o10       群組可執行或搜索
                // fs.constants.S_IROTH    0o4        其他人可讀
                // fs.constants.S_IWOTH    0o2        其他人可寫
                // fs.constants.S_IXOTH    0o1        其他人可執行或搜索
                // 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                // 數字	說明
                // 7	可讀、可寫、可執行
                // 6	可讀、可寫
                // 5	可讀、可執行
                // 4	唯讀
                // 3	可寫、可執行
                // 2	只寫
                // 1	只可執行
                // 0	沒有許可權
                // 例如，八進制值 0o765 表示：
                // 1) 、所有者可以讀取、寫入和執行該文檔；
                // 2) 、群組可以讀和寫入該文檔；
                // 3) 、其他人可以讀取和執行該文檔；
                // 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                // 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；
            } catch (error) {
                console.error("Config file = [ " + String(configFile) + " ] change the permissions mode=0o777 fail.");
                // console.error("用於輸入運行參數的配置文檔 [ " + configFile + " ] 無法修改為可讀可寫權限.");
                console.error(error);
                // file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
                // return configFile;
            };
        };

        file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
        try {
            // 同步判斷，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔以及是否具有可讀取權限;
            file_bool = fs.existsSync(configFile) && fs.statSync(configFile, { bigint: false }).isFile();
            // file_bool = fs.existsSync(configFile) && fs.statSync(configFile, { bigint: false }).isFile() && (fs.accessSync(configFile, fs.constants.R_OK) || fs.accessSync(configFile, fs.constants.R_OK | fs.constants.W_OK));
            // console.log("文檔: " + configFile + " 存在並可讀取.");
        } catch (error) {
            console.error("Config file = [ " + String(configFile) + " ] unrecognized or could not be read.");
            // console.error("無法確定用於輸入運行參數的配置文檔: " + configFile + " 是否存在或不可讀取.");
            console.error(error);
            // file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
            // return configFile;
        };

        // 同步判斷，當用於輸入運行參數的配置文檔不存在時直接退出函數，使用Node.js原生模組fs的fs.existsSync(configFile)方法判斷目錄或文檔是否存在以及是否為文檔;
        // if (fs.existsSync(configFile) && fs.statSync(configFile, { bigint: false }).isFile() && fs.accessSync(configFile, fs.constants.R_OK)) {
        if (file_bool) {

            // 同步讀取，用於輸入運行參數的配置文檔中的數據;
            try {

                let lines_String = "";  // 從輸入運行參數的配置文檔中讀取到的數據字符串;
                lines_String = fs.readFileSync(configFile, { encoding: "utf8", flag: "r" });
                // lines_String = fs.readFileSync(configFile, { encoding: "utf8", flag: "r+" });
                // // let buffer = new Buffer(8);
                // let buffer_data = fs.readFileSync(configFile, { encoding: null, flag: "r+" });
                // data_Str = buffer_data.toString("utf-8");  // 將Buffer轉換爲String;
                // // buffer_data = Buffer.from(data_Str, "utf-8");  // 將String轉換爲Buffer;
                // console.log(lines_String);

                console.log("Config file = " + String(configFile));

                let lines = new Array();  // 從輸入運行參數的配置文檔中讀取到的每一個橫向列的數據字符串組成的數組;
                if (Object.prototype.toString.call(lines_String).toLowerCase() === '[object string]' && lines_String !== "") {
                    // 判斷字符串是否包含換行符號（\r\n）;
                    if (lines_String.includes("\r\n")) {
                        lines = lines_String.split("\r\n");  // 刪除行尾的換行符（\r\n）;
                    } else if (lines_String.includes("\r")) {
                        lines = lines_String.split("\r");  // 刪除行尾的換行符（\r）;
                    } else if (lines_String.includes("\n")) {
                        lines = lines_String.split("\n");  // 刪除行尾的換行符（\n）;
                    } else {
                        lines.push(lines_String);
                        // lines.push(String(lines_String.trim()));
                    };
                };

                if (lines.length > 0) {
                    let line_I = parseInt(0);
                    for (let i = 0; i < lines.length; i++) {
                        // console.log(lines[i]);
                        let line = String(lines[i].trim());  // 刪除行首尾的空格字符（' '）;

                        line_I = parseInt(line_I) + parseInt(1);
                        let line_Key = "";
                        let line_Value = "";

                        if (Object.prototype.toString.call(line).toLowerCase() === '[object string]' && line !== "") {

                            // 判斷字符串是否含有等號字符（=）連接符（Key=Value），若含有等號字符（=），則以等號字符（=）分割字符串;
                            if (line.indexOf("=", 0) !== -1) {
                                if (Object.prototype.toString.call(line.split("=")[0]).toLowerCase() === '[object string]' && line.split("=")[0] !== "") {
                                    line_Key = String(line.split("=")[0].trim());  // 刪除字符串首尾的空格字符（' '）;
                                };
                                if (Object.prototype.toString.call(line.split("=")[1]).toLowerCase() === '[object string]' && line.split("=")[1] !== "") {
                                    line_Value = String(line.split("=")[1].trim());  // 刪除字符串首尾的空格字符（' '）;
                                };
                                // if (eval('typeof (' + line.split("=")[0] + ')' + ' === undefined && ' + line.split("=")[0] + ' === undefined')) {
                                //     // eval('var ' + line.split("=")[0] + ' = "";');
                                // } else {
                                //     // try {
                                //     //     if (line.split("=")[0] !== "do_Request" && line.split("=")[0] !== "Session" && line.split("=")[0] !== "port" && line.split("=")[0] !== "number_cluster_Workers") {
                                //     //         eval(line + ";");
                                //     //     };
                                //     //     if (line.split("=")[0] === "port" && line.split("=")[0] === "number_cluster_Workers") {
                                //     //         // CheckString(line.split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
                                //     //         eval(line.split("=")[0]) = parseInt(line.split('=')[1]);
                                //     //     };
                                //     //     if (line.split("=")[0] === "Session") {
                                //     //         if (isStringJSON(line.split('=')[1])) {
                                //     //             eval(line.split("=")[0]) = JSON.parse(line.split('=')[1]);
                                //     //         } else if (line.split('=')[1].indexOf(":", 0) !== -1) {
                                //     //             eval(line.split("=")[0])[line.split('=')[1].split(":")[0]] = line.split('=')[1].split(":")[1];
                                //     //         } else {
                                //     //             eval(line + ";");
                                //     //         };
                                //     //     };
                                //     //     if (line.split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(line.split("=")[0]) = eval(line.split('=')[1])).toLowerCase() === '[object function]') {
                                //     //         eval(line.split("=")[0]) = eval(line.split('=')[1]);
                                //     //     } else {
                                //     //         do_Request = null;
                                //     //     };
                                //     //     console.log(line.split("=")[0].concat(" = ", eval(line.split("=")[0])));
                                //     // } catch (error) {
                                //     //     console.log("Don't recognize argument [ " + line + " ].");
                                //     //     console.log(error);
                                //     // };
                                //     switch (line.split("=")[0]) {
                                //         case "configFile": {
                                //             configFile = String(line.split("=")[1]);  // 用於輸入運行參數的配置文檔路徑全名; // "C:/Criss/js/config.txt"; // "/home/Criss/js/config.txt";
                                //             // console.log("Config file: " + configFile);
                                //             break;
                                //         }
                                //         default: {
                                //             // console.log("Don't recognize argument [ " + line + " ].");
                                //             break;
                                //         }
                                //     };
                                // };
                            } else {
                                line_Value = String(line.trim());
                            };
                        };
                        // console.log(line_Key);
                        // console.log(line_Value);

                        // switch (line_Key) {
                        //     case "configFile": {
                        //         configFile = String(line_Value);  // 用於輸入運行參數的配置文檔路徑全名; // "C:/Criss/js/config.txt"; // "/home/Criss/js/config.txt";
                        //         // console.log("Config file: " + configFile);
                        //         break;
                        //     }
                        //     default: {
                        //         // console.log("Don't recognize argument [ " + line + " ].");
                        //         break;
                        //     }
                        // };
                        if (line_Key === "interface_Function") {
                            interface_Function_name_str = String(line_Value);
                            // "function() {};" 函數對象字符串，用於接收選擇啓動服務器類型的函數 "interface_Function";
                            if (line_Value === "file_Monitor" && Object.prototype.toString.call(interface_Function = eval("Interface_file_Monitor")).toLowerCase() === '[object function]') {
                                interface_Function = Interface_file_Monitor;  // 使用「Interface.js」模塊中的成員「file_Monitor(monitor_file, monitor_dir, do_Function_obj, return_obj, monitor, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value, temp_NodeJS_cache_IO_data_dir)」函數, 用於建立讀取硬盤文檔接口;
                                // interface_Function = eval(line_Value);
                                do_Function_name_str_data = "do_data";
                            } else if (line_Value === "http_Server" && Object.prototype.toString.call(interface_Function = eval("Interface_http_Server")).toLowerCase() === '[object function]') {
                                interface_Function = Interface_http_Server;  // 使用「Interface.js」模塊中的成員「http_Server(host, port, number_cluster_Workers, Key, Session, do_Function_JSON)」函數, 用於建立網卡http協議監聽服務器接口;
                                // interface_Function = eval(line_Value);
                                do_Function_name_str_data = "do_Request";
                            } else if (line_Value === "http_Client" && Object.prototype.toString.call(interface_Function = eval("Interface_http_Client")).toLowerCase() === '[object function]') {
                                interface_Function = Interface_http_Client;  // 使用「Interface.js」模塊中的成員「http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_JSON, callback)」函數, 用於建立網卡http協議客戶端請求接口;
                                // interface_Function = eval(line_Value);
                                do_Function_name_str_data = "do_Response";
                            } else {
                                // interface_Function = eval(line_Value);
                                interface_Function = null;
                                do_Function_name_str_data = "";
                            };
                            // console.log("interface Function: " + interface_Function_name_str);
                            continue;
                        };
                        // 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                        if (line_Key === "is_monitor") {
                            is_monitor = String(line_Value);  // "true" or "false";
                            // is_monitor = Boolean(line_Value);  // 使用 Boolean() 將字符串類型(String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 true or false";
                            // console.log("Is monitor: " + String(is_monitor));
                            continue;
                        };
                        if (line_Key === "monitor_file") {
                            monitor_file = String(line_Value);  // 用於接收傳值的媒介文檔 "../temp/intermediary_write_C.txt";
                            // console.log("Monitor file: " + monitor_file);
                            continue;
                        };
                        if (line_Key === "monitor_dir") {
                            monitor_dir = String(line_Value);  // 用於輸入傳值的媒介目錄 "../temp/"，當前路徑 __dirname ;
                            // console.log("Monitor directory: " + monitor_dir);
                            continue;
                        };
                        if (line_Key === "output_dir") {
                            output_dir = String(line_Value);  // 用於輸出傳值的媒介目錄 "../temp/"，當前路徑 __dirname ;
                            // console.log("Output directory: " + output_dir);
                            continue;
                        };
                        if (line_Key === "output_file") {
                            output_file = String(line_Value);  // 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Nodejs.txt";
                            // console.log("Output file: " + output_file);
                            continue;
                        };
                        if (line_Key === "temp_NodeJS_cache_IO_data_dir") {
                            temp_NodeJS_cache_IO_data_dir = String(line_Value);  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\"，當前路徑 __dirname ;
                            // console.log("Temporary cache IO data directory: " + temp_NodeJS_cache_IO_data_dir);
                            continue;
                        };
                        if (line_Key === "to_executable") {
                            to_executable = String(line_Value);  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
                            // console.log("To executable: " + to_executable);
                            continue;
                        };
                        if (line_Key === "to_script") {
                            to_script = String(line_Value);  // 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
                            // console.log("To script: " + to_script);
                            continue;
                        };
                        if (line_Key === "delay") {
                            delay = parseInt(line_Value);  // delay = 500; // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量，監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
                            // console.log("Delay: " + String(delay));
                            continue;
                        };
                        // if (line_Key === "is_Monitor_Concurrent") {
                        //     is_Monitor_Concurrent = String(line_Value);  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
                        //     // console.log("Is monitor concurrent: " + is_Monitor_Concurrent);
                        //     continue;
                        // };
                        if (line_Key === "number_Worker_threads") {
                            // CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
                            number_Worker_threads = parseInt(line_Value);  // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量;  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                            // console.log("Number worker threads: " + String(number_Worker_threads));
                            continue;
                        };
                        if (line_Key === "Worker_threads_Script_path") {
                            Worker_threads_Script_path = line_Value;  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
                            // console.log("Worker threads Script path: " + Worker_threads_Script_path);
                            continue;
                        };
                        if (line_Key === "Worker_threads_eval_value") {
                            Worker_threads_eval_value = Boolean(line_Value);  // 使用 Boolean() 將字符串類型(String)變量轉換為布爾型(Bool)的變量;  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
                            // console.log("Worker threads eval value: " + String(Worker_threads_eval_value));
                            continue;
                        };
                        if (line_Key === "do_Function") {
                            // "function() {};" 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
                            if (Object.prototype.toString.call(do_Function = eval(String(line_Value))).toLowerCase() === '[object function]') {
                                do_Function = eval(line_Value);
                                do_Function_name_str_data = "do_data";
                            } else {
                                do_Function = null;
                                do_Function_name_str_data = "";
                            };
                            // console.log("do Function: " + String(do_Function));
                            continue;
                        };
                        // 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
                        if (line_Key === "webPath") {
                            webPath = String(line_Value);  // 用於輸入服務器的根目錄 "../";
                            // console.log("http Server root directory: " + webPath);
                            continue;
                        };
                        if (line_Key === "Key") {
                            Key = String(line_Value);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                            // console.log("Server UserName and PassWord: " + Key);
                            continue;
                        };
                        if (line_Key === "host") {
                            host = String(line_Value);  // "::0" or "0.0.0.0" or "localhost"; 監聽主機域名;
                            // console.log("Host domain name: " + host);
                            Host = String(line_Value);  // "::1" or "127.0.0.1" or "localhost"; 請求主機域名;
                            // console.log("Host domain name: " + Host);
                            continue;
                        };
                        if (line_Key === "port") {
                            port = parseInt(line_Value);  // 8000; 監聽端口;  // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量;
                            // console.log("listening Port: " + port);
                            Port = parseInt(line_Value);  // 8000; 請求端口;  // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量;
                            // console.log("request Port: " + Port);
                            continue;
                        };
                        if (line_Key === "number_cluster_Workers") {
                            number_cluster_Workers = parseInt(line_Value);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目;  // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量;
                            // console.log("number cluster Workers: " + number_cluster_Workers);
                            continue;
                        };
                        if (line_Key === "Session") {
                            if (isStringJSON(line_Value)) {
                                Session = JSON.parse(line_Value);
                            } else if (line_Value.indexOf(":", 0) !== -1) {
                                Session[line_Value.split(":")[0]] = line_Value.split(":")[1];
                            } else {
                                Session = null;
                            };
                            // console.log("Server Session: " + Session);
                            continue;
                        };
                        if (line_Key === "do_Request") {
                            // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
                            if (Object.prototype.toString.call(do_Request = eval(line_Value)).toLowerCase() === '[object function]') {
                                do_Request = eval(line_Value);
                                do_Function_name_str_data = "do_Request";
                            } else {
                                do_Request = null;
                                do_Function_name_str_data = "";
                            };
                            // console.log("do_Request: " + do_Request);
                            continue;
                        };
                        // 接收當 interface_Function = Interface_http_Client 時的傳入參數值;
                        if (line_Key === "URL") {
                            URL = String(line_Value);  // "/";  // "http://[::1]:8000"  // "http://usename:password@[::1]:8000/";
                            // console.log("request uniform resource locator : " + URL);
                            continue;
                        };
                        if (line_Key === "Method") {
                            Method = String(line_Value);  // "POST" , "GET";  // 請求方法;
                            // console.log("request Method: " + Method);
                            continue;
                        };
                        if (line_Key === "time_out") {
                            time_out = parseInt(line_Value);  // time_out = 1000; // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量，設置鏈接超時自動中斷，單位毫秒（millisecond）;
                            // console.log("request time out : " + String(time_out));
                            continue;
                        };
                        if (line_Key === "request_Auth") {
                            request_Auth = String(line_Value);  // "username:password";  // 向服務器請求連接的驗證賬號密碼;
                            // console.log("request Authorization: " + request_Auth);
                            continue;
                        };
                        if (line_Key === "request_Cookie") {
                            request_Cookie = String(line_Value);  // "Session_ID=request_Key->username:password";  // 向服務器請求連接的驗證 Cookies 值;
                            // console.log("request Cookies: " + request_Cookie);
                            continue;
                        };
                        if (line_Key === "do_Response") {
                            // "function() {};" 函數對象字符串，用於接收執行響應數據（response）的函數 "do_Response";
                            if (Object.prototype.toString.call(do_Response = eval(line_Value)).toLowerCase() === '[object function]') {
                                do_Response = eval(line_Value);
                                do_Function_name_str_data = "do_Response";
                            } else {
                                do_Response = null;
                                do_Function_name_str_data = "";
                            };
                            // console.log("do Response: " + do_Response);
                            continue;
                        };
                        if (line_Key === "filePath") {
                            filePath = String(line_Value);  // "C:\Criss\js\"; 響應數據輸出寫入文檔;
                            // console.log("http Client Write file : " + filePath);
                            continue;
                        };
                    };
                };

            } catch (error) {
                console.log("Config file = [ " + String(configFile) + " ] could not be read.");
                // console.error("用於輸入運行參數的配置文檔: " + configFile + " 無法讀取.");
                console.error(error);
                // return configFile;
            };
        };

        // let now_date = String(new Date().toLocaleString('chinese', { hour12: false }));
        // let now_date = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
        // console.log(now_date);
    };
    file_bool = false;  // 用於判斷監聽文件夾和文檔是否存在及是否有權限讀寫操作;
    file_bool = null;  // 釋放内存;
};

// 控制臺傳參，通過 process.argv 數組獲取從控制臺傳入的參數;
// console.log(typeof(process.argv));
// console.log(process.argv);
// 使用 Object.prototype.toString.call(return_obj[key]).toLowerCase() === '[object string]' 方法判斷對象是否是一個字符串 typeof(str)==='String';
if (process.argv.length > 2) {
    for (let i = 0; i < process.argv.length; i++) {
        // console.log("argv" + i.toString() + " " + process.argv[i].toString());  // 通過 process.argv 數組獲取從控制臺傳入的參數;
        if (i > 1) {
            // 使用函數 Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' 判斷傳入的參數是否為 String 字符串類型 typeof(process.argv[i]);
            if (Object.prototype.toString.call(process.argv[i]).toLowerCase() === '[object string]' && process.argv[i] !== "" && process.argv[i].indexOf("=", 0) !== -1) {
                if (eval('typeof (' + process.argv[i].split("=")[0] + ')' + ' === undefined && ' + process.argv[i].split("=")[0] + ' === undefined')) {
                    // eval('var ' + process.argv[i].split("=")[0] + ' = "";');
                } else {
                    // try {
                    //     if (process.argv[i].split("=")[0] !== "do_Request" && process.argv[i].split("=")[0] !== "Session" && process.argv[i].split("=")[0] !== "port" && process.argv[i].split("=")[0] !== "number_cluster_Workers") {
                    //         eval(process.argv[i] + ";");
                    //     };
                    //     if (process.argv[i].split("=")[0] === "port" && process.argv[i].split("=")[0] === "number_cluster_Workers") {
                    //         // CheckString(process.argv[i].split('=')[1], 'positive_integer');  // 自定義函數檢查輸入合規性;
                    //         eval(process.argv[i].split("=")[0]) = parseInt(process.argv[i].split('=')[1]);
                    //     };
                    //     if (process.argv[i].split("=")[0] === "Session") {
                    //         if (isStringJSON(process.argv[i].split('=')[1])) {
                    //             eval(process.argv[i].split("=")[0]) = JSON.parse(process.argv[i].split('=')[1]);
                    //         } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
                    //             eval(process.argv[i].split("=")[0])[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
                    //         } else {
                    //             eval(process.argv[i] + ";");
                    //         };
                    //     };
                    //     if (process.argv[i].split("=")[0] === "do_Request" && Object.prototype.toString.call(eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
                    //         eval(process.argv[i].split("=")[0]) = eval(process.argv[i].split('=')[1]);
                    //     } else {
                    //         do_Request = null;
                    //     };
                    //     console.log(process.argv[i].split("=")[0].concat(" = ", eval(process.argv[i].split("=")[0])));
                    // } catch (error) {
                    //     console.log("Don't recognize argument [ " + process.argv[i] + " ].");
                    //     console.log(error);
                    // };
                    switch (process.argv[i].split("=")[0]) {
                        case "interface_Function": {
                            Key = String(process.argv[i].split("=")[1]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                            // console.log("Server UserName and PassWord: " + Key);
                            interface_Function_name_str = String(process.argv[i].split("=")[1]);
                            // "function() {};" 函數對象字符串，用於接收選擇啓動服務器類型的函數 "interface_Function";
                            if (process.argv[i].split("=")[1] === "file_Monitor" && Object.prototype.toString.call(interface_Function = eval("Interface_file_Monitor")).toLowerCase() === '[object function]') {
                                interface_Function = Interface_file_Monitor;  // 使用「Interface.js」模塊中的成員「file_Monitor(monitor_file, monitor_dir, do_Function_obj, return_obj, monitor, delay, number_Worker_threads, Worker_threads_Script_path, Worker_threads_eval_value, temp_NodeJS_cache_IO_data_dir)」函數, 用於建立讀取硬盤文檔接口;
                                // interface_Function = eval(process.argv[i].split("=")[1]);
                                do_Function_name_str_data = "do_data";
                            } else if (process.argv[i].split("=")[1] === "http_Server" && Object.prototype.toString.call(interface_Function = eval("Interface_http_Server")).toLowerCase() === '[object function]') {
                                interface_Function = Interface_http_Server;  // 使用「Interface.js」模塊中的成員「http_Server(host, port, number_cluster_Workers, Key, Session, do_Function_JSON)」函數, 用於建立網卡http協議監聽服務器接口;
                                // interface_Function = eval(process.argv[i].split("=")[1]);
                                do_Function_name_str_data = "do_Request";
                            } else if (process.argv[i].split("=")[1] === "http_Client" && Object.prototype.toString.call(interface_Function = eval("Interface_http_Client")).toLowerCase() === '[object function]') {
                                interface_Function = Interface_http_Client;  // 使用「Interface.js」模塊中的成員「http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_JSON, callback)」函數, 用於建立網卡http協議客戶端請求接口;
                                // interface_Function = eval(process.argv[i].split("=")[1]);
                                do_Function_name_str_data = "do_Response";
                            } else {
                                // interface_Function = eval(process.argv[i].split("=")[1]);
                                interface_Function = null;
                                do_Function_name_str_data = "";
                            };
                            // console.log("interface Function: " + interface_Function_name_str);
                            break;
                        }
                        // 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                        case "monitor_file": {
                            monitor_file = String(process.argv[i].split("=")[1]);  // 用於接收傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
                            // console.log("monitor file: " + monitor_file);
                            break;
                        }
                        case "monitor_dir": {
                            monitor_dir = String(process.argv[i].split("=")[1]);  // 用於輸入傳值的媒介目錄 "../temp/";
                            // console.log("monitor dir: " + monitor_dir);
                            break;
                        }
                        case "do_Function": {
                            // "function() {};" 函數對象字符串，用於接收執行數據處理功能的函數 "do_data";
                            if (Object.prototype.toString.call(do_Function = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
                                do_Function = eval(process.argv[i].split('=')[1]);
                            } else {
                                do_Function = null;
                            };
                            // console.log("do Function: " + do_Function);
                            break;
                        }
                        case "output_dir": {
                            output_dir = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介目錄 "../temp/";
                            // console.log("output dir: " + output_dir);
                            break;
                        }
                        case "output_file": {
                            output_file = String(process.argv[i].split("=")[1]);  // 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
                            // console.log("output file: " + output_file);
                            break;
                        }
                        case "to_executable": {
                            to_executable = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
                            // console.log("to executable: " + to_executable);
                            break;
                        }
                        case "to_script": {
                            to_script = String(process.argv[i].split("=")[1]);  // 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
                            // console.log("to script: " + to_script);
                            break;
                        }
                        case "temp_NodeJS_cache_IO_data_dir": {
                            temp_NodeJS_cache_IO_data_dir = String(process.argv[i].split("=")[1]);  // 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\";
                            // console.log("temp NodeJS cache Input/Output data dir: " + temp_NodeJS_cache_IO_data_dir);
                            break;
                        }
                        case "delay": {
                            delay = parseInt(process.argv[i].split("=")[1]);  // delay = 500;  // 監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
                            // console.log("delay: " + delay);
                            break;
                        }
                        // case "is_Monitor_Concurrent": {
                        //     is_Monitor_Concurrent = String(process.argv[i].split("=")[1]);  // "Multi-Threading"; # "Multi-Processes"; // 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）;
                        //     // console.log("is_Monitor_Concurrent: " + number_Worker_threads);
                        //     break;
                        // }
                        case "number_Worker_threads": {
                            CheckString(number_Worker_threads, 'arabic_numerals');  // 自定義函數檢查輸入合規性;
                            number_Worker_threads = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                            // console.log("number_Worker_threads: " + number_Worker_threads);
                            break;
                        }
                        case "Worker_threads_Script_path": {
                            Worker_threads_Script_path = process.argv[i].split("=")[1];  // process.argv[1] 配置子綫程運行時脚本參數 Worker_threads_Script_path 的值 new Worker(Worker_threads_Script_path, { eval: true });
                            // console.log("Worker threads Script path: " + Worker_threads_Script_path);
                            break;
                        }
                        case "Worker_threads_eval_value": {
                            Worker_threads_eval_value = Boolean(process.argv[i].split("=")[1]);  // true 配置子綫程運行時是以脚本形式啓動還是以代碼 eval(code) 的形式啓動的參數 Worker_threads_eval_value 的值 new Worker(Worker_threads_Script_path, { eval: true });
                            // console.log("Worker threads eval value: " + Worker_threads_eval_value);
                            break;
                        }
                        // 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
                        case "Key": {
                            Key = String(process.argv[i].split("=")[1]);  // "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
                            // console.log("Server UserName and PassWord: " + Key);
                            break;
                        }
                        case "host": {
                            host = String(process.argv[i].split("=")[1]);  // // "0.0.0.0" or "localhost"; 監聽主機域名;
                            // console.log("Host domain name: " + host);
                            Host = String(process.argv[i].split("=")[1]);  // "::1" or "127.0.0.1" or "localhost"; 請求主機域名;
                            // console.log("Host domain name: " + Host);
                            break;
                        }
                        case "port": {
                            port = parseInt(process.argv[i].split("=")[1]);  // 8000; 監聽端口;
                            // console.log("listening Port: " + port);
                            Port = parseInt(process.argv[i].split("=")[1]);  // 8000; 請求端口;
                            // console.log("request Port: " + Port);
                            break;
                        }
                        case "webPath": {
                            webPath = String(process.argv[i].split("=")[1]);  // "C:\Criss\js\"; 監聽端口;
                            // console.log("http Server root directory: " + webPath);
                            break;
                        }
                        case "number_cluster_Workers": {
                            number_cluster_Workers = parseInt(process.argv[i].split("=")[1]);  // os.cpus().length 使用"os"庫的方法獲取本機 CPU 數目;
                            // console.log("number cluster Workers: " + number_cluster_Workers);
                            break;
                        }
                        case "Session": {
                            if (isStringJSON(process.argv[i].split('=')[1])) {
                                Session = JSON.parse(process.argv[i].split('=')[1]);
                            } else if (process.argv[i].split('=')[1].indexOf(":", 0) !== -1) {
                                Session[process.argv[i].split('=')[1].split(":")[0]] = process.argv[i].split('=')[1].split(":")[1];
                            } else {
                                Session = null;
                            };
                            // console.log("Server Session: " + Session);
                            break;
                        }
                        case "do_Request": {
                            // "function() {};" 函數對象字符串，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request";
                            if (Object.prototype.toString.call(do_Request = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
                                do_Request = eval(process.argv[i].split('=')[1]);
                            } else {
                                do_Request = null;
                            };
                            // console.log("do_Request: " + do_Request);
                            break;
                        }
                        // 接收當 interface_Function = Interface_http_Client 時的傳入參數值;
                        case "URL": {
                            URL = String(process.argv[i].split("=")[1]);  // "/";  // "http://[::1]:8000"  // "http://usename:password@[::1]:8000/";
                            // console.log("request uniform resource locator : " + URL);
                            break;
                        }
                        case "Method": {
                            Method = String(process.argv[i].split("=")[1]);  // "POST" , "GET";  // 請求方法;
                            // console.log("request Method: " + Method);
                            break;
                        }
                        case "request_Auth": {
                            request_Auth = String(process.argv[i].split("=")[1]);  // "username:password";  // 向服務器請求連接的驗證賬號密碼;
                            // console.log("request Authorization: " + request_Auth);
                            break;
                        }
                        case "request_Cookie": {
                            request_Cookie = String(process.argv[i].split("=")[1]);  // "Session_ID=request_Key->username:password";  // 向服務器請求連接的驗證 Cookies 值;
                            // console.log("request Cookies: " + request_Cookie);
                            break;
                        }
                        case "time_out": {
                            time_out = parseInt(process.argv[i].split("=")[1]);  // time_out = 1000; // 使用 parseInt() 將字符串類型(String)變量轉換無符號的整型(Int)類型的變量，設置鏈接超時自動中斷，單位毫秒（millisecond）;
                            // console.log("request time out : " + String(time_out));
                            break;
                        }
                        case "do_Response": {
                            // "function() {};" 函數對象字符串，用於接收執行響應數據（response）的函數 "do_Response";
                            if (Object.prototype.toString.call(do_Response = eval(process.argv[i].split('=')[1])).toLowerCase() === '[object function]') {
                                do_Response = eval(process.argv[i].split('=')[1]);
                            } else {
                                do_Response = null;
                            };
                            // console.log("do Response: " + do_Response);
                            break;
                        }
                        case "filePath": {
                            filePath = String(process.argv[i].split("=")[1]);  // "C:\Criss\js\"; 響應數據輸出寫入文檔;
                            // console.log("http Client Write file : " + filePath);
                            break;
                        }
                        default: {
                            // console.log("Don't recognize argument [ " + process.argv[i] + " ].");
                            break;
                        }
                    };
                };
            };
        };
    };
};

let result_Array = new Array();
if (interface_Function_name_str === "Interface_File_Monitor") {
    if (require('worker_threads').isMainThread) {
        // const child_process = require('child_process');  // Node原生的創建子進程模組;
        // const os = require('os');  // Node原生的操作系統信息模組;
        // const net = require('net');  // Node原生的網卡網絡操作模組;
        // const http = require('http'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
        // const https = require('https'); // 導入 Node.js 原生的「http」模塊，「http」模組提供了 HTTP/1 協議的實現;
        // const qs = require('querystring');
        // const url = require('url'); // Node原生的網址（URL）字符串處理模組 url.parse(url,true);
        // const util = require('util');  // Node原生的模組，用於將異步函數配置成同步函數;
        // const fs = require('fs');  // Node原生的本地硬盤文件系統操作模組;
        // const path = require('path');  // Node原生的本地硬盤文件系統操路徑操作模組;
        // const readline = require('readline');  // Node原生的用於中斷進程，從控制臺讀取輸入參數驗證，然後再繼續執行進程;
        // const cluster = require('cluster');  // Node原生的支持多進程模組;
        // // const worker_threads = require('worker_threads');  // Node原生的支持多綫程模組;
        // const { Worker, MessagePort, MessageChannel, threadId, isMainThread, parentPort, workerData } = require('worker_threads');  // Node原生的支持多綫程模組 http://nodejs.cn/api/async_hooks.html#async_hooks_class_asyncresource;
        
        // // 可以先改變工作目錄到 static 路徑;
        // console.log('Starting directory: ' + process.cwd());
        // try {
        //     process.chdir('D:\\tmp\\');
        //     console.log('New directory: ' + process.cwd());
        // } catch (error) {
        //     console.log('chdir: ' + error);
        // };
    
        result_Array = interface_Function({
            "is_monitor": is_monitor,
            "monitor_file": monitor_file,
            "monitor_dir": monitor_dir,
            "do_Function": do_Function_data,
            "output_dir": output_dir,
            "output_file": output_file,
            "to_executable": to_executable,
            "to_script": to_script,
            "delay": delay,
            "number_Worker_threads": number_Worker_threads,
            "Worker_threads_Script_path": Worker_threads_Script_path,
            "Worker_threads_eval_value": Worker_threads_eval_value,
            "temp_NodeJS_cache_IO_data_dir": temp_NodeJS_cache_IO_data_dir
        });
        // result_Array = interface_Function({
        //     "is_monitor": is_monitor,
        //     "monitor_file": monitor_file,
        //     "do_Function": do_Function_data,
        //     "output_file": output_file,
        // });
    };
} else if (interface_Function_name_str === "Interface_http_Server") {
    result_Array = interface_Function({
        "host": host,
        "port": port,
        "number_cluster_Workers": number_cluster_Workers,
        "Key": Key,
        "Session": Session,
        "do_Request": do_Function_Request,
        "exclusive": exclusive,
        "backlog": backlog,
        "readableAll": readableAll,
        "writableAll": writableAll,
        "ipv6Only": ipv6Only
    });
    // result_Array = interface_Function({
    //     "do_Request": do_Function_Request,
    //     "Session": Session,
    //     "Key": Key,
    //     "number_cluster_Workers": number_cluster_Workers,
    // });
} else if (interface_Function_name_str === "Interface_http_Client") {
    interface_Function({
        "Host": Host,
        "Port": Port,
        "URL": URL,
        "Method": Method,
        "time_out": time_out,
        "request_Auth": request_Auth,
        "request_Cookie": request_Cookie,
        "post_Data_String": post_Data_String
    }, (error, response) => {
        // console.log(typeof(response));  // Array;
        // console.log(response);

        let response_status_String = response[0];
        console.log(response_status_String);
        let response_head_String = response[1];
        console.log(response_head_String);

        let response_body_String = response[2];
        console.log(response_body_String);
        // response_body_String = {
        //     "request Nikename": request_Nikename,
        //     "request Passwork": request_Password,
        //     "request_Authorization": Key,  // "username:password";
        //     "Server_say": "Fine, thank you, and you ?",
        //     "time": "2021-02-03 20:21:25.136"
        // };

        result_Array = response
        // result_text = ['code:0', JSON.stringify(result_Array)].join("\n");
        // result_text = JSON.stringify(result_Array);
        result_text = "code:0";

        // // 自定義函數判斷子進程 Python 服務器返回值 response_body 是否為一個 JSON 格式的字符串;
        // let data_JSON = {};
        // if (isStringJSON(response_body_String)) {
        //     data_JSON = JSON.parse(response_body_String);
        // } else {
        //     data_JSON = {
        //         "Server_say": response_body_String
        //     };
        // };

        // console.log("Server say: " + data_JSON["Server_say"]);
    });
} else {};
// console.log(typeof(result_Array));  // Array;
// console.log(result_Array[0]);

// let nowDate = new Date();
// let time = nowDate.getFullYear() + "-" + (parseInt(nowDate.getMonth()) + parseInt(1)).toString() + "-" + nowDate.getDate() + "-" + nowDate.getHours() + "-" + nowDate.getMinutes() + "-" + nowDate.getSeconds() + "-" + nowDate.getMilliseconds();
// console.log(new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds());
let return_file_creat_time = new Date().getFullYear() + "-" + new Date().getMonth() + 1 + "-" + new Date().getDate() + " " + new Date().getHours() + ":" + new Date().getMinutes() + ":" + new Date().getSeconds() + "." + new Date().getMilliseconds();
// let return_file_creat_time = new Date().toLocaleString('chinese', { hour12: false });
// console.log(String(return_file_creat_time));

let result_text = "";
if (interface_Function_name_str === "Interface_File_Monitor") {

    if (is_monitor === true) {
        result_text = "code:0";
    };

    if (is_monitor === false) {
        if (Object.prototype.toString.call(result_Array).toLowerCase() === '[object array]' && result_Array.length === 3 && Object.prototype.toString.call(result_Array[1]).toLowerCase() === '[object string]' && Object.prototype.toString.call(result_Array[2]).toLowerCase() === '[object string]' && Object.prototype.toString.call(do_Function_name_str_data).toLowerCase() === '[object string]' && do_Function_name_str_data !== "") {
            let return_info_JSON = {
                "NodeJS_say": {
                    "output_file": String(result_Array[1]),
                    "monitor_file": String(result_Array[2]),
                    "do_Function": String(do_Function_name_str_data)
                },
                "time": String(return_file_creat_time)
            };  // '{"NodeJS_say":{"output_file":"' + String(result_Array[2]) + '","monitor_file":"' + String(result_Array[3]) + '","do_Function":"' + String(do_Function_name_str_data) + '"},"time":"' + String(return_file_creat_time) + '"}'
            result_text = ['code:0', JSON.stringify(return_info_JSON)].join("\n");
        } else if (Object.prototype.toString.call(result_Array).toLowerCase() === '[object array]' && result_Array.length === 3 && Object.prototype.toString.call(result_Array[1]).toLowerCase() === '[object string]' && Object.prototype.toString.call(result_Array[2]).toLowerCase() === '[object string]') {
            let return_info_JSON = {
                "NodeJS_say": {
                    "output_file": String(result_Array[1]),
                    "monitor_file": String(result_Array[2]),
                    "do_Function": ""
                },
                "time": String(return_file_creat_time)
            };  // '{"NodeJS_say":{"output_file":"' + String(result_Array[2]) + '","monitor_file":"' + String(result_Array[3]) + '","do_Function":""},"time":"' + String(return_file_creat_time) + '"}'
            result_text = ['code:0', JSON.stringify(return_info_JSON)].join("\n");
        } else {
            result_text = "code:-1";
        };
    };
} else if (interface_Function_name_str === "Interface_http_Server") {
    result_text = "code:0";
} else if (interface_Function_name_str === "Interface_http_Client") {
    // console.log(typeof(result_Array));  # Array;
    // console.log(result_Array[0]);
    // console.log(result_Array[1]);
    // console.log(result_Array[2]);
    // result_text = ['code:0', JSON.stringify(result_Array)].join("\n");
    // result_text = JSON.stringify(result_Array);
    result_text = "code:0";
} else {};

// 將運算結果保存的目標文檔的信息，寫入控制臺標準輸出（顯示器），便於使主調程序獲取完成信號;
console.log(result_text);  // 將運算結果寫到操作系統控制臺;
// process.exit(0); // 停止運行，退出 Node.js 解釋器;
