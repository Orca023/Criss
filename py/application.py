# !/usr/bin/python3
# coding=utf-8


#################################################################################

# Title: Python3 server v20161211
# Explain: Python3 file server, Python3 http server, Python3 http client
# Author: 趙健
# E-mail: 283640621@qq.com
# Telephont number: +86 18604537694
# E-mail: chinaorcaz@gmail.com
# Date: 歲在丙申
# Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30
# Interpreter: python-3.11.2-amd64.exe
# Interpreter: Python-3.11.2-tar.xz, Python-3.11.2-amd64.deb
# Operating system: google-pixel-2 android-11 termux-0.118 ubuntu-22.04-LTS-rootfs arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280
# Interpreter: Python-3.10.6-tar.xz, python3-3.10.6-aarch64.deb

# 使用説明：
# 控制臺命令列運行指令：
# C:\Criss> C:/Criss/Python/Python311/python.exe C:/Criss/py/application.py configFile=C:/Criss/config.txt interface_Function=file_Monitor webPath=C:/Criss/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=0 is_monitor=False time_sleep=0.02 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=C:/Criss/temp/
# root@localhost:~# /usr/bin/python3 /home/Criss/py/application.py configFile=/home/Criss/config.txt interface_Function=file_Monitor webPath=/home/Criss/html/ host=::0 port=10001 Key=username:password Is_multi_thread=False number_Worker_process=0 is_Monitor_Concurrent=0 is_monitor=False time_sleep=0.02 monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/home/Criss/temp/

#################################################################################


# import platform  # 加載Python原生的與平臺屬性有關的模組;
import os, sys, signal, stat  # 加載Python原生的操作系統接口模組os、使用或維護的變量的接口模組sys;
# import inspect  # from inspect import isfunction 加載Python原生的模組、用於判斷對象是否為函數類型;
# import subprocess  # 加載Python原生的創建子進程模組;
import string  # 加載Python原生的字符串處理模組;
import datetime, time  # 加載Python原生的日期數據處理模組;
import json  # import the module of json. 加載Python原生的Json處理模組;
# import re  # 加載Python原生的正則表達式對象
# from tempfile import TemporaryFile, TemporaryDirectory, NamedTemporaryFile  # 用於創建臨時目錄和臨時文檔;
import pathlib  # from pathlib import Path 用於檢查判斷指定的路徑對象是目錄還是文檔;
import struct  # 用於讀、寫、操作二進制本地硬盤文檔;
import shutil  # 用於刪除完整硬盤目錄樹，清空文件夾;
# import multiprocessing  # 加載Python原生的支持多進程模組 from multiprocessing import Process, Pool;
# import threading  # 加載Python原生的支持多綫程（執行緒）模組;
# from socketserver import ThreadingMixIn  #, ForkingMixIn
# import inspect, ctypes  # 用於强制終止綫程;
# import urllib  # 加載Python原生的創建客戶端訪問請求連接模組，urllib 用於對 URL 進行編解碼;
# import http.client  # 加載Python原生的創建客戶端訪問請求連接模組;
# from http.server import HTTPServer, BaseHTTPRequestHandler  # 加載Python原生的創建簡單http服務器模組;
# # https: // docs.python.org/3/library/http.server.html
# from http import cookiejar  # 用於處理請求Cookie;
# import socket  # 加載Python原生的套接字模組socket、配置服務器支持 IPv6 格式地址;
# import ssl  # 用於處理請求證書驗證;
import base64  # 加載加、解密模組;
# 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
# base64.b64encode(s, altchars=None)
# 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
# base64.b64decode(s, altchars=None, validate=False)
import math  # 導入 Python 原生包「math」，用於數學計算;

# # 棄用控制臺打印警告信息;
# def fxn():
#     warnings.warn("deprecated", DeprecationWarning)  # 棄用控制臺打印警告信息;
# with warnings.catch_warnings():
#     warnings.simplefilter("ignore")
#     fxn()
# with warnings.catch_warnings(record=True) as w:
#     # Cause all warnings to always be triggered.
#     warnings.simplefilter("always")
#     # Trigger a warning.
#     fxn()
#     # Verify some things
#     assert len(w) == 1
#     assert issubclass(w[-1].category, DeprecationWarning)
#     assert "deprecated" in str(w[-1].message)

# 匯入自定義路由模組脚本文檔「./Interface.py」;
# os.getcwd() # 獲取當前工作目錄路徑;
# os.path.realpath(__file__) # 當前脚本（.py）文檔路徑全名;
# os.path.dirname(os.path.realpath(__file__)) # 當前脚本（.py）文檔所在的目錄全名;
# os.path.dirname(os.path.dirname(os.path.realpath(__file__))) # 當前脚本（.py）文檔所在的目錄的上一層父目錄全名;
# os.path.abspath("..")  # 當前運行脚本所在目錄上一層的絕對路徑;
# os.path.join(os.path.abspath("."), 'Interface.py')  # 拼接路徑字符串;
# pathlib.Path(os.path.join(os.path.abspath("."), Interface.py)  # 返回路徑對象;
# sys.path.append(os.path.abspath(".."))  # 將上一層目錄加入系統的搜索清單，當導入脚本時會增加搜索這個自定義添加的路徑;
import Interface as Interface  # 導入當前運行代碼所在目錄的，自定義脚本文檔「./Interface.py」;
# 注意導入本地 Python 脚本，只寫文檔名不要加文檔的擴展名「.py」，如果不使用 sys.path.append() 函數添加自定義其它的搜索路徑，則只能放在當前的工作目錄「"."」
Interface_File_Monitor = Interface.File_Monitor
Interface_http_Server = Interface.http_Server
Interface_http_Client = Interface.http_Client
check_json_format = Interface.check_json_format
win_file_is_Used = Interface.win_file_is_Used
clear_Directory = Interface.clear_Directory
formatByte = Interface.formatByte



# 示例函數，處理從硬盤文檔讀取到的字符串數據，然後返回處理之後的結果字符串數據的;
def do_data(require_data_String):

    # print(require_data_String)
    # print(typeof(require_data_String))

    # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    if check_json_format(require_data_String):
        # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
        require_data_JSON = json.loads(require_data_String)  # , encoding='utf-8'
    else:
        now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
        require_data_JSON = {
            "Client_say": require_data_String,
            "time": str(now_date)
        }
    # print(require_data_JSON)
    # print(typeof(require_data_JSON))

    Client_say = ""
    # 使用函數 isinstance(require_data_JSON, dict) 判斷傳入的參數 require_data_JSON 是否為 dict 字典（JSON）格式對象;
    if isinstance(require_data_JSON, dict):
        # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
        if (require_data_JSON.__contains__("Client_say")):
            Client_say = require_data_JSON["Client_say"]
        else:
            Client_say = ""
            # print('客戶端發送的請求 JSON 對象中無法找到目標鍵(key)信息 ["Client_say"].')
            # print(require_data_JSON)
    else:
        Client_say = require_data_JSON

    Server_say = Client_say  # "require no problem."
    # if Client_say == "How are you" or Client_say == "How are you." or Client_say == "How are you!" or Client_say == "How are you !":
    #     Server_say = "Fine, thank you, and you ?"
    # else:
    #     Server_say = "我現在只會説：「 Fine, thank you, and you ? 」，您就不能按規矩說一個：「 How are you ! 」"
    # Server_say = Server_say.decoding("utf-8")

    now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    # print(now_date)
    response_data_JSON = {
        "Server_say": Server_say,
        "require_Authorization": "",
        "time": str(now_date)
    }
    # check_json_format(request_data_JSON);
    # String = json.dumps(JSON); JSON = json.loads(String);

    response_data_String = Server_say
    if isinstance(response_data_JSON, dict):
        response_data_String = json.dumps(response_data_JSON)  # 將JOSN對象轉換為JSON字符串;

    # response_data_String = str(rresponse_data_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
    # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
    response_data_bytes = response_data_String.encode("utf-8")
    response_data_String_len = len(bytes(response_data_String, "utf-8"))

    return response_data_String


