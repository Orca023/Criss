## 阡陌交通 Criss, Interface
#### Node.js, Julia, Python, C
#### 混合編程 ( Hybrid Programming ), 程式設計語言 ( Computer Programming Language ) 之間, 使用外設硬盤 ( Hard Disk ) 或網卡 ( Network Interface Card ) 作橋, 跨語言 ( Cross Language ) 的數據交換 ( Information exchange pattern ), 就像十字路口一樣的阡陌交通.
---
<p word-wrap: break-word; word-break: break-all; overflow-x: hidden; overflow-x: hidden;>
1. 使用外設硬盤 ( Hard Disk ) 作橋, 創建監聽硬盤 ( Hard Disk ) 文檔 ( file ) 的伺服器 ( file_Monitor ), 監聽自定義指定的媒介文檔, 從自定義指定的輸入文檔 ( monitor_file ) 讀取數據 ( Data ), 經過運算 ( Data Processing ), 將運算結果 ( Data ) 寫入自定義指定的輸出文檔 ( output_file ), 從而完成一次跨語言 ( Cross Language ) 的數據交換 ( Information exchange ).

2. 使用外設網卡 ( Network Interface Card ) 作橋, 創建監聽伺服器 ( http_Server ), 創建用戶端鏈接器 ( http_Client ), 伺服器 ( http_Server ) 監聽指定網卡 ( Network Interface Card ) 的自定義的埠 ( Port ), 從指定的埠號讀取用戶端 ( http_Client ) 發送的請求數據 ( required ), 經過運算 ( Data Processing ), 將運算結果 ( Response ) 回饋至對應發送請求的用戶端 ( http_Client ), 從而完成一次跨語言 ( Cross Language ) 的數據交換 ( Information exchange ).
</p>

---

Node.js: Interface.js, application.js

語言 ( Node.js ) 解釋器 ( Interpreter ) 環境配置釋明:

Title: Node.js server v20161211

Explain: Node.js file server, Node.js http server, Node.js http client

Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30

Interpreter: node-v20.15.0-x64.msi, node-v20.15.0-x86.msi

Interpreter: node-v20.15.0-linux-x64.tar.gz

Operating system: google-pixel-2 android-11 termux-0.118 ubuntu-22.04-LTS-rootfs arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280

Interpreter: node-v20.15.0-linux-arm64.tar.gz

使用説明:

微軟視窗系統 ( Windows x86_64 ) 控制臺命令列 ( cmd ) 運行啓動指令:

C:\Criss> C:/Criss/NodeJS/nodejs-20.15.0/node.exe C:/Criss/js/application.js configFile=C:/Criss/config.txt webPath=C:/Criss/html/ host=::0 port=10001 Key=username:password number_cluster_Workers=0 is_monitor=false delay=20 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt temp_cache_IO_data_dir=C:/Criss/temp/

谷歌安卓系統 之 Termux 系統 之 烏班圖系統 ( Android-11 Termux-0.118 Ubuntu-22.04-LTS-rootfs Arm64-aarch64 ) 控制臺命令列 ( bash ) 運行啓動指令:

root@localhost:~# /usr/bin/node /home/Criss/js/application.js configFile=/home/Criss/config.txt webPath=/home/Criss/html/ host=::0 port=10001 Key=username:password number_cluster_Workers=0 is_monitor=false delay=20 monitor_dir=/home/Criss/Intermediary/ monitor_file=C:/home/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt temp_cache_IO_data_dir=/home/Criss/temp/

控制臺啓動傳參釋意, 各參數之間以一個空格字符分隔, 鍵(Key) ~ 值(Value) 之間以一個等號字符連接, 即類似 Key=Value 的形式:

1. (必), (自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  C:/Criss/NodeJS/nodejs-20.15.0/node.exe

2. (必), (自定義), 語言 ( JavaScript ) 程式代碼脚本 ( Script ) 檔 ( application.js ) 的存儲路徑全名:  C:/Criss/js/application.js

   注意, 因爲「application.js」檔中脚本代碼需要加載引入「Interface.js」檔, 所以需要保持「application.js」檔與「Interface.js」檔在相同目錄下, 不然就需要手動修改「application.js」檔中有關引用「Interface.js」檔的加載路徑代碼, 以確保能正確引入「Interface.js」檔.

3. (暫未完成) (選) (鍵 configFile 固定, 值 C:/Criss/config.txt 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  configFile=C:/Criss/config.txt

4. (選) (鍵 webPath 固定, 值 C:/Criss/html/ 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  webPath=C:/Criss/html/

5. (選) (鍵 host 固定, 值 ::0 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  host=::0

6. (選) (鍵 port 固定, 值 10001 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  port=10001

7. (選) (鍵 Key 固定, 賬號密碼連接符 : 固定, 值 username 和 password 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  Key=username:password

8. (選) (鍵 number_cluster_Workers 固定, 值 0 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  number_cluster_Workers=0

9. (選) (鍵 is_monitor 固定, 值 false 自定義, [ true, false ] 二選一), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  is_monitor=false

10. (選) (鍵 delay 固定, 值 20 自定義, 單位爲毫秒), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  delay=20

11. (選) (鍵 monitor_dir 固定, 值 C:/Criss/Intermediary/ 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  monitor_dir=C:/Criss/Intermediary/

12. (選) (鍵 monitor_file 固定, 值 C:/Criss/Intermediary/intermediary_write_C.txt 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt

13. (選) (鍵 output_dir 固定, 值 C:/Criss/Intermediary/ 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  output_dir=C:/Criss/Intermediary/

14. (選) (鍵 output_file 固定, 值 C:/Criss/Intermediary/intermediary_write_Nodejs.txt 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  output_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt

15. (選) (鍵 temp_cache_IO_data_dir 固定, 值 C:/Criss/temp/ 自定義), 安裝配置的程式設計語言 ( Node.js ) 解釋器 ( Interpreter ) 環境的二進制可執行檔啓動存儲路徑全名:  temp_cache_IO_data_dir=C:/Criss/temp/

![]()

---

Compiler:

Minimalist GNU on Windows: mingw64 - 8.1.0 - release - posix - seh - rt_v6 - rev0

Interpreter:

node - v20.15.0

python - 3.12.4

julia - 1.10.4

julia - 1.10.4 - packages:

Artifacts

Base64

BitFlags - 0.1.8

CodecZlib - 0.7.4

ConcurrentUtilities - 2.4.1

Dates

ExceptionUnwrapping - 0.1.10

HTTP - 1.10.8

InteractiveUtils

JLLWrappers - 1.5.0

JSON - 0.21.4

Libdl

Logging

LoggingExtras - 1.0.3

Markdown

MbedTLS - 1.1.9

MbedTLS_jll - 2.28.2+0

Mmap

MozillaCACerts_jll - 2022.10.11

NetworkOptions - 1.2.0

OpenSSL - 1.4.3

OpenSSL_jll - 3.0.13+1

Parsers - 2.8.1

PrecompileTools - 1.2.1

Preferences - 1.4.3

Printf

Random

SHA - 0.7.0

Serialization

SimpleBufferStream - 1.1.0

Sockets

TOML - 1.0.3

Test

TranscodingStreams - 0.10.9

TranscodingStreams.extensions

URIs - 1.5.1

UUIDs

Unicode

Zlib_jll - 1.2.13+0

![]()

---

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 官方網站](https://www.mingw-w64.org/): 
https://www.mingw-w64.org/

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 官方下載頁](https://www.mingw-w64.org/downloads/): 
https://www.mingw-w64.org/downloads/

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 作者官方 GitHub 網站賬戶](https://github.com/niXman): 
https://github.com/niXman

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 官方 GitHub 網站倉庫](https://github.com/nixman/mingw-builds): 
https://github.com/nixman/mingw-builds.git

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 官方 GitHub 網站倉庫預編譯二進制檔下載頁](https://github.com/niXman/mingw-builds-binaries/releases): 
https://github.com/niXman/mingw-builds-binaries/releases

[程式設計 C 語言 gcc, g++ 編譯器 ( Compiler ) 之 MinGW-w64 預編譯二進制檔下載頁](https://sourceforge.net/projects/mingw-w64/): 
https://sourceforge.net/projects/mingw-w64/

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方網站](https://node.js.org/): 
https://node.js.org/

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方網站](https://nodejs.org/en/): 
https://nodejs.org/en/

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方下載頁](https://nodejs.org/en/download/package-manager): 
https://nodejs.org/en/download/package-manager

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方 GitHub 網站賬戶](https://github.com/nodejs): 
https://github.com/nodejs

[程式設計 JavaScript 語言解釋器 ( Interpreter ) 之 Node.js 官方 GitHub 網站倉庫](https://github.com/nodejs/node): 
https://github.com/nodejs/node.git

[程式設計 Python 語言解釋器 ( Interpreter ) 官方網站](https://www.python.org/): 
https://www.python.org/

[程式設計 Python 語言解釋器 ( Interpreter ) 官方下載頁](https://www.python.org/downloads/): 
https://www.python.org/downloads/

[程式設計 Python 語言解釋器 ( Interpreter ) 官方 GitHub 網站賬戶](https://github.com/python): 
https://github.com/python

[程式設計 Python 語言解釋器 ( Interpreter ) 官方 GitHub 網站倉庫](https://github.com/python/cpython): 
https://github.com/python/cpython.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方網站](https://julialang.org/): 
https://julialang.org/

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方下載頁](https://julialang.org/downloads/): 
https://julialang.org/downloads/

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方 GitHub 網站賬戶](https://github.com/JuliaLang): 
https://github.com/JuliaLang

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方 GitHub 網站倉庫](https://github.com/JuliaLang/julia): 
https://github.com/JuliaLang/julia.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 官方 General.jl 模組 GitHub 網站倉庫](https://github.com/JuliaRegistries/General): 
https://github.com/JuliaRegistries/General.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 第三方 JSON.jl 模組 GitHub 網站倉庫](https://github.com/JuliaIO/JSON.jl.git): 
https://github.com/JuliaIO/JSON.jl.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 第三方 HTTP.jl 模組 GitHub 網站倉庫](https://github.com/JuliaWeb/HTTP.jl.git): 
https://github.com/JuliaWeb/HTTP.jl.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 第三方 JSON3.jl 模組 GitHub 網站倉庫](https://github.com/quinnj/JSON3.jl.git): 
https://github.com/quinnj/JSON3.jl.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 第三方 Plots.jl 模組 GitHub 網站倉庫](https://github.com/JuliaPlots/Plots.jl.git): 
https://github.com/JuliaPlots/Plots.jl.git

[程式設計 Julia 語言解釋器 ( Interpreter ) 第三方 LsqFit.jl 模組 GitHub 網站倉庫](https://github.com/JuliaNLSolvers/LsqFit.jl.git): 
https://github.com/JuliaNLSolvers/LsqFit.jl.git

![]()

---

編譯器 ( Compiler ) , 解釋器 ( Interpreter ) 依賴工具 ( packages ) [百度網盤 pan.baidu.com](https://pan.baidu.com/s/1Dtp1PEcFBAnjrzareMtjNg?pwd=me5k) 下載頁: 
https://pan.baidu.com/s/1Dtp1PEcFBAnjrzareMtjNg?pwd=me5k

提取碼：me5k