# 示例函數，用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
def read_and_write_file_do_Function(monitor_file, monitor_dir, do_Function, output_dir, output_file, to_executable, to_script, time_sleep):

    # print("當前進程ID: ", multiprocessing.current_process().pid)
    # print("當前進程名稱: ", multiprocessing.current_process().name)
    # print("當前綫程ID: ", threading.currentThread().ident)
    # print("當前綫程名稱: ", threading.currentThread().getName())  # threading.currentThread() 表示返回當前綫程變量;
    if monitor_dir == "" or monitor_file == "" or monitor_file.find(monitor_dir, 0, int(len(monitor_file)-1)) == -1 or output_dir == "" or output_file == "" or output_file.find(output_dir, 0, int(len(output_file)-1)) == -1:
        return (monitor_dir, monitor_file, output_dir, output_file)

    # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
    # os.listdir(monitor_dir)  # 刷新目錄内容列表
    # print(os.listdir(monitor_dir))
    # 使用Python原生模組os判斷目錄或文檔是否存在以及是否為文檔;
    if not(os.path.exists(monitor_file) and os.path.isfile(monitor_file)):
        return monitor_file

    # 用於讀取或刪除文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
    if time_sleep != None and time_sleep != "" and isinstance(time_sleep, str):
        time_sleep = float(time_sleep)  # 延遲時長單位秒;

    # 使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
    if os.path.exists(monitor_dir) and pathlib.Path(monitor_dir).is_dir():
        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
        if not (os.access(monitor_dir, os.R_OK) and os.access(monitor_dir, os.W_OK)):
            try:
                # 修改文檔權限 mode:777 任何人可讀寫;
                os.chmod(monitor_dir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                # os.chmod(monitor_dir, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                # os.chmod(monitor_dir, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                # os.chmod(monitor_dir, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                # os.chmod(monitor_dir, stat.S_IWOTH)  # 可被其它用戶寫入;
                # stat.S_IXOTH:  其他用戶有執行權0o001
                # stat.S_IWOTH:  其他用戶有寫許可權0o002
                # stat.S_IROTH:  其他用戶有讀許可權0o004
                # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                # stat.S_IXGRP:  組用戶有執行許可權0o010
                # stat.S_IWGRP:  組用戶有寫許可權0o020
                # stat.S_IRGRP:  組用戶有讀許可權0o040
                # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                # stat.S_IXUSR:  擁有者具有執行許可權0o100
                # stat.S_IWUSR:  擁有者具有寫許可權0o200
                # stat.S_IRUSR:  擁有者具有讀許可權0o400
                # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                # stat.S_IREAD:  windows下設為唯讀
                # stat.S_IWRITE: windows下取消唯讀
            except OSError as error:
                print(f'Error: {monitor_dir} : {error.strerror}')
                print("用於輸入傳值的媒介文件夾 [ " + monitor_dir + " ] 無法修改為可讀可寫權限.")
                return monitor_dir
    else:
        try:
            # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
            # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
            os.makedirs(monitor_dir, mode=0o777, exist_ok=True)
        except FileExistsError as error:
            # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
            print(f'Error: {monitor_dir} : {error.strerror}')
            print("用於輸入傳值的媒介文件夾 [ " + monitor_dir + " ] 無法創建.")
            return monitor_dir

    if not (os.path.exists(monitor_dir) and pathlib.Path(monitor_dir).is_dir()):
        print(f'Error: {monitor_dir} : {error.strerror}')
        print("用於輸入傳值的媒介文件夾 [ " + monitor_dir + " ] 無法創建.")
        return monitor_dir

    data_Str = ""
    # print(monitor_file, "is a file 是一個文檔.")
    # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
    if not (os.access(monitor_file, os.R_OK) and os.access(monitor_file, os.W_OK)):
        try:
            # 修改文檔權限 mode:777 任何人可讀寫;
            os.chmod(monitor_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
            # os.chmod(monitor_file, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
            # os.chmod(monitor_file, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
            # os.chmod(monitor_file, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
            # os.chmod(monitor_file, stat.S_IWOTH)  # 可被其它用戶寫入;
            # stat.S_IXOTH:  其他用戶有執行權0o001
            # stat.S_IWOTH:  其他用戶有寫許可權0o002
            # stat.S_IROTH:  其他用戶有讀許可權0o004
            # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
            # stat.S_IXGRP:  組用戶有執行許可權0o010
            # stat.S_IWGRP:  組用戶有寫許可權0o020
            # stat.S_IRGRP:  組用戶有讀許可權0o040
            # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
            # stat.S_IXUSR:  擁有者具有執行許可權0o100
            # stat.S_IWUSR:  擁有者具有寫許可權0o200
            # stat.S_IRUSR:  擁有者具有讀許可權0o400
            # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
            # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
            # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
            # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
            # stat.S_IREAD:  windows下設為唯讀
            # stat.S_IWRITE: windows下取消唯讀
        except OSError as error:
            print(f'Error: {monitor_file} : {error.strerror}')
            print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法修改為可讀可寫權限.")
            return monitor_file

    fd = open(monitor_file, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
    # fd = open(monitor_file, mode="rb+")
    try:
        data_Str = fd.read()
        # data_Str = fd.read().decode("utf-8")
        # data_Bytes = data_Str.encode("utf-8")
        # fd.write(data_Bytes)
    except FileNotFoundError:
        print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 不存在.")
    # except PersmissionError:
    #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 沒有打開權限.")
    except Exception as error:
        if("[WinError 32]" in str(error)):
            print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法讀取數據.")
            print(f'Error: {monitor_file} : {error.strerror}')
            print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試讀取文檔 " + monitor_file)
            time.sleep(time_sleep)  # 用於讀取文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
            try:
                data_Str = fd.read()
                # data_Str = fd.read().decode("utf-8")
                # data_Bytes = data_Str.encode("utf-8")
                # fd.write(data_Bytes)
            except OSError as error:
                print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法讀取數據.")
                print(f'Error: {monitor_file} : {error.strerror}')
        else:
            print(f'Error: {monitor_file} : {error.strerror}')
    finally:
        fd.close()
    # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

    # # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔;
    # try:
    #     os.remove(monitor_file)  # os.unlink(monitor_file) 刪除文檔 monitor_file;
    #     # os.listdir(monitor_dir)  # 刷新目錄内容列表
    #     # print(os.listdir(monitor_dir))
    # except Exception as error:
    #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
    #     print(f'Error: {monitor_file} : {error.strerror}')
    #     if("[WinError 32]" in str(error)):
    #         print("延時等待 " + str(time_sleep) + " (秒)後, 重複嘗試刪除文檔 " + monitor_file)
    #         time.sleep(time_sleep)  # 用於刪除文檔時延遲參數，以防文檔被占用錯誤，單位（秒）;
    #         try:
    #             # os.unlink(monitor_file) 刪除文檔 monitor_file;
    #             os.remove(monitor_file)
    #             # os.listdir(monitor_dir)  # 刷新目錄内容列表
    #             # print(os.listdir(monitor_dir))
    #         except OSError as error:
    #             print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
    #             print(f'Error: {monitor_file} : {error.strerror}')
    #     # else:
    #     #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
    #     #     print(f'Error: {monitor_file} : {error.strerror}')

    # # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
    # if os.path.exists(monitor_file) and os.path.isfile(monitor_file):
    #     print("用於接收傳值的媒介文檔 [ " + monitor_file + " ] 無法刪除.")
    #     return monitor_file

    # 將從用於傳入的媒介文檔 monitor_file 讀取到的數據，傳入自定義函數 do_Function 處理，處理後的結果寫入傳出媒介文檔 output_file;
    if do_Function != None and hasattr(do_Function, '__call__'):
        # hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False，或者使用 inspect.isfunction(do_Function) 判斷是否為函數;
        response_data_String = do_Function(data_Str)
    else:
        response_data_String = data_Str

    # # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # 打印當前日期時間 time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())， after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f");
    # response_data_JSON = {
    #     "Server_say": "",
    #     "require_Authorization": "",
    #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    # }
    # # print(data_Str)
    # # print(typeof(data_Str))
    # if data_Str != "":
    #     # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    #     if self.check_json_format(data_Str):
    #         # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
    #         require_data_JSON = json.loads(data_Str)  # , encoding='utf-8'
    #     else:
    #         now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    #         require_data_JSON = {
    #             "Client_say": data_Str,
    #             "time": str(now_date)
    #         }
    #     # print(require_data_JSON)
    #     # print(typeof(require_data_JSON))

    #     if do_Function != None and hasattr(do_Function, '__call__'):
    #         # hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
    #         response_data_JSON["Server_say"] = do_Function(require_data_JSON)["Server_say"]
    #     else:
    #         response_data_JSON["Server_say"] = data_Str

    # else:
    #     response_data_JSON["Server_say"] = ""

    # response_data_String = json.dumps(response_data_JSON)  # 將JOSN對象轉換為JSON字符串;
    # # response_data_String = str(rresponse_data_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
    # # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
    response_data_bytes = response_data_String.encode("utf-8")
    response_data_String_len = len(bytes(response_data_String, "utf-8"))

    # 使用Python原生模組os判斷指定的用於輸出傳值的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
    if os.path.exists(output_dir) and pathlib.Path(output_dir).is_dir():
        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
        if not (os.access(output_dir, os.R_OK) and os.access(output_dir, os.W_OK)):
            try:
                # 修改文檔權限 mode:777 任何人可讀寫;
                os.chmod(output_dir, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                # os.chmod(output_dir, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                # os.chmod(output_dir, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                # os.chmod(output_dir, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                # os.chmod(output_dir, stat.S_IWOTH)  # 可被其它用戶寫入;
                # stat.S_IXOTH:  其他用戶有執行權0o001
                # stat.S_IWOTH:  其他用戶有寫許可權0o002
                # stat.S_IROTH:  其他用戶有讀許可權0o004
                # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                # stat.S_IXGRP:  組用戶有執行許可權0o010
                # stat.S_IWGRP:  組用戶有寫許可權0o020
                # stat.S_IRGRP:  組用戶有讀許可權0o040
                # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                # stat.S_IXUSR:  擁有者具有執行許可權0o100
                # stat.S_IWUSR:  擁有者具有寫許可權0o200
                # stat.S_IRUSR:  擁有者具有讀許可權0o400
                # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                # stat.S_IREAD:  windows下設為唯讀
                # stat.S_IWRITE: windows下取消唯讀
            except OSError as error:
                print(f'Error: {output_dir} : {error.strerror}')
                print("用於輸出傳值的媒介文件夾 [ " + output_dir + " ] 無法修改為可讀可寫權限.")
                return output_dir
    else:
        try:
            # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
            # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
            os.makedirs(output_dir, mode=0o777, exist_ok=True)
        except FileExistsError as error:
            # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
            print(f'Error: {output_dir} : {error.strerror}')
            print("用於傳值的媒介文件夾 [ " + output_dir + " ] 無法創建.")
            return output_dir

    if not (os.path.exists(output_dir) and pathlib.Path(output_dir).is_dir()):
        print(f'Error: {output_dir} : {error.strerror}')
        print("用於輸出傳值的媒介文件夾 [ " + output_dir + " ] 無法創建.")
        return output_dir

    # 判斷用於輸出傳值的媒介文檔，是否已經存在且是否為文檔，如果已存在則從硬盤刪除，然後重新創建並寫入新值;
    if os.path.exists(output_file) and os.path.isfile(output_file):
        # print(output_file, "is a file 是一個文檔.")
        # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
        if not (os.access(output_file, os.R_OK) and os.access(output_file, os.W_OK)):
            try:
                # 修改文檔權限 mode:777 任何人可讀寫;
                os.chmod(output_file, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                # os.chmod(output_file, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                # os.chmod(output_file, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                # os.chmod(output_file, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                # os.chmod(output_file, stat.S_IWOTH)  # 可被其它用戶寫入;
                # stat.S_IXOTH:  其他用戶有執行權0o001
                # stat.S_IWOTH:  其他用戶有寫許可權0o002
                # stat.S_IROTH:  其他用戶有讀許可權0o004
                # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                # stat.S_IXGRP:  組用戶有執行許可權0o010
                # stat.S_IWGRP:  組用戶有寫許可權0o020
                # stat.S_IRGRP:  組用戶有讀許可權0o040
                # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                # stat.S_IXUSR:  擁有者具有執行許可權0o100
                # stat.S_IWUSR:  擁有者具有寫許可權0o200
                # stat.S_IRUSR:  擁有者具有讀許可權0o400
                # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                # stat.S_IREAD:  windows下設為唯讀
                # stat.S_IWRITE: windows下取消唯讀
            except OSError as error:
                print(f'Error: {output_file} : {error.strerror}')
                print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 已存在且無法修改為可讀可寫權限.")
                return output_file

        # 讀取到輸入數據之後，刪除用於接收傳值的媒介文檔;
        try:
            os.remove(output_file)  # 刪除文檔
        except OSError as error:
            print(f'Error: {output_file} : {error.strerror}')
            print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 已存在且無法刪除，以重新創建更新數據.")
            return output_file

        # 判斷用於接收傳值的媒介文檔，是否已經從硬盤刪除;
        if os.path.exists(output_file) and os.path.isfile(output_file):
            print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 已存在且無法刪除，以重新創建更新數據.")
            return output_file

    # 以可寫方式打開硬盤文檔，如果文檔不存在，則會自動創建一個文檔;
    fd = open(output_file, mode="w+", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
    # fd = open(output_file, mode="wb+")
    try:
        fd.write(response_data_String)
        # response_data_bytes = response_data_String.encode("utf-8")
        # response_data_String_len = len(bytes(response_data_String, "utf-8"))
        # fd.write(response_data_bytes)
    except FileNotFoundError:
        print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 創建失敗.")
        return output_file
    # except PersmissionError:
    #     print("用於輸出傳值的媒介文檔 [ " + output_file + " ] 沒有打開權限.")
    #     return output_file
    finally:
        fd.close()
    # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

    # # 運算處理完之後，給調用語言的回復，os.access(to_script, os.X_OK) 判斷脚本文檔是否具有被執行權限;
    # if type(to_executable) == str and to_executable != "" and os.path.exists(to_executable) and os.path.isfile(to_executable) and os.access(to_executable, os.X_OK):
    #     if type(to_script) == str and to_script != "" and os.path.exists(to_script) and os.path.isfile(to_script):
    #         # node  環境;
    #         # test.js  待執行的JS的檔;
    #         # %s %s  傳遞給JS檔的參數;
    #         # shell_to = os.popen('node test.js %s %s' % (1, 2))  執行shell命令，拿到輸出結果;
    #         shell_to = os.popen('%s %s %s %s %s %s' % (to_executable, to_script, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;
    #         # // JavaScript 脚本代碼使用 process.argv 傳遞給Node.JS的參數 [nodePath, jsPath, arg1, arg2, ...];
    #         # let arg1 = process.argv[2];  // 解析出JS參數;
    #         # let arg2 = process.argv[3];
    #     else:
    #         shell_to = os.popen('%s %s %s %s %s' % (to_executable, output_dir, output_file, monitor_dir, monitor_file))  # 執行shell命令，拿到輸出結果;

    #     # print(shell_to.readlines());
    #     result = shell_to.read()  # 取出執行結果
    #     # print(result)

    return (response_data_String, output_file, monitor_file)


# # 使用示例，自定義類 File_Monitor 硬盤文檔監聽看守進程使用説明;
# if __name__ == '__main__':
#     # os.chdir(monitor_dir)  # 可以先改變工作目錄到 static 路徑;
#     try:
#         monitor_dir = os.path.join(os.path.abspath(".."), "/temp/")  # "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸入傳值的媒介目錄;
#         # monitor_dir = pathlib.Path(os.path.abspath("..") + "/temp/")  # pathlib.Path("../temp/")
#         monitor_file = os.path.join(monitor_dir, "intermediary_write_Node.txt")  # "../temp/intermediary_write_Node.txt" 用於接收傳值的媒介文檔;
#         # os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
#         # os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
#         temp_cache_IO_data_dir = os.path.join(os.path.abspath(".."), "/temp/")  # "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
#         number_Worker_process = int(1)  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
#         read_file_do_Function = read_and_write_file_do_Function  # None 或自定義的示例函數 read_and_write_file_do_Function，用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
#         do_Function = do_data  # 用於接收執行功能的函數;
#         do_Function_obj = {
#             "do_Function": do_Function,  # 用於接收執行功能的函數;
#             "read_file_do_Function": read_file_do_Function  # None 或自定義的示例函數 read_and_write_file_do_Function;
#         }
#         output_dir = os.path.join(os.path.abspath(".."), "/temp/")  # "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
#         output_file = os.path.join(str(output_dir), "intermediary_write_Python.txt")  # "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
#         to_executable = os.path.join(os.path.abspath(".."), "/NodeJS/", "nodejs/node.exe")  # "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
#         to_script = os.path.join(os.path.abspath(".."), "/js/", "test.js")  # "../js/test.js" 用於執行功能的被調用的脚步文檔;
#         return_obj = {
#             "output_dir": output_dir,  # os.path.join(os.path.abspath(".."), "/temp/"), "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
#             "output_file": output_file,  # os.path.join(str(return_obj["output_dir"]), "intermediary_write_Python.txt"),  "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
#             "to_executable": to_executable,  # os.path.join(os.path.abspath(".."), "/NodeJS/", "nodejs/node.exe"),  "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
#             "to_script": to_script  # os.path.join(os.path.abspath(".."), "/js/", "test.js"),  "../js/test.js" 用於執行功能的被調用的脚步文檔;
#         }
#         return_obj["output_file"] = os.path.join(return_obj["output_dir"], "intermediary_write_Python.txt")  # "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
#         is_monitor = True  # 判斷是只需要執行一次還是啓動監聽服務器，可取值為：True、False;
#         is_Monitor_Concurrent = "Multi-Threading"  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值為：0、"0"、"Multi-Threading"、"Multi-Processes";
#         time_sleep = float(0.02)  # 用於監聽程序的輪詢延遲參數，單位（秒）;

#         # pid = multiprocessing.current_process().pid, threading.currentThread().ident;
#         Interface_File_Monitor = Interface_File_Monitor(
#             is_monitor=is_monitor,
#             is_Monitor_Concurrent=is_Monitor_Concurrent,
#             monitor_file=monitor_file,
#             monitor_dir=monitor_dir,
#             read_file_do_Function=read_file_do_Function,
#             do_Function=do_Function,
#             # do_Function_obj=do_Function_obj,
#             output_dir=output_dir,
#             output_file=output_file,
#             to_executable=to_executable,
#             to_script=to_script,
#             # return_obj=return_obj,
#             number_Worker_process=number_Worker_process,
#             temp_cache_IO_data_dir=temp_cache_IO_data_dir,
#             time_sleep=time_sleep
#         )
#         # Interface_File_Monitor = Interface_File_Monitor()
#         result_data = Interface_File_Monitor.run()
#         # print(type(result_data))
#         # print(result_data[0])

#     except Exception as error:
#         print(error)



# 示例函數，處理從客戶端 GET 或 POST 請求的信息，然後返回處理之後的結果JSON對象字符串數據;
def do_Request(request_Dict):
    # request_Dict = {
    #     "Client_IP": Client_IP,
    #     "request_Url": request_Url,
    #     # "request_Path": request_Path,
    #     "require_Authorization": self.request_Key,
    #     "require_Cookie": self.Cookie_value,
    #     # "Server_Authorization": Key,
    #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
    #     "request_body_string": request_form_value
    # }

    # print(type(request_Dict))
    # print(request_Dict)

    request_POST_String = ""  # request_Dict["request_body_string"];  # 客戶端發送 post 請求時的請求體數據;
    request_Url = ""  # request_Dict["request_Url"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
    request_Path = ""  # request_Dict["request_Path"];  # 客戶端發送請求的路徑 "/index.html";
    request_Url_Query_String = ""  # request_Dict["request_Url_Query_String"];  # 客戶端發送請求 url 中的查詢字符串 "a=1&b=2";
    request_Url_Query_Dict = {}  # 客戶端請求 url 中的查詢字符串值解析字典 {"a": 1, "b": 2};
    request_Authorization = ""  # request_Dict["require_Authorization"];  # 客戶端發送請求的用戶名密碼驗證字符串;
    request_Cookie = ""  # request_Dict["require_Cookie"];  # 客戶端發送請求的 Cookie 值字符串;
    request_Key = ""
    request_Nikename = ""  # request_Dict["request_Nikename"];  # 客戶端發送請求的驗證昵稱值字符串;
    request_Password = ""  # request_Dict["request_Password"];  # 客戶端發送請求的驗證密碼值字符串;
    # request_time = ""  # request_Dict["time"];  # 客戶端發送請求的 time 值字符串;
    # request_Date = ""  # request_Dict["Date"];  # 客戶端發送請求的日期值字符串;
    request_IP = ""  # request_Dict["Client_IP"];  # 客戶端發送請求的 IP 地址字符串;
    # request_Method = ""  # request_Dict["request_Method"];  # 客戶端發送請求的方法值字符串 "get"、"post";
    request_Host = ""  # request_Dict["Host"];  # 客戶端發送請求的服務器主機域名或 IP 地址值字符串 "127.0.0.1"、"localhost";
    # request_Protocol = ""  # request_Dict["request_Protocol"];  # 客戶端發送請求的協議值字符串 "http:"、"https:";
    request_User_Agent = ""  # request_Dict["User-Agent"];  # 客戶端發送請求的客戶端名字值字符串;
    request_From = ""  # request_Dict["From"];  # 客戶端發送請求的來源值字符串;

    # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
    if request_Dict.__contains__("Host"):
        # print(request_Dict["Host"])
        request_Host = request_Dict["Host"]
    if request_Dict.__contains__("request_Url"):
        # print(request_Dict["request_Url"])
        request_Url = request_Dict["request_Url"]
        # request_Url = request_Url.decode('utf-8')
    # if request_Dict.__contains__("request_Path"):
    #     # print(request_Dict["request_Path"])
    #     request_Path = request_Dict["request_Path"]
    #     # request_Path = request_Path.decode('utf-8')
    # if request_Dict.__contains__("request_Url_Query_String"):
    #     # print(request_Dict["request_Url_Query_String"])
    #     request_Url_Query_String = request_Dict["request_Url_Query_String"]
    #     # request_Url_Query_String = request_Url_Query_String.decode('utf-8')
    if request_Dict.__contains__("Client_IP"):
        # print(request_Dict["Client_IP"])
        request_IP = request_Dict["Client_IP"]
    if request_Dict.__contains__("require_Authorization"):
        # print(request_Dict["require_Authorization"])
        request_Authorization = request_Dict["require_Authorization"]
    if request_Dict.__contains__("require_Cookie"):
        # print(request_Dict["require_Cookie"])
         request_Cookie = request_Dict["require_Cookie"]
    if request_Dict.__contains__("request_body_string"):
        # print(request_Dict["request_body_string"])
        request_POST_String = request_Dict["request_body_string"]
        # request_POST_String = request_POST_String.decode('utf-8')
    # if request_Dict.__contains__("time"):
    #     print(request_Dict["time"])
    #     request_time = request_Dict["time"]

    # # print(request_Authorization)
    # # 使用請求頭信息「self.headers["Authorization"]」簡單驗證訪問用戶名和密碼，"Basic username:password";
    # if request_Authorization != None and request_Authorization != "":
    #     # print("request Headers Authorization: ", request_Authorization)
    #     # print("request Headers Authorization: ", request_Authorization.split(" ", -1)[0], base64.b64decode(request_Authorization.split(" ", -1)[1], altchars=None, validate=False))
    #     # 打印請求頭中的使用base64.b64decode()函數解密之後的用戶賬號和密碼參數"Authorization"的數據類型;
    #     # print(type(base64.b64decode(request_Authorization.split(" ", -1)[1], altchars=None, validate=False)))

    #     # 讀取客戶端發送的請求驗證賬號和密碼，並是使用 str(<object byets>, encoding="utf-8") 將字節流數據轉換爲字符串類型，函數 .split(" ", -1) 字符串切片;
    #     if request_Authorization.find("Basic", 0, int(len(request_Authorization)-1)) != -1 and request_Authorization.split(" ", -1)[0] == "Basic" and len(request_Authorization.split("Basic ", -1)) > 1 and request_Authorization.split("Basic ", -1)[1] != "":
    #         request_Key = str(base64.b64decode(request_Authorization.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
    #         request_Authorization = "Basic " + str(base64.b64decode(request_Authorization.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "Basic username:password";
    #         request_Nikename = request_Key.split(":", -1)[0]
    #         request_Password = request_Key.split(":", -1)[1]
    #     # print(type(request_Key))
    #     # print(request_Key)

    # # print(request_Cookie)
    # # 使用請求頭信息「self.headers["Cookie"]」簡單驗證訪問用戶名和密碼，"Session_ID=request_Key->username:password";
    # if request_Cookie != None and request_Cookie != "":
    #     Cookie_value = request_Cookie
    #     # print("request Headers Cookie: ", self.headers["Cookie"])
    #     # 讀取客戶端發送的請求Cookie參數字符串，並是使用 str(<object byets>, encoding="utf-8") 强制轉換爲字符串類型;
    #     # request_Key = eval("'" + str(Cookie_value.split("=", -1)[1]) + "'", {'request_Key' : ''})  # exec('request_Key="username:password"', {'request_Key' : ''}) 函數用來執行一個字符串表達式，並返字符串表達式的值;

    #     # 判斷客戶端傳入的 Cookie 值中是否包含 "=" 符號，函數 string.find("char", int, int) 從字符串中某個位置上的字符開始到某個位置上的字符終止，查找字符，如果找不到則返回 -1 值;
    #     if Cookie_value.find("=", 0, int(len(Cookie_value)-1)) != -1 and Cookie_value.find("Session_ID=", 0, int(len(Cookie_value)-1)) != -1 and Cookie_value.split("=", -1)[0] == "Session_ID":
    #         Session_ID = str(base64.b64decode(Cookie_value.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")
    #     else:
    #         Session_ID = str(base64.b64decode(Cookie_value, altchars=None, validate=False), encoding="utf-8")

    #     # print(type(Session_ID))
    #     # print(Session_ID)

    #     request_Key = Session_ID.split("request_Key->", -1)[1]
    #     request_Cookie = "Session_ID=" + Session_ID  # "Session_ID=request_Key->username:password";
    #     request_Nikename = request_Key.split(":", -1)[0]
    #     request_Password = request_Key.split(":", -1)[1]

    #     # # 判斷數據庫存儲的 Session 對象中是否含有客戶端傳過來的 Session_ID 值；# dict.__contains__(key) / Session_ID in Session 如果字典裏包含指點的鍵返回 True 否則返回 False；dict.get(key, default=None) 返回指定鍵的值，如果值不在字典中返回 "default" 值;
    #     # if Session_ID != None and Session_ID != "" and type(Session_ID) == str and Session.__contains__(Session_ID) == True and Session[Session_ID] != None:
    #     #     request_Key = str(Session[Session_ID])
    #     #     # print(type(request_Key))
    #     #     # print(request_Key)
    #     # else:
    #     #     # request_Key = ":"
    #     #     request_Key = ""

    #     # print(type(request_Key))
    #     # print(request_Key)
    #     # print(Key)


    if request_Url != "":
        if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
            request_Path = str(request_Url.split("?", -1)[0])
        elif request_Url.find("#", 0, int(len(request_Url)-1)) != -1:
            request_Path = str(request_Url.split("#", -1)[0])
        else:
            request_Path = str(request_Url)

        if request_Url.find("?", 0, int(len(request_Url)-1)) != -1:
            request_Url_Query_String = str(request_Url.split("?", -1)[1])
            if request_Url_Query_String.find("#", 0, int(len(request_Url_Query_String)-1)) != -1:
                request_Url_Query_String = str(request_Url_Query_String.split("#", -1)[0])

    # print(request_Url_Query_String)
    if isinstance(request_Url_Query_String, str) and request_Url_Query_String != "":
        if request_Url_Query_String.find("&", 0, int(len(request_Url_Query_String)-1)) != -1:
            # for i in range(0, len(request_Url_Query_String.split("&", -1))):
            for query_item in request_Url_Query_String.split("&", -1):
                if query_item.find("=", 0, int(len(query_item)-1)) != -1:
                    # request_Url_Query_Dict['"' + str(query_item.split("=", -1)[0]) + '"'] = query_item.split("=", -1)[1]
                    temp_split_Array = query_item.split("=", -1)
                    temp_split_value = ""
                    if len(temp_split_Array) > 1:
                        for i in range(1, len(temp_split_Array)):
                            if int(i) == int(1):
                                temp_split_value = temp_split_value + str(temp_split_Array[i])
                            if int(i) > int(1):
                                temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                    # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                    request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
                else:
                    # request_Url_Query_Dict['"' + str(query_item) + '"'] = ""
                    request_Url_Query_Dict[query_item] = ""
        else:
            if request_Url_Query_String.find("=", 0, int(len(request_Url_Query_String)-1)) != -1:
                # request_Url_Query_Dict['"' + str(request_Url_Query_String.split("=", -1)[0]) + '"'] = request_Url_Query_String.split("=", -1)[1]
                temp_split_Array = request_Url_Query_String.split("=", -1)
                temp_split_value = ""
                if len(temp_split_Array) > 1:
                    for i in range(1, len(temp_split_Array)):
                        if int(i) == int(1):
                            temp_split_value = temp_split_value + str(temp_split_Array[i])
                        if int(i) > int(1):
                            temp_split_value = temp_split_value + "=" + str(temp_split_Array[i])
                # request_Url_Query_Dict['"' + str(temp_split_Array[0]) + '"'] = temp_split_value
                request_Url_Query_Dict[temp_split_Array[0]] = temp_split_value
            else:
                # request_Url_Query_Dict['"' + str(request_Url_Query_String) + '"'] = ""
                request_Url_Query_Dict[request_Url_Query_String] = ""
    # print(request_Url_Query_Dict)

    # urllib.parse.urlparse(self.path)
    # urllib.parse.urlparse(self.path).path
    # parse_qs(urllib.parse.urlparse(self.path).query)
    fileName = "";  # "/PythonServer.py" 自定義的待替換的文件路徑全名;
    algorithmUser = "";  # 使用算法的驗證賬號;
    algorithmPass = "";  # 使用算法的驗證密碼;
    algorithmName = "";  # "Fitting"、"Simulation" 具體算法的名稱;
    global Key  # 變量 Key 為全局變量;
    # 使用函數 isinstance(request_Url_Query_Dict, dict) 判斷傳入的參數 request_Url_Query_Dict 是否為 dict 字典（JSON）格式對象;
    if isinstance(request_Url_Query_Dict, dict):
        # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
        if (request_Url_Query_Dict.__contains__("fileName")):
            fileName = str(request_Url_Query_Dict["fileName"])
        if (request_Url_Query_Dict.__contains__("algorithmUser")):
            algorithmUser = str(request_Url_Query_Dict["algorithmUser"])
        if (request_Url_Query_Dict.__contains__("algorithmPass")):
            algorithmPass = str(request_Url_Query_Dict["algorithmPass"])
        if (request_Url_Query_Dict.__contains__("algorithmName")):
            algorithmName = str(request_Url_Query_Dict["algorithmName"])
        if (request_Url_Query_Dict.__contains__("Key")):
            Key = str(request_Url_Query_Dict["Key"])


    # 將客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
    request_data_Dict = {}  # 聲明一個空字典，客戶端 post 請求發送的字符串數據解析為 Python 字典（Dict）對象;
    # # 使用自定義函數check_json_format(raw_msg)判斷讀取到的請求體表單"form"數據 request_POST_String 是否為JSON格式的字符串;
    # if check_json_format(request_POST_String):
    #     # 將讀取到的請求體表單"form"數據字符串轉換爲JSON對象;
    #     request_data_Dict = json.loads(request_POST_String)  # json.loads(request_POST_String, encoding='utf-8')
    # # print(request_data_Dict)

    response_data_Dict = {}  # 函數返回值，聲明一個空字典;
    response_data_String = ""

    return_file_creat_time = str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))
    # print(return_file_creat_time)

    response_data_Dict["request_Url"] = str(request_Url)  # {"request_Url": str(request_Url)};
    # response_data_Dict["request_Path"] = str(request_Path)  # {"request_Path": str(request_Path)};
    # response_data_Dict["request_Url_Query_String"] = str(request_Url_Query_String)  # {"request_Url_Query_String": str(request_Url_Query_String)};
    # response_data_Dict["request_POST"] = str(request_POST_String)  # {"request_POST": str(request_POST_String)};
    response_data_Dict["request_Authorization"] = str(request_Authorization)  # {"request_Authorization": str(request_Authorization)};
    response_data_Dict["request_Cookie"] = str(request_Cookie)  # {"request_Cookie": str(request_Cookie)};
    # response_data_Dict["request_Nikename"] = str(request_Nikename)  # {"request_Nikename": str(request_Nikename)};
    # response_data_Dict["request_Password"] = str(request_Password)  # {"request_Password": str(request_Password)};
    response_data_Dict["time"] = str(return_file_creat_time)  # {"request_POST": str(request_POST_String), "time": string(return_file_creat_time)};
    # response_data_Dict["Server_Authorization"] = str(key)  # "username:password"，{"Server_Authorization": str(key)};
    response_data_Dict["Server_say"] = str("")  # {"Server_say": str(request_POST_String)};
    response_data_Dict["error"] = str("")  # {"Server_say": str(request_POST_String)};
    # print(response_data_Dict)

    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
    # # 使用加號（+）拼接字符串;
    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
    # # print(response_data_String)

    # webPath = str(os.path.abspath("."))  # "C:/Criss/py/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
    web_path = "";  # str(os.path.join(os.path.abspath("."), str(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
    file_data = "";  # 用於保存從硬盤讀取文檔中的數據;
    dir_list_Arror = [];  # 用於保存從硬盤讀取文件夾中包含的子文檔和子文件夾名稱清單的字符串數組;

    if request_Path == "/":
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = str(os.path.join(str(webPath), "index.html"))  # 拼接本地當前目錄下的請求文檔名;
        file_data = ""

        Select_Statistical_Algorithms_HTML_path = str(os.path.join(str(webPath), "SelectStatisticalAlgorithms.html"))  # 拼接本地當前目錄下的請求文檔名;
        Select_Statistical_Algorithms_HTML = ""  # '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Select_Statistical_Algorithms_HTML_path) and os.path.isfile(Select_Statistical_Algorithms_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Select_Statistical_Algorithms_HTML_path, os.R_OK) and os.access(Select_Statistical_Algorithms_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Select_Statistical_Algorithms_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Select_Statistical_Algorithms_HTML_path, mode="rb+")
            try:
                Select_Statistical_Algorithms_HTML = fd.read()
                # Select_Statistical_Algorithms_HTML = fd.read().decode("utf-8")
                # data_Bytes = Select_Statistical_Algorithms_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String

        Input_HTML_path = str(os.path.join(str(webPath), "InputHTML.html"))  # 拼接本地當前目錄下的請求文檔名;
        Input_HTML = ""  # '<table id="InputTable" style="border-collapse:collapse; display: block;"><thead id="InputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">trainXdata</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_1</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_2</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_3</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">weight</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pdata_0</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Plower</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pupper</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_1</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_2</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_3</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">testXdata</th></tr></thead><tfoot id="InputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">trainXdata</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_2</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_3</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">weight</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pdata_0</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Plower</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pupper</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_2</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_3</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">testXdata</td></tr></tfoot><tbody id="InputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">0.00001</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">98</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">102</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.5</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">90</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">+inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">150</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">148</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">152</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">0.5</td></tr><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">202</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.5</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">4</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">+inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">202</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">1</td></tr></tbody></table>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Input_HTML_path) and os.path.isfile(Input_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Input_HTML_path, os.R_OK) and os.access(Input_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Input_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Input_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Input_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Input_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Input_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Input_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Input_HTML_path, mode="rb+")
            try:
                Input_HTML = fd.read()
                # Input_HTML = fd.read().decode("utf-8")
                # data_Bytes = Input_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Input_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Input_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String

        Output_HTML_path = str(os.path.join(str(webPath), "OutputHTML.html"))  # 拼接本地當前目錄下的請求文檔名;
        Output_HTML = ""  # '<table id="OutputTable" style="border-collapse:collapse; display: block;"><thead id="OutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Coefficient</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-StandardDeviation</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Lower-95%</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Upper-95%</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Lower</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Upper</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Residual</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xvals</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Lower</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Upper</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">test-Yfit</th></tr></thead><tfoot id="OutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Coefficient</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-StandardDeviation</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Lower-95%</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Upper-95%</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Lower</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Upper</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Residual</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xvals</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Lower</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Upper</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">test-Yfit</td></tr></tfoot><tbody id="OutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">100.007982422761</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.00781790123184812</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">99.9908250045862</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100.025139840936</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100.008980483748</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">99.0089499294379</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">101.00901103813</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.00898048374801874</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.500050586546119</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.499936310423273</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.500160692642957</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">149.99494193308</td></tr><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">42148.4577551448</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">2104.76673086505</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">37529.2688077105</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">46767.6467025791</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">199.99155580718</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198.991136273453</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200.991951293373</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-0.00844419281929731</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">1.00008444458554</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.999794808816128</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">1.00036584601127</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">199.99155580718</td></tr></tbody></table><canvas id="OutputCanvas" width="300" height="150" style="display: block;"></canvas>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Output_HTML_path) and os.path.isfile(Output_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Output_HTML_path, os.R_OK) and os.access(Output_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Output_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Output_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Output_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Output_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Output_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Output_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Output_HTML_path, mode="rb+")
            try:
                Output_HTML = fd.read()
                # Output_HTML = fd.read().decode("utf-8")
                # data_Bytes = Output_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Output_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Output_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String


        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(web_path, mode="rb+")
            try:
                file_data = fd.read()
                # file_data = fd.read().decode("utf-8")
                # data_Bytes = file_data.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 替換 .html 文檔中指定的位置字符串;
        if file_data != "":
            response_data_String = file_data
            response_data_String = str(response_data_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            response_data_String = str(response_data_String.replace("<!-- Input_HTML -->", Input_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            response_data_String = str(response_data_String.replace("<!-- Output_HTML -->", Output_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
        else:
            response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        return response_data_String

    elif request_Path == "/index.html":
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = str(os.path.join(str(webPath), str(request_Path[1:len(request_Path):1])))  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
        file_data = ""

        Select_Statistical_Algorithms_HTML_path = str(os.path.join(str(webPath), "SelectStatisticalAlgorithms.html"))  # 拼接本地當前目錄下的請求文檔名;
        Select_Statistical_Algorithms_HTML = ""  # '<input id="AlgorithmsLC5PFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LC5PFit" checked="true"><label for="AlgorithmsLC5PFitRadio" id="AlgorithmsLC5PFitRadioTXET" class="radio_label" style="display: inline;">5 parameter Logistic model fit</label> <input id="AlgorithmsLogisticFitRadio" class="radio_type" type="radio" name="StatisticalAlgorithmsRadio" style="display: inline;" value="LogisticFit"><label for="AlgorithmsLogisticFitRadio" id="AlgorithmsLogisticFitRadioTXET" class="radio_label" style="display: inline;">Logistic model fit</label>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Select_Statistical_Algorithms_HTML_path) and os.path.isfile(Select_Statistical_Algorithms_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Select_Statistical_Algorithms_HTML_path, os.R_OK) and os.access(Select_Statistical_Algorithms_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Select_Statistical_Algorithms_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Select_Statistical_Algorithms_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Select_Statistical_Algorithms_HTML_path, mode="rb+")
            try:
                Select_Statistical_Algorithms_HTML = fd.read()
                # Select_Statistical_Algorithms_HTML = fd.read().decode("utf-8")
                # data_Bytes = Select_Statistical_Algorithms_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔 [ " + str(Select_Statistical_Algorithms_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Select_Statistical_Algorithms_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄選擇統計運算類型單選框代碼的脚本文檔: " + str(Select_Statistical_Algorithms_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Select_Statistical_Algorithms_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String

        Input_HTML_path = str(os.path.join(str(webPath), "InputHTML.html"))  # 拼接本地當前目錄下的請求文檔名;
        Input_HTML = ""  # '<table id="InputTable" style="border-collapse:collapse; display: block;"><thead id="InputThead"><tr><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">trainXdata</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_1</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_2</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_3</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">weight</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pdata_0</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Plower</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pupper</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_1</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_2</th><th contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_3</th><th contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">testXdata</th></tr></thead><tfoot id="InputTfoot"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">trainXdata</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_2</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">trainYdata_3</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">weight</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pdata_0</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Plower</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Pupper</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_2</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">testYdata_3</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">testXdata</td></tr></tfoot><tbody id="InputTbody"><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">0.00001</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">98</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">102</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.5</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">90</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">+inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">150</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">148</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">152</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">0.5</td></tr><tr><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">1</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">202</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.5</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">4</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">+inf</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198</td><td contenteditable="true" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">202</td><td contenteditable="true" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">1</td></tr></tbody></table>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Input_HTML_path) and os.path.isfile(Input_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Input_HTML_path, os.R_OK) and os.access(Input_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Input_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Input_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Input_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Input_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Input_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Input_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Input_HTML_path, mode="rb+")
            try:
                Input_HTML = fd.read()
                # Input_HTML = fd.read().decode("utf-8")
                # data_Bytes = Input_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Input_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Input_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔 [ " + str(Input_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Input_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄輸入待處理數據表格代碼的脚本文檔: " + str(Input_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Input_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String

        Output_HTML_path = str(os.path.join(str(webPath), "OutputHTML.html"))  # 拼接本地當前目錄下的請求文檔名;
        Output_HTML = ""  # '<table id="OutputTable" style="border-collapse:collapse; display: block;"><thead id="OutputThead"><tr><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Coefficient</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-StandardDeviation</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Lower-95%</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Upper-95%</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Lower</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Upper</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Residual</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xvals</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Lower</th><th contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Upper</th><th contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">test-Yfit</th></tr></thead><tfoot id="OutputTfoot"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">Coefficient</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-StandardDeviation</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Lower-95%</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Coefficient-Confidence-Upper-95%</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Lower</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Yfit-Uncertainty-Upper</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">Residual</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xvals</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Lower</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">test-Xfit-Uncertainty-Upper</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">test-Yfit</td></tr></tfoot><tbody id="OutputTbody"><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">100.007982422761</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.00781790123184812</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">99.9908250045862</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100.025139840936</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">100.008980483748</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">99.0089499294379</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">101.00901103813</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.00898048374801874</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.500050586546119</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.499936310423273</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.500160692642957</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">149.99494193308</td></tr><tr><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">42148.4577551448</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">2104.76673086505</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">37529.2688077105</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">46767.6467025791</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">199.99155580718</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">198.991136273453</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">200.991951293373</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">-0.00844419281929731</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">1.00008444458554</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">0.999794808816128</td><td contenteditable="false" style="border-left: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">1.00036584601127</td><td contenteditable="false" style="border-left: 0px solid black; border-top: 1px solid black; border-right: 0px solid black; border-bottom: 1px solid black;">199.99155580718</td></tr></tbody></table><canvas id="OutputCanvas" width="300" height="150" style="display: block;"></canvas>'
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(Output_HTML_path) and os.path.isfile(Output_HTML_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(Output_HTML_path, os.R_OK) and os.access(Output_HTML_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(Output_HTML_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(Output_HTML_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(Output_HTML_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(Output_HTML_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(Output_HTML_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } cannot modify to read and write permission."

                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String

            fd = open(Output_HTML_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(Output_HTML_path, mode="rb+")
            try:
                Output_HTML = fd.read()
                # Output_HTML = fd.read().decode("utf-8")
                # data_Bytes = Output_HTML.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unrecognized."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except PersmissionError:
                print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unable to read."
                # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # # 使用加號（+）拼接字符串;
                # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # # print(response_data_String)
                # return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(Output_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
                else:
                    print(f'Error: {str(Output_HTML_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔 [ " + str(Output_HTML_path) + " ] 讀取數據發生錯誤."
                    # response_data_Dict["error"] = f'Error: {str(Output_HTML_path)} : {error.strerror}'
                    # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # # 使用加號（+）拼接字符串;
                    # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # # print(response_data_String)
                    # return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "記錄輸出運算結果數據表格代碼的脚本文檔: " + str(Output_HTML_path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(Output_HTML_path) + " } unrecognized."

            # # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            # response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # # 使用加號（+）拼接字符串;
            # # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # # print(response_data_String)
            # return response_data_String


        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(web_path, mode="rb+")
            try:
                file_data = fd.read()
                # file_data = fd.read().decode("utf-8")
                # data_Bytes = file_data.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 替換 .html 文檔中指定的位置字符串;
        if file_data != "":
            response_data_String = file_data
            response_data_String = str(response_data_String.replace("<!-- Select_Statistical_Algorithms_HTML -->", Select_Statistical_Algorithms_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            response_data_String = str(response_data_String.replace("<!-- Input_HTML -->", Input_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            response_data_String = str(response_data_String.replace("<!-- Output_HTML -->", Output_HTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
        else:
            response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        return response_data_String

    elif request_Path == "/administrator.html":
        # 客戶端或瀏覽器請求 url = http://localhost:10001/administrator.html?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = str(os.path.join(str(webPath), str(request_Path[1:len(request_Path):1])))  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/administrator.html" 字符串首的斜杠 '/' 字符;
        file_data = ""

        directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>'

        # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組，使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        if os.path.exists(webPath) and pathlib.Path(webPath).is_dir():
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(webPath, os.R_OK) and os.access(webPath, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(webPath, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(webPath, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(webPath, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(webPath, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(webPath, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(webPath)} : {error.strerror}')
                    print("指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = f'Error: {str(webPath)} : {error.strerror}'

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            dir_list_Arror = os.listdir(webPath)  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
            # len(os.listdir(webPath))
            # if len(os.listdir(webPath)) > 0:
            for item in dir_list_Arror:

                name_href_url_string = "http://" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                delete_href_url_string = "http://" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                downloadFile_href_string = "fileDownload('post', 'UpLoadData', '" + str(name_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\\n', '" + str(item) + "', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;
                deleteFile_href_string = "deleteFile('post', 'UpLoadData', '" + str(delete_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;

                # if request_Path == "/":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + str(item)) + "?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                # elif request_Path == "/index.html":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # else:
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"

                item_Path = str(os.path.join(str(webPath), str(item)))  # 拼接本地當前目錄下的請求文檔名;
                statsObj = os.stat(item_Path)  # 讀取文檔或文件夾詳細信息;

                if os.path.exists(item_Path) and os.path.isfile(item_Path):
                    # 語句 float(statsObj.st_mtime) % 1000 中的百分號（%）表示除法取餘數;
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(int(statsObj.st_size)) + ' Bytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(float(statsObj.st_size) / float(1024.0)) + ' KiloBytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a onclick="' + str(downloadFile_href_string) + '" href="javascript:void(0)">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a onclick="' + str(deleteFile_href_string) + '" href="javascript:void(0)">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                elif os.path.exists(item_Path) and pathlib.Path(item_Path).is_dir():
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td></td><td></td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                # else:
                # print(directoryHTML)
        else:
            print("指定的服務器運行根目錄文件夾 [ " + str(webPath) + " ] 不存在或無法識別.")

            response_data_Dict["Server_say"] = "服務器的運行路徑: " + str(webPath) + " 無法識別."
            response_data_Dict["error"] = "Folder = { " + str(webPath) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 同步讀取硬盤 .html 文檔，返回字符串;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # fd = open(web_path, mode="rb+")
            try:
                file_data = fd.read()
                # file_data = fd.read().decode("utf-8")
                # data_Bytes = file_data.encode("utf-8")
                # fd.write(data_Bytes)
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        # 替換 .html 文檔中指定的位置字符串;
        if file_data != "":
            response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
        else:
            response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        return response_data_String

    elif request_Path == "/uploadFile":
        # 客戶端或瀏覽器請求 url = http://localhost:10001/uploadFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=JuliaServer.jl

        if fileName == "":
            print("Upload file name empty { " + str(fileName) + " }.")
            response_data_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " + str(fileName) + " } 爲空."
            response_data_Dict["error"] = "File name = { " + str(fileName) + " } empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        # print(fileName)
        web_path = ""
        if fileName[0] == '/' or fileName[0] == '\\':
            web_path = str(os.path.join(str(webPath), str(fileName[1:len(fileName)])))  # 拼接待替換寫入的目標文檔名（絕對路徑），如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
        else:
            web_path = str(os.path.join(str(webPath), str(fileName)))  # 拼接待替換寫入的目標文檔名（絕對路徑）;
        # print(web_path)

        file_data = str(request_POST_String)  # 向目標文檔中寫入的内容字符串;
        # file_data_bytes = file_data.encode("utf-8")
        # file_data_len = len(bytes(file_data, "utf-8"))
        # file_data_integer_Array = json.loads(file_data)  # 將讀取到的傳入參數字符串轉換爲JSON對象 file_data_integer_Array = json.loads(file_data, encoding='utf-8');
        # file_data = json.dumps(file_data_integer_Array)  # 將JOSN對象轉換為JSON字符串;
        # file_data = file_data.encode('utf-8')
        # file_data_bytes_Array = []  # 字符串轉換後的二進制字節流數組;
        # for i in range(0, int(len(file_data_integer_Array))):
        #     # itemBytes = bytes(int(file_data_integer_Array[i]), "utf-8")
        #     # itemBytes = str(file_data_integer_Array[i]).encode('utf-8')  # 字符串轉二進制字節流;
        #     itemBytes = struct.pack('B', int(file_data_integer_Array[i]))  # 將十進制表達式的整數轉換爲二進制的整數，參數 'B' 表示轉換後的二進制整數用八位比特（bits）表示;
        #     # itemBytes.decode("utf-8")  # 二進制字節流轉字符串;
        #     # file_data_integer_Tuple = struct.unpack('B' * len(itemBytes), itemBytes)  # 解碼
        #     # file_data_integer_Tuple = struct.unpack('B' * len(itemBytes), itemBytes)  # 解碼
        #     file_data_bytes_Array.append(itemBytes)

        # 同步寫入或創建硬盤目標文檔：首先判斷指定的待寫入文檔，是否已經存在且是否為文檔，如果已存在則從硬盤刪除，然後重新創建並寫入新值;
        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("目標寫入文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(fileName) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(fileName) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            # 刪除指定的待寫入文檔;
            try:
                os.remove(web_path)  # 刪除文檔
            except OSError as error:
                print(f'Error: {str(web_path)} : {error.strerror}')
                print("目標替換文檔 [ " + str(web_path) + " ] 已存在且無法刪除，以重新創建更新數據.")
                response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 已存在且無法刪除，以重新創建更新數據."
                response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String

            # # 判斷指定的待寫入文檔，是否已經從硬盤刪除;
            # if os.path.exists(web_path) and os.path.isfile(web_path):
            #     print("目標替換文檔 [ " + str(web_path) + " ] 已存在且無法刪除，以重新創建更新數據.")
            #     response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(web_path) + " ] 已存在且無法刪除，以重新創建更新數據."
            #     response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String

        else:

            # 截取目標寫入目錄;
            writeDirectory = ""
            # print(fileName)
            if isinstance(fileName, str) and fileName.find("/", 0, int(len(fileName)-1)) != -1:
                tempArray = []
                tempArray = fileName.split("/", -1)
                if len(tempArray) <= 2:
                    writeDirectory = "/"
                else:
                    for i in range(0, int(len(tempArray) - int(1))):
                        if i == 0:
                            writeDirectory = str(tempArray[i])
                        else:
                            writeDirectory = writeDirectory + "/" + str(tempArray[i])
            elif isinstance(fileName, str) and fileName.find("\\", 0, int(len(fileName)-1)) != -1:
                tempArray = []
                tempArray = fileName.split("\\", -1)
                if len(tempArray) <= 2:
                    writeDirectory = "\\"
                else:
                    for i in range(0, int(len(tempArray) - int(1))):
                        if i == 0:
                            writeDirectory = str(tempArray[i])
                        else:
                            writeDirectory = writeDirectory + "\\" + str(tempArray[i])
            else:
                writeDirectory = "/"
            # print(writeDirectory)
            AbsolutewriteDirectory = ""
            if writeDirectory[0] == '/' or writeDirectory[0] == '\\':
                AbsolutewriteDirectory = str(os.path.join(str(webPath), str(writeDirectory[1:len(writeDirectory)])))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名，如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
            else:
                AbsolutewriteDirectory = str(os.path.join(str(webPath), str(writeDirectory)))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名;
            # print(AbsolutewriteDirectory)

            # 判斷目標寫入目錄（文件夾）是否存在，如果不存在則創建;
            # 使用Python原生模組os判斷指定的目錄或文檔是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
            if os.path.exists(AbsolutewriteDirectory) and pathlib.Path(AbsolutewriteDirectory).is_dir():
                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(AbsolutewriteDirectory, os.R_OK) and os.access(AbsolutewriteDirectory, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(AbsolutewriteDirectory, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(AbsolutewriteDirectory, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(AbsolutewriteDirectory, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(AbsolutewriteDirectory, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(AbsolutewriteDirectory, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(AbsolutewriteDirectory)} : {error.strerror}')
                        print("指定的待寫入的目錄（文件夾）[ " + str(AbsolutewriteDirectory) + " ] 無法修改為可讀可寫權限.")
                        response_data_Dict["Server_say"] = "指定的待寫入的目錄（文件夾）[ " + str(writeDirectory) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = f'Error: {str(writeDirectory)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String
            else:
                try:
                    # print(AbsolutewriteDirectory)
                    os.makedirs(AbsolutewriteDirectory, mode=0o777, exist_ok=True)
                    # os.chmod(os.getcwd(), stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)  # 修改文檔權限 mode:777 任何人可讀寫;
                    # exist_ok：是否在目錄存在時觸發異常。如果exist_ok為False（預設值），則在目標目錄已存在的情況下觸發FileExistsError異常；如果exist_ok為True，則在目標目錄已存在的情況下不會觸發FileExistsError異常;
                except FileExistsError as error:
                    # 如果指定創建的目錄已經存在，則捕獲並抛出 FileExistsError 錯誤
                    print(f'Error: {str(AbsolutewriteDirectory)} : {error.strerror}')
                    print("指定的待寫入的目錄（文件夾）[ " + str(AbsolutewriteDirectory) + " ] 無法創建.")
                    response_data_Dict["Server_say"] = "指定的待寫入的目錄（文件夾）[ " + str(writeDirectory) + " ] 無法創建."
                    response_data_Dict["error"] = f'Error: {str(writeDirectory)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            # # 判斷指定的寫入目錄（文件夾）是否創建成功;
            # if not (os.path.exists(AbsolutewriteDirectory) and pathlib.Path(AbsolutewriteDirectory).is_dir()):
            #     print("指定的待寫入的目錄（文件夾）[ " + str(AbsolutewriteDirectory) + " ] 無法創建.")
            #     response_data_Dict["Server_say"] = "指定的待寫入的目錄（文件夾）[ " + str(writeDirectory) + " ] 無法創建."
            #     response_data_Dict["error"] = f'Directory: ( {str(writeDirectory)} ) cannot be created.'
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String


        # # 以可寫方式打開硬盤文檔，如果文檔不存在，則會自動創建一個文檔，以字符串形式寫入純文本文檔;
        # fd = open(web_path, mode="w+", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
        # # fd = open(web_path, mode="wb+")
        # try:
        #     numBytes = fd.write(file_data)  # 寫入字符串，返回值為寫入的字符數目;
        #     # file_data_bytes = file_data.encode("utf-8")
        #     # file_data_len = len(bytes(file_data, "utf-8"))
        #     # fd.write(file_data_bytes)
        #     response_data_Dict["Server_say"] = "向文檔: " + str(fileName) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
        #     # response_data_Dict["Server_say"] = "向文檔: " + str(web_path) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
        #     response_data_Dict["error"] = ""
        #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        #     # 使用加號（+）拼接字符串;
        #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        #     # print(response_data_String)
        #     # return response_data_String
        # except FileNotFoundError:
        #     print("目標替換文檔 [ " + str(web_path) + " ] 創建失敗.")
        #     response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 創建失敗."
        #     response_data_Dict["error"] = "File [ " + str(fileName) + " ] creation failed."
        #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        #     # 使用加號（+）拼接字符串;
        #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        #     # print(response_data_String)
        #     return response_data_String
        # except PersmissionError:
        #     print("目標替換文檔 [ " + str(web_path) + " ] 沒有打開權限.")
        #     response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 沒有打開權限."
        #     response_data_Dict["error"] = "File [ " + str(fileName) + " ]  unable to write."
        #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
        #     # 使用加號（+）拼接字符串;
        #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
        #     # print(response_data_String)
        #     return response_data_String
        # finally:
        #     fd.close()
        # # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


        # 以可寫方式打開硬盤文檔，如果文檔不存在，則會自動創建一個文檔，以字節流形式寫入二進制文檔;
        fd = open(web_path, mode="wb+", buffering=-1)
        # fd = open(web_path, mode="w+", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
        try:
            file_data_integer_Array = json.loads(file_data)  # 將讀取到的傳入參數字符串轉換爲JSON對象 file_data_integer_Array = json.loads(file_data, encoding='utf-8');
            # file_data = json.dumps(file_data_integer_Array)  # 將JOSN對象轉換為JSON字符串;
            # file_data = file_data.encode('utf-8')
            numBytes = int(0)  # 寫入的縂字節數;
            # file_data_bytes_Array = []  # 字符串轉換後的二進制字節流數組;
            for i in range(0, int(len(file_data_integer_Array))):
                # itemBytes = bytes(int(file_data_integer_Array[i]), "utf-8")
                # itemBytes = str(file_data_integer_Array[i]).encode('utf-8')  # 字符串轉二進制字節流;
                itemBytes = struct.pack('B', int(file_data_integer_Array[i]))  # 將十進制表達式的整數轉換爲二進制的整數，參數 'B' 表示轉換後的二進制整數用八位比特（bits）表示;
                # itemBytes.decode("utf-8")  # 二進制字節流轉字符串;
                # file_data_integer_Tuple = struct.unpack('B' * len(itemBytes), itemBytes)  # 解碼
                # file_data_bytes_Array.append(itemBytes)
                numWriteBytes = fd.write(itemBytes)  # 寫入一個二進制字節;
                numBytes = int(numBytes) + int(numWriteBytes)  # 纍計寫入文檔的字節數目;

            response_data_Dict["Server_say"] = "向文檔: " + str(fileName) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
            # response_data_Dict["Server_say"] = "向文檔: " + str(web_path) + " 中寫入 " + str(numBytes) + " 個字符(Character)數據."  # "Write file ( " + str(web_path) + " ) " + str(numBytes) + " Bytes data.";
            response_data_Dict["error"] = ""
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            # return response_data_String
        except FileNotFoundError:
            print("目標替換文檔 [ " + str(web_path) + " ] 創建失敗.")
            response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 創建失敗."
            response_data_Dict["error"] = "File [ " + str(fileName) + " ] creation failed."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String
        except PersmissionError:
            print("目標替換文檔 [ " + str(web_path) + " ] 沒有打開權限.")
            response_data_Dict["Server_say"] = "目標替換文檔 [ " + str(fileName) + " ] 沒有打開權限."
            response_data_Dict["error"] = "File [ " + str(fileName) + " ]  unable to write."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String
        finally:
            fd.close()
        # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

        return response_data_String

    elif request_Path == "/deleteFile":
        # 客戶端或瀏覽器請求 url = http://localhost:10001/deleteFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=PythonServer.py

        if fileName == "":
            print("Upload file name empty { " + str(fileName) + " }.")
            response_data_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " + str(fileName) + " } 爲空."
            response_data_Dict["error"] = "File name = { " + str(fileName) + " } empty."
            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String


        if fileName != "":

            # print(fileName)
            web_path = ""
            if fileName[0] == '/' or fileName[0] == '\\':
                web_path = str(os.path.join(str(webPath), str(fileName[1:len(fileName)])))  # 拼接待替換寫入的目標文檔名（絕對路徑），如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
            else:
                web_path = str(os.path.join(str(webPath), str(fileName)))  # 拼接待替換寫入的目標文檔名（絕對路徑）;
            # print(web_path)

            file_data = str(request_POST_String)  # 客戶端 POST 請求的内容字符串;

            if os.path.exists(web_path) and os.path.isfile(web_path):

                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(web_path)} : {error.strerror}')
                        print("目標待刪除文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                        response_data_Dict["Server_say"] = "指定的待刪除文檔 [ " + str(fileName) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = "File = { " + str(fileName) + " } cannot modify to read and write permission."

                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String

                # 刪除指定的文檔;
                try:
                    os.remove(web_path)  # 刪除文檔
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("指定的待刪除文檔 [ " + str(web_path) + " ] 無法刪除.")
                    response_data_Dict["Server_say"] = "指定的待刪除文檔 [ " + str(fileName) + " ] 無法刪除."
                    response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

                # # 判斷指定的待刪除文檔，是否已經從硬盤刪除;
                # if os.path.exists(web_path) and os.path.isfile(web_path):
                #     print("指定的待刪除文檔 [ " + str(web_path) + " ] 無法被刪除.")
                #     response_data_Dict["Server_say"] = "指定的待刪除文檔 [ " + str(fileName) + " ] 無法被刪除."
                #     response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                #     # 使用加號（+）拼接字符串;
                #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                #     # print(response_data_String)
                #     return response_data_String

            elif os.path.exists(web_path) and pathlib.Path(web_path).is_dir():

                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(web_path)} : {error.strerror}')
                        print("指定的待刪除目錄（文件夾）[ " + str(web_path) + " ] 無法修改為可讀可寫權限.")
                        response_data_Dict["Server_say"] = "指定的待刪除目錄（文件夾）[ " + str(fileName) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String

                # 刪除指定的目錄（文件夾）;
                try:
                    shutil.rmtree(web_path, ignore_errors=True)  # 遞歸刪除文件夾及文件夾裏的所有内容（子文檔和子文件夾），參數 ignore_errors=True 表示忽略錯誤;
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("指定的待刪除目錄（文件夾）[ " + str(web_path) + " ] 無法刪除.")
                    response_data_Dict["Server_say"] = "指定的待刪除目錄（文件夾）[ " + str(fileName) + " ] 無法刪除."
                    response_data_Dict["error"] = f'Error: {str(fileName)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

                # # 檢查指定的待刪除目錄（文件夾）是否已經從硬盤移除;
                # if os.path.exists(web_path) and pathlib.Path(web_path).is_dir():
                #     print("指定的待刪除目錄（文件夾）[ " + str(web_path) + " ] 無法被刪除.")
                #     response_data_Dict["Server_say"] = "指定的待刪除目錄（文件夾）[ " + str(fileName) + " ] 無法被刪除."
                #     response_data_Dict["error"] = f'Directory: ( {str(fileName)} ) cannot be deleted.'
                #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                #     # 使用加號（+）拼接字符串;
                #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                #     # print(response_data_String)
                #     return response_data_String

            else:

                print("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " + str(web_path) + " 不存在或者無法識別.")
                response_data_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " + str(fileName) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(fileName) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String


        # # web_path_index_Html = str(os.path.join(str(webPath), "index.html"))  # 拼接服務器返回的響應值文檔名（絕對路徑）;
        # # file_data = Base.string(request_POST_String);
        # # 截取目標寫入目錄;
        # currentDirectory = ""
        # # print(fileName)
        # if isinstance(fileName, str) and fileName.find("/", 0, int(len(fileName)-1)) != -1:
        #     tempArray = []
        #     tempArray = fileName.split("/", -1)
        #     if len(tempArray) <= 2:
        #         currentDirectory = "/"
        #     else:
        #         for i in range(0, int(len(tempArray) - int(1))):
        #             if i == 0:
        #                 currentDirectory = str(tempArray[i])
        #             else:
        #                 currentDirectory = currentDirectory + "/" + str(tempArray[i])
        # elif isinstance(fileName, str) and fileName.find("\\", 0, int(len(fileName)-1)) != -1:
        #     tempArray = []
        #     tempArray = fileName.split("\\", -1)
        #     if len(tempArray) <= 2:
        #         currentDirectory = "\\"
        #     else:
        #         for i in range(0, int(len(tempArray) - int(1))):
        #             if i == 0:
        #                 currentDirectory = str(tempArray[i])
        #             else:
        #                 currentDirectory = currentDirectory + "\\" + str(tempArray[i])
        # else:
        #     currentDirectory = "/"
        # # print(currentDirectory)
        # if currentDirectory[0] == '/' or currentDirectory[0] == '\\':
        #     web_path = str(os.path.join(str(webPath), str(currentDirectory[1:len(currentDirectory)])))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名，如果第一個字符為 "/" 或 "\"，則先刪除第一個字符再拼接;
        # else:
        #     web_path = str(os.path.join(str(webPath), str(currentDirectory)))  # 拼接本地待替換寫入的目標文件夾（絕對路徑）名;
        # # print(web_path)

        return response_data_String

    else:

        web_path = str(os.path.join(str(webPath), str(request_Path[1:len(request_Path):1])))  # 拼接本地當前目錄下的請求文檔名，request_Path[1:len(request_Path):1] 表示刪除 "/administrator.html" 字符串首的斜杠 '/' 字符;
        web_path_index_Html = str(os.path.join(str(webPath), "administrator.html"))
        file_data = ""

        if os.path.exists(web_path) and os.path.isfile(web_path):

            # 同步讀取硬盤文檔，返回字符串;
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["error"] = "File = { " + str(request_Path) + " } cannot modify to read and write permission."
                    # response_data_Dict["error"] = "File = { " + str(web_path) + " } cannot modify to read and write permission."

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String


            # # 用讀取字符串的形式讀取純文本文檔;
            # fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            # # fd = open(web_path, mode="rb+")
            # try:
            #     file_data = fd.read()
            #     # file_data = fd.read().decode("utf-8")
            #     # data_Bytes = file_data.encode("utf-8")
            #     # fd.write(data_Bytes)
            # except FileNotFoundError:
            #     print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
            #     # response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            #     response_data_Dict["Server_say"] = "請求的文檔: " + str(request_Path) + " 不存在或者無法識別."
            #     # response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
            #     response_data_Dict["error"] = "File = { " + str(request_Path) + " } unrecognized."
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String
            # except PersmissionError:
            #     print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
            #     # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
            #     response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 沒有打開權限."
            #     # response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
            #     response_data_Dict["error"] = "File = { " + str(request_Path) + " } unable to read."
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String
            # except Exception as error:
            #     if("[WinError 32]" in str(error)):
            #         print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
            #         print(f'Error: {str(web_path)} : {error.strerror}')
            #         # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
            #         response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 無法讀取數據."
            #         # response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #         response_data_Dict["error"] = f'Error: {str(request_Path)} : {error.strerror}'
            #         # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #         # 使用加號（+）拼接字符串;
            #         # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #         # print(response_data_String)
            #         return response_data_String
            #     else:
            #         print(f'Error: {str(web_path)} : {error.strerror}')
            #         response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
            #         response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
            #         response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #         response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
            #         # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #         # 使用加號（+）拼接字符串;
            #         # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #         # print(response_data_String)
            #         return response_data_String
            # finally:
            #     fd.close()
            # # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


            # 用讀取字節流數組的形式讀取二進制文檔;
            fd = open(web_path, mode="rb+", buffering=-1)
            # fd = open(web_path, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
            try:
                file_data_bytes_String = fd.read()
                # file_data_bytes_String.decode("utf-8")  # 二進制字節流轉字符串;
                file_data_integer_Tuple = struct.unpack('B' * len(file_data_bytes_String), file_data_bytes_String)
                # bytes(int(file_data_integer_Tuple[i]), "utf-8")
                # struct.pack('B', int(file_data_integer_Tuple[i]))  # 將十進制表達式的整數轉換爲二進制的整數，參數 'B' 表示轉換後的二進制整數用八位比特（bits）表示;
                # str(file_data_integer_Tuple[i]).encode("utf-8")  # 字符串轉二進制字節流;
                file_data_integer_Array = []
                for i in range(0, int(len(file_data_integer_Tuple))):
                    file_data_integer_Array.append(int(file_data_integer_Tuple[i]))
                file_data = json.dumps(file_data_integer_Array)  # 將JOSN對象轉換為JSON字符串;
                # file_data_integer_Array = json.loads(file_data)  # 將讀取到的傳入參數字符串轉換爲JSON對象;
            except FileNotFoundError:
                print("請求的文檔 [ " + str(web_path) + " ] 不存在.")
                # response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
                response_data_Dict["Server_say"] = "請求的文檔: " + str(request_Path) + " 不存在或者無法識別."
                # response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
                response_data_Dict["error"] = "File = { " + str(request_Path) + " } unrecognized."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except PersmissionError:
                print("請求的文檔 [ " + str(web_path) + " ] 沒有打開權限.")
                # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 沒有打開權限."
                response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 沒有打開權限."
                # response_data_Dict["error"] = "File = { " + str(web_path) + " } unable to read."
                response_data_Dict["error"] = "File = { " + str(request_Path) + " } unable to read."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String
            except Exception as error:
                if("[WinError 32]" in str(error)):
                    print("請求的文檔 [ " + str(web_path) + " ] 無法讀取數據.")
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    # response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 無法讀取數據."
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(request_Path) + " ] 無法讀取數據."
                    # response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    response_data_Dict["error"] = f'Error: {str(request_Path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                else:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path) + " ] 讀取數據發生錯誤."
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
            finally:
                fd.close()
            # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;


            response_data_String = str(file_data)
            # # 替換 .html 文檔中指定的位置字符串;
            # if file_data != "":
            #     # response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            # else:
            #     # response_data_Dict["Server_say"] = "文檔: " + str(web_path) + " 爲空."
            #     response_data_Dict["Server_say"] = "文檔: " + str(request_Path) + " 爲空."
            #     # response_data_Dict["error"] = "File ( " + str(web_path) + " ) empty."
            #     response_data_Dict["error"] = "File ( " + str(request_Path) + " ) empty."
            #     # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            #     # 使用加號（+）拼接字符串;
            #     # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            #     # print(response_data_String)
            #     return response_data_String

            return response_data_String

        elif os.path.exists(web_path) and pathlib.Path(web_path).is_dir():

            directoryHTML = '<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>'

            # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組;
            # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
            if not (os.access(web_path, os.R_OK) and os.access(web_path, os.W_OK)):
                try:
                    # 修改文檔權限 mode:777 任何人可讀寫;
                    os.chmod(web_path, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                    # os.chmod(web_path, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                    # os.chmod(web_path, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                    # os.chmod(web_path, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                    # os.chmod(web_path, stat.S_IWOTH)  # 可被其它用戶寫入;
                    # stat.S_IXOTH:  其他用戶有執行權0o001
                    # stat.S_IWOTH:  其他用戶有寫許可權0o002
                    # stat.S_IROTH:  其他用戶有讀許可權0o004
                    # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                    # stat.S_IXGRP:  組用戶有執行許可權0o010
                    # stat.S_IWGRP:  組用戶有寫許可權0o020
                    # stat.S_IRGRP:  組用戶有讀許可權0o040
                    # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                    # stat.S_IXUSR:  擁有者具有執行許可權0o100
                    # stat.S_IWUSR:  擁有者具有寫許可權0o200
                    # stat.S_IRUSR:  擁有者具有讀許可權0o400
                    # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                    # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                    # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                    # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                    # stat.S_IREAD:  windows下設為唯讀
                    # stat.S_IWRITE: windows下取消唯讀
                except OSError as error:
                    print(f'Error: {str(web_path)} : {error.strerror}')
                    print("指定的服務器運行根目錄文件夾 [ " + str(web_path) + " ] 無法修改為可讀可寫權限.")

                    # response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(web_path) + " ] 無法修改為可讀可寫權限."
                    response_data_Dict["Server_say"] = "指定的服務器運行根目錄文件夾 [ " + str(request_Path) + " ] 無法修改為可讀可寫權限."
                    # response_data_Dict["error"] = f'Error: {str(web_path)} : {error.strerror}'
                    response_data_Dict["error"] = f'Error: {str(request_Path)} : {error.strerror}'

                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String

            dir_list_Arror = os.listdir(web_path)  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
            # len(os.listdir(web_path))
            # if len(os.listdir(web_path)) > 0:
            for item in dir_list_Arror:

                name_href_url_string = "http://" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                # name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                delete_href_url_string = "http://" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                # delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                downloadFile_href_string = "fileDownload('post', 'UpLoadData', '" + str(name_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\\n', '" + str(item) + "', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;
                deleteFile_href_string = "deleteFile('post', 'UpLoadData', '" + str(delete_href_url_string) + "', parseInt(0), '" + str(Key) + "', 'Session_ID=request_Key->" + str(Key) + "', 'abort_button_id_string', 'UploadFileLabel', function(error, response){{}})"  # 在 Python 中如果想要輸入 '{}' 符號，需要使用 '{{}}' 符號轉義;

                # if request_Path == "/":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + str(item)) + "?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + str(item)) + "&Key=" + str(Key) + "#"
                # elif request_Path == "/index.html":
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str("/" + str(item)) + "?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str("/" + str(item)) + "&Key=" + str(Key) + "#"
                # else:
                #     name_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + str(str(request_Path) + "/" + str(item)) + "?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"
                #     delete_href_url_string = "http://" + str(Key) + "@" + str(request_Host) + "/deleteFile?fileName=" + str(str(request_Path) + "/" + str(item)) + "&Key=" + str(Key) + "#"

                item_Path = str(os.path.join(str(web_path), str(item)))  # 拼接本地當前目錄下的請求文檔名;
                statsObj = os.stat(item_Path)  # 讀取文檔或文件夾詳細信息;

                if os.path.exists(item_Path) and os.path.isfile(item_Path):
                    # 語句 float(statsObj.st_mtime) % 1000 中的百分號（%）表示除法取餘數;
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(int(statsObj.st_size)) + ' Bytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td>' + str(float(statsObj.st_size) / float(1024.0)) + ' KiloBytes' + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a onclick="' + str(downloadFile_href_string) + '" href="javascript:void(0)">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a onclick="' + str(deleteFile_href_string) + '" href="javascript:void(0)">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="javascript:' + str(downloadFile_href_string) + '">' + str(item) + '</a></td><td>' + str(str(int(statsObj.st_size)) + ' Bytes') + '</td><td>' + str(time.strftime("%Y-%m-%d %H:%M:%S.{}".format(int(float(statsObj.st_mtime) % 1000.0)), time.localtime(statsObj.st_mtime))) + '</td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                elif os.path.exists(item_Path) and pathlib.Path(item_Path).is_dir():
                    # directoryHTML = directoryHTML + '<tr><td><a href="#">' + str(item) + '</a></td><td></td><td></td></tr>'
                    directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="javascript:' + str(deleteFile_href_string) + '">刪除</a></td></tr>'
                    # directoryHTML = directoryHTML + '<tr><td><a href="' + str(name_href_url_string) + '">' + str(item) + '</a></td><td></td><td></td><td><a href="' + str(delete_href_url_string) + '">刪除</a></td></tr>'
                # else:

            # 同步讀取硬盤 .html 文檔，返回字符串;
            if os.path.exists(web_path_index_Html) and os.path.isfile(web_path_index_Html):

                # 使用Python原生模組os判斷文檔或目錄是否可讀os.R_OK、可寫os.W_OK、可執行os.X_OK;
                if not (os.access(web_path_index_Html, os.R_OK) and os.access(web_path_index_Html, os.W_OK)):
                    try:
                        # 修改文檔權限 mode:777 任何人可讀寫;
                        os.chmod(web_path_index_Html, stat.S_IRWXU | stat.S_IRWXG | stat.S_IRWXO)
                        # os.chmod(web_path_index_Html, stat.S_ISVTX)  # 修改文檔權限 mode: 440 不可讀寫;
                        # os.chmod(web_path_index_Html, stat.S_IROTH)  # 修改文檔權限 mode: 644 只讀;
                        # os.chmod(web_path_index_Html, stat.S_IXOTH)  # 修改文檔權限 mode: 755 可執行文檔不可修改;
                        # os.chmod(web_path_index_Html, stat.S_IWOTH)  # 可被其它用戶寫入;
                        # stat.S_IXOTH:  其他用戶有執行權0o001
                        # stat.S_IWOTH:  其他用戶有寫許可權0o002
                        # stat.S_IROTH:  其他用戶有讀許可權0o004
                        # stat.S_IRWXO:  其他使用者有全部許可權(許可權遮罩)0o007
                        # stat.S_IXGRP:  組用戶有執行許可權0o010
                        # stat.S_IWGRP:  組用戶有寫許可權0o020
                        # stat.S_IRGRP:  組用戶有讀許可權0o040
                        # stat.S_IRWXG:  組使用者有全部許可權(許可權遮罩)0o070
                        # stat.S_IXUSR:  擁有者具有執行許可權0o100
                        # stat.S_IWUSR:  擁有者具有寫許可權0o200
                        # stat.S_IRUSR:  擁有者具有讀許可權0o400
                        # stat.S_IRWXU:  擁有者有全部許可權(許可權遮罩)0o700
                        # stat.S_ISVTX:  目錄裡檔目錄只有擁有者才可刪除更改0o1000
                        # stat.S_ISGID:  執行此檔其進程有效組為檔所在組0o2000
                        # stat.S_ISUID:  執行此檔其進程有效使用者為檔所有者0o4000
                        # stat.S_IREAD:  windows下設為唯讀
                        # stat.S_IWRITE: windows下取消唯讀
                    except OSError as error:
                        print(f'Error: {str(web_path_index_Html)} : {error.strerror}')
                        print("請求的文檔 [ " + str(web_path_index_Html) + " ] 無法修改為可讀可寫權限.")

                        response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 無法修改為可讀可寫權限."
                        response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } cannot modify to read and write permission."

                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String

                fd = open(web_path_index_Html, mode="r", buffering=-1, encoding="utf-8", errors=None, newline=None, closefd=True, opener=None)
                # fd = open(web_path_index_Html, mode="rb+")
                try:
                    file_data = fd.read()
                    # file_data = fd.read().decode("utf-8")
                    # data_Bytes = file_data.encode("utf-8")
                    # fd.write(data_Bytes)
                except FileNotFoundError:
                    print("請求的文檔 [ " + str(web_path_index_Html) + " ] 不存在.")
                    response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path_index_Html) + " 不存在或者無法識別."
                    response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } unrecognized."
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                except PersmissionError:
                    print("請求的文檔 [ " + str(web_path_index_Html) + " ] 沒有打開權限.")
                    response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 沒有打開權限."
                    response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } unable to read."
                    # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                    response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                    # 使用加號（+）拼接字符串;
                    # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                    # print(response_data_String)
                    return response_data_String
                except Exception as error:
                    if("[WinError 32]" in str(error)):
                        print("請求的文檔 [ " + str(web_path_index_Html) + " ] 無法讀取數據.")
                        print(f'Error: {str(web_path_index_Html)} : {error.strerror}')
                        response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 無法讀取數據."
                        response_data_Dict["error"] = f'Error: {str(web_path_index_Html)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String
                    else:
                        print(f'Error: {str(web_path_index_Html)} : {error.strerror}')
                        response_data_Dict["Server_say"] = "請求的文檔 [ " + str(web_path_index_Html) + " ] 讀取數據發生錯誤."
                        response_data_Dict["error"] = f'Error: {str(web_path_index_Html)} : {error.strerror}'
                        # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                        response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                        # 使用加號（+）拼接字符串;
                        # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                        # print(response_data_String)
                        return response_data_String
                finally:
                    fd.close()
                # 注：可以用try/finally語句來確保最後能關閉檔，不能把open語句放在try塊裡，因為當打開檔出現異常時，檔物件file_object無法執行close()方法;

            else:

                print("請求的文檔: " + str(web_path_index_Html) + " 不存在或者無法識別.")

                response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path_index_Html) + " 不存在或者無法識別."
                response_data_Dict["error"] = "File = { " + str(web_path_index_Html) + " } unrecognized."

                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String


            # 替換 .html 文檔中指定的位置字符串;
            if file_data != "":
                response_data_String = str(file_data.replace("<!-- directoryHTML -->", directoryHTML))  # 函數 "String".replace("old", "new") 表示在指定字符串 "String" 中查找 "old" 子字符串並將之替換為 "new" 字符串;
            else:
                response_data_Dict["Server_say"] = "文檔: " + str(web_path_index_Html) + " 爲空."
                response_data_Dict["error"] = "File ( " + str(web_path_index_Html) + " ) empty."
                # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
                response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
                # 使用加號（+）拼接字符串;
                # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
                # print(response_data_String)
                return response_data_String

            return response_data_String

        else:

            print("請求的文檔: " + str(web_path) + " 不存在或者無法識別.")

            # response_data_Dict["Server_say"] = "請求的文檔: " + str(web_path) + " 不存在或者無法識別."
            response_data_Dict["Server_say"] = "請求的文檔: " + str(request_Path) + " 不存在或者無法識別."
            # response_data_Dict["error"] = "File = { " + str(web_path) + " } unrecognized."
            response_data_Dict["error"] = "File = { " + str(request_Path) + " } unrecognized."

            # 使用 Python 原生 JSON 模組中的 json.dumps() 函數將 Python 字典（Dict）對象轉換爲 JSON 字符串;
            response_data_String = json.dumps(response_data_Dict)  # 將JOSN對象轉換為JSON字符串;
            # 使用加號（+）拼接字符串;
            # response_data_String = "{" + "\"" + "request_Url" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url"]) + "\"" + "," + "\"" + "request_Path" + "\"" + ":" + "\"" + str(response_data_Dict["request_Path"]) + "\"" + "," + "\"" + "request_Url_Query_String" + "\"" + ":" + "\"" + str(response_data_Dict["request_Url_Query_String"]) + "\"" + "," + "\"" + "request_POST" + "\"" + ":" + "\"" + str(response_data_Dict["request_POST"]) + "\"" + "," + "\"" + "request_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["request_Authorization"]) + "\"" + "," + "\"" + "request_Cookie" + "\"" + ":" + "\"" + str(response_data_Dict["request_Cookie"]) + "\"" + "," + "\"" + "request_Nikename" + "\"" + ":" + "\"" + str(response_data_Dict["request_Nikename"]) + "\"" + "," + "\"" + "request_Password" + "\"" + ":" + "\"" + str(response_data_Dict["request_Password"]) + "\"" + "," + "\"" + "Server_Authorization" + "\"" + ":" + "\"" + str(response_data_Dict["Server_Authorization"]) + "\"" + "," + "\"" + "Server_say" + "\"" + ":" + "\"" + str(response_data_Dict["Server_say"]) + "\"" + "," + "\"" + "error" + "\"" + ":" + "\"" + str(response_data_Dict["error"]) + "\"" + "," + "\"" + "time" + "\"" + ":" + "\"" + str(response_data_Dict["time"]) + "\"" + "}"  # 使用星號*拼接字符串;
            # print(response_data_String)
            return response_data_String

        # return response_data_String


# # 函數使用示例;
# # 控制臺命令行使用:
# # C:\>C:\Criss\Python\Python38\python.exe C:\Criss\py\src\Router.py
# # C:\>C:\Criss\py\Scripts\python.exe C:\Criss\py\src\Router.py
# # 啓動運行;
# # 參數 C:\Criss\py\Scripts\python.exe 表示使用隔離環境 py 中的 python.exe 啓動運行;
# # 使用示例，自定義類 http_Server Web 服務器使用説明;
# if __name__ == '__main__':
#     # os.chdir('./static/')  # 可以先改變工作目錄到 static 路徑;
#     try:
#         webPath = str(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))  # str(os.path.abspath("."))  # "C:/Criss/py/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
#         # webPath = str(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "html"))  # os.path.join(str(os.path.abspath(".")), 'html')  # "C:/Criss/py/src/html/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
#         host = "::0"  # "::0"、"::1"、"::" 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
#         port = int(10001)  # 監聽埠號 1 ~ 65535;
#         # monitoring = (host, port)
#         Key = "username:password"
#         Session = {
#             "request_Key->username:password": Key
#         }
#         Is_multi_thread = True
#         do_Function = do_Request
#         do_Function_obj = {
#             "do_Function": do_Function
#         }
#         number_Worker_process = int(2)

#         Interface_http_Server = Interface_http_Server(
#             host = host,
#             port = port,
#             Is_multi_thread = Is_multi_thread,
#             Key = Key,
#             Session = Session,
#             # do_Function_obj = do_Function_obj,
#             do_Function = do_Function,
#             number_Worker_process = number_Worker_process
#         )
#         # Interface_http_Server = Interface_http_Server()
#         Interface_http_Server.run()

#     except Exception as error:
#         print(error)



# 示例函數，處理從服務器響應值讀取到的數據，然後返回處理之後的結果字符串數據的;
def do_Response(response_Dict):
    # response_Dict = {
    #     "response_status": 200,
    #     "response_message": "successful",
    #     "response_body_string": response_form_value,
    #     "Client_IP": Client_IP,
    #     "request_Url": request_Url,
    #     # "request_Path": request_Path,
    #     "require_Authorization": self.request_Key,
    #     "require_Cookie": self.Cookie_value,
    #     # "Server_Authorization": Key,
    #     "time": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
    #     "request_body_string": request_form_value
    # }

    # print(type(response_Dict))
    # print(response_Dict)

    response_data_JSON = response_Dict

    # print(require_data_String)
    # print(typeof(require_data_String))

    Server_say = ""
    # 使用函數 isinstance(response_Dict, dict) 判斷傳入的參數 response_Dict 是否為 dict 字典（JSON）格式對象;
    if isinstance(response_Dict, dict):
        # 使用 JSON.__contains__("key") 或 "key" in JSON 判断某个"key"是否在JSON中;
        if (response_Dict.__contains__("Server_say")):
            Server_say = response_Dict["Server_say"]
        else:
            Server_say = ""
            # print('服務端發送的響應 JSON 對象中無法找到目標鍵(key)信息 ["Server_say"].')
            # print(response_Dict)
    else:
        Server_say = response_Dict
    # print(Server_say)

    now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    # print(str(now_date))

    # response_data_JSON = {
    #     "Server_say": Server_say,
    #     "require_Authorization": "",
    #     "time": str(now_date)
    # }
    # # check_json_format(request_data_JSON);
    # # String = json.dumps(JSON); JSON = json.loads(String);

    response_data_String = Server_say
    if isinstance(response_data_JSON, dict):
        response_data_String = json.dumps(response_data_JSON)  # 將JOSN對象轉換為JSON字符串;

    # response_data_String = str(rresponse_data_String, encoding="utf-8")  # str("", encoding="utf-8") 强制轉換為 "utf-8" 編碼的字符串類型數據;
    # .encode("utf-8")將字符串（str）對象轉換為 "utf-8" 編碼的二進制字節流（<bytes>）類型數據;
    response_data_bytes = response_data_String.encode("utf-8")
    response_data_String_len = len(bytes(response_data_String, "utf-8"))

    return response_data_String


# # 使用示例，自定義函數 http_Client Web 客戶端使用説明;
# # 這裏是需要向Python服務器發送的參數數據JSON對象;
# now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
# # print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
# argument = "How_are_you_!"
# if argument.find("_", 0, int(len(argument)-1)):
#     Python_say = argument.replace("_", " ")  # 將傳入參數字符串中的"_"字符替換為空" "字符
# post_Data_JSON = {
#     "Client_say": Python_say,
#     "time": str(now_date)
# }
# # post_Data_String = '{\\"Client_say\\":\\"' + argument + '\\",\\"time\\":\\"' + time + '\\"}'  # change the javascriptobject to jsonstring;
# post_Data_String = json.dumps(post_Data_JSON)

# # 讀取傳入的服務器主機 IP 參數;
# Host = "::1"  # "127.0.0.1"、"localhost";
# # 讀取傳入的服務器監聽端口號碼參數;
# Port = int(10001)  # 監聽埠號 1 ~ 65535;
# # 請求路徑;
# URL = "/"  # 根目錄 "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
# # 請求方法
# Method = "POST"  # "GET"
# # 鏈接請求等待時長，單位（秒）;
# time_out = float(0.5)  # 10 鏈接請求等待時長，單位（秒）;

# request_Auth = "username:password"
# # request_Auth = bytes(request_Auth, encoding="utf-8")
# # request_Authorization_Base64 = "Basic " + base64.b64encode(request_Auth, altchars=None)  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
# # request_Auth = str(base64.b64decode(request_Authorization_Base64.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
# # 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
# # base64.b64encode(s, altchars=None)
# # 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
# # base64.b64decode(s, altchars=None, validate=False)

# request_Cookie = "Session_ID=request_Key->username:password"
# # Cookie_key = request_Cookie.split("=", -1)[0]  # "Session_ID"
# # Cookie_value = request_Cookie.split("=", -1)[1]  # "request_Key->username:password"
# # Cookie_value = bytes(Cookie_value, encoding="utf-8")
# # request_Cookie_Base64 = Cookie_key + "=" + base64.b64encode(Cookie_value, altchars=None)  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# # request_Cookie = Cookie_key + "=" + str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"
# # # request_Cookie = bytes(request_Cookie, encoding="utf-8")
# # # request_Cookie_Base64 = "Session_ID=" + base64.b64encode(request_Cookie, altchars=None)  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# # # request_Cookie = str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"

# # print(str(now_date) + " " + "http://" + Host + ":" + str(Port) + URL + " " + Method + " @" + str(request_Auth) + " " + str(request_Cookie))
# # print("Client say: " + Python_say)

# try:
#     result = Interface_http_Client(Host, Port, URL, Method, request_Auth, request_Cookie, post_Data_String, time_out)
#     # print(type(result))
#     # print(result)
#     Response_status = result[0]
#     # print(Response_status)
#     Response_headers_JSON = result[1]
#     # print(Response_headers_JSON)
#     Response_body_str = result[2]
#     # print(Response_body_str)
# except Exception as error:
#     print(error)

# # # 讀出響應頭中 Set-Cookie 參數值 # "Session_ID=request_Key->username:password";
# # Response_headers_Set_Cookie = Response_headers_JSON["Set-Cookie"]
# # # print("response Headers Set-Cookie: " + str(Response_headers_Set_Cookie))
# # if Response_headers_Set_Cookie != None and Response_headers_Set_Cookie != "" and isinstance(Response_headers_Set_Cookie, str):

# #     cookieName = ""
# #     # if Response_headers_Set_Cookie.find(",", 0, int(len(Response_headers_Set_Cookie)-1)) != -1:
# #     #     Response_headers_Set_Cookie = Response_headers_Set_Cookie.split(",", -1)[0]

# #     if Response_headers_Set_Cookie.find(";", 0, int(len(Response_headers_Set_Cookie)-1)) != -1:
# #         # 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;
# #         cookieName = Response_headers_Set_Cookie.split(";", -1)[0]
# #     else:
# #         cookieName = Response_headers_Set_Cookie

# #     if cookieName.find("=", 0, int(len(cookieName)-1)) != -1:
# #         request_Cookie_name = cookieName.split("=", -1)[0]
# #         request_Cookie_value = ""
# #         for index in range(len(cookieName.split("=", -1))-int(1)):
# #             if index == 0:
# #                 request_Cookie_value = request_Cookie_value + str(cookieName.split("=", -1)[int(index) + int(1)])
# #             else:
# #                 request_Cookie_value = request_Cookie_value + "=" + str(cookieName.split("=", -1)[int(index) + int(1)])
# #         # request_Cookie = cookieName.split("=", -1)[0] + "=" + str(base64.b64decode(cookieName.split("=", -1)[1], altchars=None, validate=False), encoding="utf-8")
# #         # request_Cookie = request_Cookie_name + "=" + str(base64.b64decode(request_Cookie_value, altchars=None, validate=False), encoding="utf-8")
# #         # Cookie_key = request_Cookie.split("=", -1)[0]  # "Session_ID"
# #         # Cookie_value = request_Cookie.split("=", -1)[1]  # "request_Key->username:password"
# #         # Cookie_value = bytes(Cookie_value, encoding="utf-8")
# #         # request_Cookie_Base64 = Cookie_key + "=" + str(base64.b64encode(Cookie_value, altchars=None), encoding="utf-8")  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# #     # else:
# #     #     request_Cookie = str(base64.b64decode(cookieName, altchars=None, validate=False), encoding="utf-8")
# #     # print(request_Cookie)  # "Session_ID=request_Key->username:password"
# #     print(request_Cookie_value)  # "request_Key->username:password"

# # # 讀出響應頭中 www-authenticate 參數值 # 'www-authenticate': 'Basic realm="domain name -> username:password"';
# # Response_headers_www_authenticate = Response_headers_JSON["www-authenticate"]
# # # print("response Headers www-authenticate: " + str(Response_headers_www_authenticate))
# # if Response_headers_www_authenticate != None and Response_headers_www_authenticate != "" and isinstance(Response_headers_www_authenticate, str):

# #     wwwauthenticate_Value = ""
# #     if Response_headers_www_authenticate.find("Basic realm=", 0, int(len(Response_headers_www_authenticate)-1)) != -1:
# #         # 提取響應頭中"set-cookie"參數中的"name=value"部分，作爲下次請求的頭文件中的"Cookie":"set-cookie"值發送;
# #         wwwauthenticate_Value = Response_headers_www_authenticate.split("Basic realm=", -1)[1]  # 'www-authenticate': 'Basic realm="domain name -> username:password"';
# #         # request_Auth = wwwauthenticate_Value.split(" -> ", -1)[1]  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
# #         # # request_Auth = bytes(request_Auth, encoding="utf-8")
# #         # # request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
# #     else:
# #         wwwauthenticate_Value = Response_headers_www_authenticate
# #         # request_Auth = wwwauthenticate_Value.split(" -> ", -1)[1]  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
# #         # # request_Auth = bytes(request_Auth, encoding="utf-8")
# #         # # request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;

# #     if wwwauthenticate_Value.find(" -> ", 0, int(len(wwwauthenticate_Value)-1)) != -1:
# #         request_Auth_name = wwwauthenticate_Value.split(" -> ", -1)[0]
# #         request_Auth_value = ""
# #         for index in range(len(wwwauthenticate_Value.split(" -> ", -1))-int(1)):
# #             request_Auth_value = request_Auth_value + str(wwwauthenticate_Value.split(" -> ", -1)[int(index) + int(1)])
# #         # wwwauthenticate_Value = wwwauthenticate_Value.split(" -> ", -1)[0] + " -> " + str(base64.b64decode(wwwauthenticate_Value.split(" -> ", -1)[1], altchars=None, validate=False), encoding="utf-8")
# #         # wwwauthenticate_Value = request_Auth_name + " -> " + str(base64.b64decode(request_Auth_value, altchars=None, validate=False), encoding="utf-8")
# #         # request_Auth = request_Auth_value  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
# #         # request_Auth = str(base64.b64decode(request_Auth_value, altchars=None, validate=False), encoding="utf-8")
# #         # request_Auth = wwwauthenticate_Value.split(" -> ", -1)[1]  # 提取響應頭中"www-authenticate"參數中的"Basic realm="的值部分，作爲下次請求的頭文件中的"authenticate"值發送;
# #         # request_Auth = bytes(request_Auth, encoding="utf-8")
# #         # request_Authorization_Base64 = "Basic " + str(base64.b64encode(request_Auth, altchars=None), encoding="utf-8")  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
# #     # else:
# #     #     request_Auth = wwwauthenticate_Value
# #         # request_Auth = str(base64.b64decode(wwwauthenticate_Value, altchars=None, validate=False), encoding="utf-8")
# #     print(wwwauthenticate_Value)  # "domain name -> username:password";
# #     # print(request_Auth)  # "username:password";

# # Response_headers_location = Response_headers_JSON["location"]
# # print("response Headers location: " + str(Response_headers_location))
# # # /^https?:\/\//.test(response.headers["location"]);  // 使用正則表達式判斷網址 URL 格式是否正確;

# if str(Response_status) == str(200) and isinstance(Response_body_str, str) and check_json_format(Response_body_str):
#     Response_body_JSON = json.loads(Response_body_str)
#     # String = json.dumps(JSON); JSON = json.loads(String); check_json_format(JSON_String);
#     if "Server_say" in Response_body_JSON:
#         print(Response_body_JSON["Server_say"])
#     else:
#         print(Response_body_JSON)
# else:
#     print(Response_body_str)



# 函數使用示例;
# 控制臺命令行使用:
# C:\>C:\Criss\Python\Python38\python.exe C:/Criss/py/application.py
# C:\>C:\Criss\py\Scripts\python.exe C:/Criss/py/application.py
# 啓動運行;
# 參數 C:\Criss\py\Scripts\python.exe 表示使用隔離環境 py 中的 python.exe 啓動運行;

# 配置預設值;
interface_Function = Interface_File_Monitor  # Interface_File_Monitor  # Interface_http_Server  # Interface_http_Client;
interface_Function_name_str = "Interface_File_Monitor"  # "Interface_File_Monitor"  # "Interface_http_Server"  # "Interface_http_Client"

# 配置當 interface_Function = Interface_File_Monitor 時的預設值;
# os.path.realpath(__file__)  # 獲取當前Python脚本文檔名稱;
# os.linesep  # 返回當前平臺換行符號;
# "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸入傳值的媒介目錄;
monitor_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "Intermediary")  # os.path.join(os.path.abspath(".."), "Intermediary")
# monitor_dir = pathlib.Path(os.path.abspath("..") + "temp")  # pathlib.Path("../temp/")
monitor_file = os.path.join(monitor_dir, "intermediary_write_C")  # "../temp/intermediary_write_Node.txt" 用於接收傳值的媒介文檔;
# os.path.abspath(".")  # 獲取當前文檔所在的絕對路徑;
# os.path.abspath("..")  # 獲取當前文檔所在目錄的上一層路徑;
temp_cache_IO_data_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "temp")  # os.path.join(os.path.abspath(".."), "temp")  # 需要注意目錄操作權限，用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
number_Worker_process = int(4)  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
output_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "Intermediary")  # os.path.join(os.path.abspath(".."), "Intermediary")  # "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
output_file = os.path.join(str(output_dir), "intermediary_write_Python.txt")  # "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
to_executable = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "NodeJS", "node.exe")  # os.path.join(os.path.abspath(".."), "/NodeJS/", "node.exe")  # "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
to_script = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "js", "test.js")  # os.path.join(os.path.abspath(".."), "/js/", "test.js")  # "../js/test.js" 用於執行功能的被調用的脚步文檔;
return_obj = {
    "output_dir": output_dir,  # os.path.join(os.path.abspath(".."), "/temp/"), "D:\\temp\\"，"../temp/" 需要注意目錄操作權限，用於輸出傳值的媒介目錄;
    "output_file": output_file,  # os.path.join(str(return_obj["output_dir"]), "intermediary_write_Python.txt"),  "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
    "to_executable": to_executable,  # os.path.join(os.path.abspath(".."), "/NodeJS/", "nodejs/node.exe"),  "C:\\NodeJS\\nodejs\\node.exe"，"../NodeJS/nodejs/node.exe" 用於對返回數據執行功能的解釋器可執行文件;
    "to_script": to_script  # os.path.join(os.path.abspath(".."), "/js/", "test.js"),  "../js/test.js" 用於執行功能的被調用的脚步文檔;
}
return_obj["output_file"] = os.path.join(return_obj["output_dir"], "intermediary_write_Python.txt")  # "../temp/intermediary_write_Python.txt" 用於輸出傳值的媒介文檔;
is_monitor = True  # 判斷是只需要執行一次還是啓動監聽服務器，可取值為：True、False;
is_Monitor_Concurrent = "Multi-Threading"  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值為：0、"0"、"Multi-Threading"、"Multi-Processes";
time_sleep = float(0.02)  # 用於監聽程序的輪詢延遲參數，單位（秒）;
# 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
# read_file_do_Function = read_and_write_file_do_Function  # None 或自定義的示例函數 read_and_write_file_do_Function，用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
read_file_do_Function_data = read_and_write_file_do_Function  # None 或自定義的示例函數 read_and_write_file_do_Function，用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
# 預設的可能被推入子進程執行功能的函數，可以在類實例化的時候輸入參數修改;
def temp_default_doFunction(arguments):
    return arguments
do_Function_data = do_data  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數， do_data 用於接收執行功能的函數;
# do_Function = temp_default_doFunction  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數， do_data 用於接收執行功能的函數;
do_Function_obj_data = {
    "do_Function": do_Function_data,  # 用於接收執行功能的函數;
    "read_file_do_Function": read_file_do_Function_data  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數;
}
do_Function_name_str_data = "do_data"
read_file_do_Function_name_str_data = "read_and_write_file_do_Function"

# 配置當 interface_Function = Interface_http_Server 時的預設值;
webPath = str(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))  # str(os.path.abspath("."))  # "C:/Criss/py/src/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
# webPath = str(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "html"))  # os.path.join(str(os.path.abspath(".")), 'html')  # "C:/Criss/py/src/html/" 服務器運行的本地硬盤根目錄，可以使用函數當前目錄：os.path.abspath(".")，函數 os.path.abspath("..") 表示目錄的上一層目錄，函數 os.path.join(os.path.abspath(".."), "/temp/") 表示拼接路徑字符串，函數 pathlib.Path(os.path.abspath("..") + "/temp/") 表示拼接路徑字符串;
host = "::0"  # "::0"、"::1"、"::" 設定為'0.0.0.0'表示監聽全域IP位址，局域網内全部計算機客戶端都可以訪問，如果設定為'127.0.0.1'則只能本機客戶端訪問
port = int(10001)  # 監聽埠號 1 ~ 65535;
# monitoring = (host, port)
Key = "username:password"
Session = {
    "request_Key->username:password": Key
}
Session_name_str = ""
Is_multi_thread = True
do_Function_Request = do_Request  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數，do_GET_root_directory 用於接收執行功能的函數;
# do_Function = temp_default_doFunction  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數，do_POST_root_directory 用於接收執行功能的函數
do_Function_obj_Request = {
    "do_Function": do_Function_Request
}
number_Worker_process = int(0)  # int(2)
do_Function_name_str_Request = "do_Request"

# 配置當 interface_Function = Interface_http_Client 時的預設值;
now_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
# print(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"))  # after_30_Days = (datetime.datetime.now() + datetime.timedelta(days=30)).strftime("%Y-%m-%d %H:%M:%S.%f")，time.strftime("%Y-%m-%d %H:%M:%S", time.localtime());
post_Data_JSON = {
    "Client_say": "Python 3.10.6 http.client.HTTPConnection()",
    "time": str(now_date)
}
# post_Data_String = '{\\"Client_say\\":\\"' + argument + '\\",\\"time\\":\\"' + time + '\\"}'  # change the javascriptobject to jsonstring;
post_Data_String = json.dumps(post_Data_JSON)
# print("Client say: " + post_Data_String)
do_Function_Response = do_Response  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數，do_Response 用於接收執行功能的函數;
# do_Function = temp_default_doFunction  # lambda arguments:arguments  # 用於接收執行功能的函數，其中 lambda 表示聲明匿名函數，do_Response 用於接收執行功能的函數
do_Function_name_str_Response = "do_Response"
# 讀取傳入的服務器主機 IP 參數;
Host = "::1"  # "127.0.0.1"、"localhost";
# 讀取傳入的服務器監聽端口號碼參數;
Port = int(10001)  # 監聽埠號 1 ~ 65535;
# 請求路徑;
URL = "/"  # 根目錄 "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
# 請求方法
Method = "POST"  # "GET"
# 鏈接請求等待時長，單位（秒）;
time_out = float(0.5)  # 10 鏈接請求等待時長，單位（秒）;
request_Auth = "username:password"
# request_Auth = bytes(request_Auth, encoding="utf-8")
# request_Authorization_Base64 = "Basic " + base64.b64encode(request_Auth, altchars=None)  # request_Auth = "username:password" 使用自定義函數Base64()編碼加密驗證賬號信息;
# request_Auth = str(base64.b64decode(request_Authorization_Base64.split("Basic ", -1)[1], altchars=None, validate=False), encoding="utf-8")
# 使用base64編碼類似位元組的物件（字節對象）「s」，並返回一個位元組物件（字節對象），可選 altchars 應該是長度為2的位元組串，它為'+'和'/'字元指定另一個字母表，這允許應用程式，比如，生成url或檔案系統安全base64字串;
# base64.b64encode(s, altchars=None)
# 解碼 base64 編碼的位元組類物件（字節對象）或 ASCII 字串「s」，可選的 altchars 必須是一個位元組類物件或長度為2的ascii字串，它指定使用的替代字母表，替代'+'和'/'字元，返回位元組物件，如果「s」被錯誤地填充，則會引發 binascii.Error，如果 validate 為 false（默認），則在填充檢查之前，既不在正常的base-64字母表中也不在替代字母表中的字元將被丟棄，如果 validate 為 True，則輸入中的這些非字母表字元將導致 binascii.Error;
# base64.b64decode(s, altchars=None, validate=False)
request_Cookie = "Session_ID=request_Key->username:password"
# Cookie_key = request_Cookie.split("=", -1)[0]  # "Session_ID"
# Cookie_value = request_Cookie.split("=", -1)[1]  # "request_Key->username:password"
# Cookie_value = bytes(Cookie_value, encoding="utf-8")
# request_Cookie_Base64 = Cookie_key + "=" + base64.b64encode(Cookie_value, altchars=None)  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# request_Cookie = Cookie_key + "=" + str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"
# # request_Cookie = bytes(request_Cookie, encoding="utf-8")
# # request_Cookie_Base64 = "Session_ID=" + base64.b64encode(request_Cookie, altchars=None)  # 使用自定義函數Base64()編碼請求 Cookie 信息，"Session_ID=" + base64.b64encode("request_Key->username:password", altchars=None)
# # request_Cookie = str(base64.b64decode(request_Cookie_Base64.split("Session_ID=", -1)[1], altchars=None, validate=False), encoding="utf-8")  # "request_Key->username:password"
# print(str(now_date) + " " + "http://" + Host + ":" + str(Port) + URL + " " + Method + " @" + str(request_Auth) + " " + str(request_Cookie))

# 控制臺傳參，通過 sys.argv 數組獲取從控制臺傳入的參數
# print(type(sys.argv))
# print(sys.argv)
if len(sys.argv) > 1:
    for i in range(len(sys.argv)):
        # print('arg '+ str(i), sys.argv[i])  # 通過 sys.argv 數組獲取從控制臺傳入的參數
        if i > 0:
            # 使用函數 isinstance(sys.argv[i], str) 判斷傳入的參數是否為 str 字符串類型 type(sys.argv[i]);
            if isinstance(sys.argv[i], str) and sys.argv[i] != "" and sys.argv[i].find("=", 0, int(len(sys.argv[i])-1)) != -1:

                if sys.argv[i].split("=", -1)[0] == "interface_Function":
                    # interface_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    # interface_Function_name_str = sys.argv[i].split("=", -1)[1]
                    # type(Interface_File_Monitor).__name__ == 'classobj' 判斷是否為類，isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(sys.argv[i].split("=", -1)[1], str) and sys.argv[i].split("=", -1)[1] != "" and sys.argv[i].split("=", -1)[1] == "file_Monitor":
                        # if type(Interface_File_Monitor).__name__ == 'classobj':
                        #     interface_Function = Interface_File_Monitor
                        #     interface_Function_name_str = "Interface_File_Monitor"
                        interface_Function = Interface_File_Monitor
                        interface_Function_name_str = "Interface_File_Monitor"
                    if isinstance(sys.argv[i].split("=", -1)[1], str) and sys.argv[i].split("=", -1)[1] != "" and sys.argv[i].split("=", -1)[1] == "http_Server":
                        # if type(Interface_http_Server).__name__ == 'classobj':
                        #     interface_Function = Interface_http_Server
                        #     interface_Function_name_str = "Interface_http_Server"
                        interface_Function = Interface_http_Server
                        interface_Function_name_str = "Interface_http_Server"
                    if isinstance(sys.argv[i].split("=", -1)[1], str) and sys.argv[i].split("=", -1)[1] != "" and sys.argv[i].split("=", -1)[1] == "http_Client":
                        # if type(Interface_http_Client).__name__ == 'classobj':
                        #     interface_Function = Interface_http_Client
                        #     interface_Function_name_str = "Interface_http_Client"
                        interface_Function = Interface_http_Client
                        interface_Function_name_str = "Interface_http_Client"
                    # print("interface Function:", interface_Function_name_str)
                    # print("interface Function:", sys.argv[i].split("=", -1)[1])
                    continue
                # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 read_file_do_Function = "read_and_write_file_do_Function";
                elif sys.argv[i].split("=", -1)[0] == "read_file_do_Function":
                    # read_file_do_Function = sys.argv[i].split("=", -1)[1]  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 "read_and_write_file_do_Function";
                    read_file_do_Function_name_str = sys.argv[i].split("=", -1)[1]  # 用於讀取輸入文檔中的數據和將處理結果寫入輸出文檔中的函數 "read_and_write_file_do_Function";
                    # isinstance(read_file_do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(read_file_do_Function_name_str, str) and read_file_do_Function_name_str != "":
                        if read_file_do_Function_name_str == "read_and_write_file_do_Function" and inspect.isfunction(read_and_write_file_do_Function):
                            read_file_do_Function_name_str_data = "read_and_write_file_do_Function"
                            read_file_do_Function_data = read_and_write_file_do_Function
                            # read_file_do_Function = read_and_write_file_do_Function
                        # else:
                    # print("read and write file do Function:", read_file_do_Function)
                    continue
                # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                # 用於接收執行功能的函數 do_Function = "do_data";
                elif sys.argv[i].split("=", -1)[0] == "do_Function":
                    # do_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    do_Function_name_str = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(do_Function_name_str, str) and do_Function_name_str != "":
                        if do_Function_name_str == "do_data" and inspect.isfunction(do_data):
                            do_Function_name_str_data = "do_data"
                            do_Function_data = do_data
                            # do_Function = do_data
                        elif do_Function_name_str == "do_Request" and inspect.isfunction(do_Request):
                            do_Function_name_str_Request = "do_Request"
                            do_Function_Request = do_Request
                            # do_Function = do_Request
                        elif do_Function_name_str == "do_Response" and inspect.isfunction(do_Response):
                            do_Function_name_str_Response = "do_Response"
                            do_Function_Response = do_Response
                            # do_Function = do_Response
                        # else:
                    # print("do Function:", do_Function)
                    continue
                # 用於判斷是否啓動監聽媒介文檔服務器，還是只執行一次操作即退出 is_monitor = False;
                elif sys.argv[i].split("=", -1)[0] == "is_monitor":
                    # is_monitor = bool(sys.argv[i].split("=", -1)[1])  # 用於判斷是否啓動監聽媒介文檔服務器，還是只執行一次操作即退出 is_monitor = False;
                    is_monitor_name_str = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_data";
                    if isinstance(is_monitor_name_str, str) and is_monitor_name_str != "" and (is_monitor_name_str == "True" or is_monitor_name_str == "true" or is_monitor_name_str == "TRUE" or is_monitor_name_str == "1"):
                        is_monitor = True
                    if isinstance(is_monitor_name_str, str) and (is_monitor_name_str == "" or is_monitor_name_str == "False" or is_monitor_name_str == "false" or is_monitor_name_str == "FALSE" or is_monitor_name_str == "0"):
                        is_monitor = False
                    # print("is monitor:", is_monitor)
                    # print("is monitor:", sys.argv[i].split("=", -1)[1])
                    continue
                # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程）可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
                elif sys.argv[i].split("=", -1)[0] == "is_Monitor_Concurrent":
                    is_Monitor_Concurrent = str(sys.argv[i].split("=", -1)[1])  # 選擇監聽動作的函數是否並發（多協程、多綫程、多進程），可取值：is_Monitor_Concurrent = 0 or "0" or "Multi-Threading" or "Multi-Processes";
                    # print("Is Monitor Concurrent:", is_Monitor_Concurrent)
                    continue
                # 用於接收傳值的媒介文檔 monitor_file = "../temp/intermediary_write_Node.txt";
                elif sys.argv[i].split("=", -1)[0] == "monitor_file":
                    monitor_file = str(sys.argv[i].split("=", -1)[1])  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
                    # print("monitor file:", monitor_file)
                    continue
                # 用於輸入傳值的媒介目錄 monitor_dir = "../temp/";
                elif sys.argv[i].split("=", -1)[0] == "monitor_dir":
                    monitor_dir = str(sys.argv[i].split("=", -1)[1])  # 用於輸入傳值的媒介目錄 "../temp/";
                    # print("monitor dir:", monitor_dir)
                    continue
                # 用於暫存輸入輸出傳值文檔的媒介目錄 temp_cache_IO_data_dir = "../temp/";
                elif sys.argv[i].split("=", -1)[0] == "temp_cache_IO_data_dir":
                    temp_cache_IO_data_dir = str(sys.argv[i].split("=", -1)[1])  # 用於輸入傳值的媒介目錄 "../temp/";
                    # print("temp cache IO data file dir:", temp_cache_IO_data_dir)
                    continue
                # 用於輸出傳值的媒介目錄 monitor_dir = "../temp/";
                elif sys.argv[i].split("=", -1)[0] == "output_dir":
                    output_dir = str(sys.argv[i].split("=", -1)[1])  # 用於輸出傳值的媒介目錄 "../temp/";
                    # print("output dir:", output_dir)
                    continue
                # 用於輸出傳值的媒介文檔 output_file = "../temp/intermediary_write_Python.txt";
                elif sys.argv[i].split("=", -1)[0] == "output_file":
                    output_file = str(sys.argv[i].split("=", -1)[1])  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Python.txt";
                    # print("output file:", output_file)
                    continue
                # 用於對返回數據執行功能的解釋器可執行文件 to_executable = "C:\\NodeJS\\nodejs\\node.exe";
                elif sys.argv[i].split("=", -1)[0] == "to_executable":
                    to_executable = str(sys.argv[i].split("=", -1)[1])  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
                    # print("to executable:", to_executable)
                    continue
                # 用於對返回數據執行功能的被調用的脚本文檔 to_script = "../js/test.js";
                elif sys.argv[i].split("=", -1)[0] == "to_script":
                    to_script = str(sys.argv[i].split("=", -1)[1])  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
                    # print("to script:", to_script)
                    continue
                # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
                elif sys.argv[i].split("=", -1)[0] == "number_Worker_process":
                    number_Worker_process = int(sys.argv[i].split("=", -1)[1])  # 用於判斷生成子進程數目的參數 number_Worker_process = int(0);
                    # print("number Worker processes:", number_Worker_process)
                    continue
                # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
                elif sys.argv[i].split("=", -1)[0] == "time_sleep":
                    time_sleep = float(sys.argv[i].split("=", -1)[1])  # 用於監聽程序的輪詢延遲參數，單位（秒） time_sleep = float(0.02);
                    # print("Operation document time sleep:", time_sleep)
                    continue
                # 接收當 interface_Function = Interface_http_Server 時的傳入參數值;
                # http 服務器運行的根目錄 webPath = "C:/Criss/py/src/";
                if sys.argv[i].split("=", -1)[0] == "webPath":
                    webPath = str(sys.argv[i].split("=", -1)[1])  # http 服務器運行的根目錄 webPath = "C:/Criss/py/src/";
                    # print("webPath:", webPath)
                    continue
                # http 服務器監聽的IP地址 host = "0.0.0.0";
                elif sys.argv[i].split("=", -1)[0] == "host":
                    host = str(sys.argv[i].split("=", -1)[1])  # http 服務器監聽的IP地址 host = "0.0.0.0";
                    Host = str(sys.argv[i].split("=", -1)[1])  # http 用戶端鏈接器發送請求的目標IP地址 Host = "127.0.0.1";
                    # print("host:", host)
                    continue
                # http 服務器監聽的埠號 port = int(8000);
                elif sys.argv[i].split("=", -1)[0] == "port":
                    port = int(sys.argv[i].split("=", -1)[1])  # http 服務器監聽的埠號 port = int(8000);
                    Port = int(sys.argv[i].split("=", -1)[1])  # http 用戶端鏈接器發送請求的目標埠號 port = int(8000);
                    # print("port:", port)
                    continue
                # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
                elif sys.argv[i].split("=", -1)[0] == "Is_multi_thread":
                    Is_multi_thread = bool(sys.argv[i].split("=", -1)[1])  # 用於判斷是否啓動服務器多進程監聽客戶端訪問 Is_multi_thread = True;
                    # print("multi thread:", Is_multi_thread)
                    continue
                # 傳入客戶端訪問服務器時用於身份驗證的賬號和密碼 Key = "username:password";
                elif sys.argv[i].split("=", -1)[0] == "Key":
                    Key = str(sys.argv[i].split("=", -1)[1])  # 客戶端訪問服務器時的身份驗證賬號和密碼 Key = "username:password";
                    # print("Key:", Key)
                    continue
                # 用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
                elif sys.argv[i].split("=", -1)[0] == "Session":
                    Session_name_str = sys.argv[i].split("=", -1)[1]

                    # # 使用自定義函數check_json_format(raw_msg)判斷傳入參數sys.argv[1]是否為JSON格式的字符串
                    # if check_json_format(str(sys.argv[i].split("=", -1)[1])):
                    #     Session = json.loads(sys.argv[i].split("=", -1)[1], encoding='utf-8')  # 將讀取到的傳入參數字符串轉換爲JSON對象，用於傳入服務器對應 cookie 值的 session 對象（JSON 對象格式） Session = {"request_Key->username:password":Key};
                    # else:
                    #     print("控制臺傳入的 Session 參數 JSON 字符串無法轉換為 JSON 對象: " + sys.argv[i])

                    # isinstance(JSON, dict) 判斷是否為 JSON 對象類型數據;
                    if isinstance(Session_name_str, str) and Session_name_str != "" and Session_name_str == "Session" and isinstance(Session, dict):
                        Session = Session
                    # print("Session:", Session)
                    continue
                # 用於接收執行功能的函數 do_GET_Function = "do_GET_root_directory";
                elif sys.argv[i].split("=", -1)[0] == "do_GET_Function":
                    # do_GET_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_GET_root_directory";
                    do_GET_Function_name_str = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_GET_root_directory";
                    # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(do_GET_Function_name_str, str) and do_GET_Function_name_str != "" and do_GET_Function_name_str == "do_GET_root_directory" and inspect.isfunction(do_GET_root_directory):
                        do_GET_Function = do_GET_root_directory
                    # print("do GET Function:", do_GET_Function)
                    continue
                # 用於接收執行功能的函數 do_POST_Function = "do_POST_root_directory";
                elif sys.argv[i].split("=", -1)[0] == "do_POST_Function":
                    # do_POST_Function = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_POST_root_directory";
                    do_POST_Function_name_str = sys.argv[i].split("=", -1)[1]  # 用於接收執行功能的函數 "do_POST_root_directory";
                    # isinstance(do_Function, FunctionType)  # 使用原生模組 inspect 中的 isfunction() 方法判斷對象是否是一個函數，或者使用 hasattr(var, '__call__') 判斷變量 var 是否為函數或類的方法，如果是函數返回 True 否則返回 False;
                    if isinstance(do_POST_Function_name_str, str) and do_POST_Function_name_str != "" and do_POST_Function_name_str == "do_POST_root_directory" and inspect.isfunction(do_POST_root_directory):
                        do_POST_Function = do_POST_root_directory
                    # print("do POST Function:", do_POST_Function)
                    continue
                # 用於傳入 http 用戶端鏈接器發送請求的萬維網統一資源定位系統 ( Uniform Resource Locator ) 地址字符串參數，URL = "/"  # 根目錄 "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
                elif sys.argv[i].split("=", -1)[0] == "URL":
                    URL = str(sys.argv[i].split("=", -1)[1])  # 用於傳入 http 用戶端鏈接器發送請求的萬維網統一資源定位系統 ( Uniform Resource Locator ) 地址字符串參數，URL = "/"  # 根目錄 "/"，"http://localhost:8000"，"http://usename:password@localhost:8000/";
                    # print("URL:", URL)
                    continue
                # 用於傳入 http 用戶端鏈接器發送請求的類型參數，Method = "POST";
                elif sys.argv[i].split("=", -1)[0] == "Method":
                    Method = str(sys.argv[i].split("=", -1)[1])  # 用於傳入 http 用戶端鏈接器發送請求的類型參數，Method = "POST";
                    # print("request method:", Method)
                    continue
                # 用於 http 用戶端鏈接器發送請求時的超時長中止參數，單位（秒） time_out = float(0.5);
                elif sys.argv[i].split("=", -1)[0] == "time_out":
                    time_out = float(sys.argv[i].split("=", -1)[1])  # 用於 http 用戶端鏈接器發送請求時的超時長中止參數，單位（秒） time_out = float(0.5);
                    # print("request time out:", time_out)
                    continue
                # 傳入客戶端訪問服務器時用於身份驗證的賬號和密碼 request_Auth = "username:password";
                elif sys.argv[i].split("=", -1)[0] == "request_Auth":
                    request_Auth = str(sys.argv[i].split("=", -1)[1])  # http 用戶端鏈接器發送請求時的身份驗證賬號和密碼 request_Auth = "username:password";
                    # print("request Key:", request_Auth)
                    continue
                # 傳入客戶端訪問服務器時用於身份驗證的賬號和密碼 request_Cookie = "Session_ID=request_Key->username:password";
                elif sys.argv[i].split("=", -1)[0] == "request_Cookie":
                    request_Cookie = str(sys.argv[i].split("=", -1)[1])  # http 用戶端鏈接器發送請求時的身份驗證賬號和密碼 request_Cookie = "Session_ID=request_Key->username:password";
                    # print("request Cookie:", request_Cookie)
                    continue
                else:
                    # print(sys.argv[i], "unrecognized.")
                    continue

if interface_Function_name_str == "Interface_File_Monitor":
    monitor_Function = interface_Function(
        is_monitor=is_monitor,
        is_Monitor_Concurrent=is_Monitor_Concurrent,
        monitor_file=monitor_file,
        monitor_dir=monitor_dir,
        read_file_do_Function=read_file_do_Function_data,
        do_Function=do_Function_data,
        # do_Function_obj=do_Function_obj_data,
        output_dir=output_dir,
        output_file=output_file,
        to_executable=to_executable,
        to_script=to_script,
        # return_obj=return_obj,
        number_Worker_process=number_Worker_process,
        temp_cache_IO_data_dir=temp_cache_IO_data_dir,
        time_sleep=time_sleep
    )
elif interface_Function_name_str == "Interface_http_Server":
    monitor_Function = interface_Function(
        host=host,
        port=port,
        Is_multi_thread=Is_multi_thread,
        Key=Key,
        Session=Session,
        # do_Function_obj=do_Function_obj_Request,
        do_Function=do_Function_Request,
        number_Worker_process=number_Worker_process
    )
elif interface_Function_name_str == "Interface_http_Client":
    monitor_Function = interface_Function(
        Host,
        Port,
        URL,
        Method,
        request_Auth,
        request_Cookie,
        post_Data_String,
        time_out
    )
# else:

if interface_Function_name_str == "Interface_File_Monitor" or interface_Function_name_str == "Interface_http_Server":
    # monitor_Function = interface_Function()
    result_tuple = monitor_Function.run()
elif interface_Function_name_str == "Interface_http_Client":
    result_tuple = monitor_Function
# else:
# print(type(result_tuple))  # tuple;
# print(result_tuple[0])

return_file_creat_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
# print(str(return_file_creat_time))

result_text = ""
if interface_Function_name_str == "Interface_File_Monitor":

    if is_monitor == True:
        result_text = "code:0"

    if is_monitor == False:
        if isinstance(result_tuple, tuple) and len(result_tuple) == 3 and isinstance(result_tuple[1], str) and isinstance(result_tuple[2], str) and isinstance(do_Function_name_str_data, str) and do_Function_name_str_data != "":
            return_info_JSON = {
                "Python_say": {
                    "output_file": str(result_tuple[1]),
                    "monitor_file": str(result_tuple[2]),
                    "do_Function": str(do_Function_name_str_data)
                },
                "time": str(return_file_creat_time)
            }  # '{"Python_say":{"output_file":"' + str(result_tuple[2]) + '","monitor_file":"' + str(result_tuple[3]) + '","do_Function":""},"time":"' + str(return_file_creat_time) + '"}'
            result_text = "\n".join(['code:0', json.dumps(return_info_JSON)])  # json.loads(JSON_str);
        elif isinstance(result_tuple, tuple) and len(result_tuple) == 3 and isinstance(result_tuple[1], str) and isinstance(result_tuple[2], str):
            return_info_JSON = {
                "Python_say": {
                    "output_file": str(result_tuple[1]),
                    "monitor_file": str(result_tuple[2]),
                    "do_Function": ""
                },
                "time": str(return_file_creat_time)
            }  # '{"Python_say":{"output_file":"' + str(result_tuple[2]) + '","monitor_file":"' + str(result_tuple[3]) + '","do_Function":""},"time":"' + str(return_file_creat_time) + '"}'
            result_text = "\n".join(['code:0', json.dumps(return_info_JSON)])  # json.loads(JSON_str);
        else:
            result_text = "code:-1"

elif interface_Function_name_str == "Interface_http_Server":
    result_text = "code:0"
elif interface_Function_name_str == "Interface_http_Client":
    # print(type(result_tuple))  # tuple;
    sys.stdout.write(result_tuple[0])
    sys.stdout.write(result_tuple[1])
    sys.stdout.write(result_tuple[2])
    # result_text = "\n".join(['code:0', json.dumps(result_tuple)])
    # result_text = json.dumps(result_tuple)  # json.loads(JSON_str);
    result_text = "code:0"
# else:

# 將運算結果保存的目標文檔的信息，寫入控制臺標準輸出（顯示器），便於使主調程序獲取完成信號;
sys.stdout.write(result_text)  # 將運算結果寫到操作系統控制臺;
# print(result_text)  # 將運算結果寫到操作系統控制臺;
