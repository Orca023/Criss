# Base.MainInclude.include(popfirst!(ARGS));
# println(Base.PROGRAM_FILE);


#################################################################################;

# Title: Julia server v20161211
# Explain: Julia file server, Julia http server, Julia http client
# Author: 趙健
# E-mail: 283640621@qq.com
# Telephont number: +86 18604537694
# E-mail: chinaorcaz@gmail.com
# Date: 歲在丙申
# Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30
# Interpreter: julia-1.9.3-win64.exe
# Interpreter: julia-1.10.3-linux-x86_64.tar.gz
# Operating system: google-pixel-2 android-11 termux-0.118 ubuntu-22.04-LTS-rootfs arm64-aarch64 MSM8998-Snapdragon835-Qualcomm®-Kryo™-280
# Interpreter: julia-1.10.3-linux-aarch64.tar.gz

# 使用説明：
# 控制臺命令列運行指令：
# C:\> C:/Criss/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/Criss/jl/ C:/Criss/jl/Interface.jl configFile=C:/Criss/config.txt interface_Function=file_Monitor webPath=C:/Criss/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=C:/Criss/temp/
# root@localhost:~# /usr/julia/julia-1.10.3/bin/julia -p 4 --project=/home/Criss/jl/ /home/Criss/jl/Interface.jl configFile=/home/Criss/config.txt interface_Function=file_Monitor webPath=/home/Criss/html/ host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/home/Criss/temp/

#################################################################################;


# module Interface
# Main.Interface
Base.push!(LOAD_PATH, ".")  # 增加當前目錄為導入擴展包時候的搜索路徑之一，用於導入當前目錄下自定義的模組（Julia代碼文檔 .jl）;

# Base.MainInclude.include(Base.filter(Base.contains(r".*\.jl$"), Base.Filesystem.readdir()));  # 在 Jupyterlab 中實現加載 Base.MainInclude.include("*.jl") 文檔，其中 r".*\.jl$" 為解析脚本文檔名的正則表達式;

using Dates;  # 導入 Julia 的原生標準模組「Dates」，用於處理時間和日期數據，也可以用全名 Main.Dates. 訪問模組内的方法（函數）;
using Distributed;  # 導入 Julia 的原生標準模組「Distributed」，用於提供并行化和分佈式功能;
using Sockets;  # 導入 Julia 的原生標準模組「Sockets」，用於創建 TCP server 服務器;
using Base64;  # 導入 Julia 的原生標準模組「Base64」，用於按照 Base64 方式編解碼字符串;
# using SharedArrays;

Distributed.@everywhere using Dates, Distributed, Sockets, Base64;  # SharedArrays;  # 使用廣播關鍵字 Distributed.@everywhere 在所有子進程中加載指定模組或函數或變量;

# https://discourse.juliacn.com/t/topic/2969
# 如果想臨時更換pkg工具下載鏡像源，在julia解釋器環境命令行輸入命令：
# julia> ENV["JULIA_PKG_SERVER"]="https://mirrors.bfsu.edu.cn/julia/static"
# 或者：
# Windows Powershell: $env:JULIA_PKG_SERVER = 'https://pkg.julialang.org'
# Linux/macOS Bash: export JULIA_PKG_SERVER="https://pkg.julialang.org"
using HTTP;  # 導入第三方擴展包「HTTP」，用於創建 HTTP server 服務器，需要在控制臺先安裝第三方擴展包「HTTP」：julia> using Pkg; Pkg.add("HTTP") 成功之後才能使用;
# https://github.com/JuliaWeb/HTTP.jl
# https://juliaweb.github.io/HTTP.jl/stable/
# https://juliaweb.github.io/HTTP.jl/stable/server/
# https://juliaweb.github.io/HTTP.jl/stable/client/
# https://juliaweb.github.io/HTTP.jl/stable/reference/
# https://juliaweb.github.io/HTTP.jl/stable/examples/

using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# https://github.com/JuliaIO/JSON.jl
# JSON.parse - string or stream to Julia data structures
# s = "{\"a_number\" : 5.0, \"an_array\" : [\"string\", 9]}"
# j = JSON.parse(s)
# Dict{AbstractString,Any} with 2 entries:
#     "an_array" => {"string",9}
#     "a_number" => 5.0
# JSON.json - Julia data structures to a string
# JSON.json([2,3])
# "[2,3]"
# JSON.json(j)
# "{\"an_array\":[\"string\",9],\"a_number\":5.0}"

# using JSON3;  # 導入第三方擴展包「JSON3」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON3」：julia> using Pkg; Pkg.add("JSON3") 成功之後才能使用;
# # https://github.com/quinnj/JSON3.jl
# # read from file
# # json_string = Base.read("./my.json", String)
# # JSON3.read(json_string)
# # JSON3.read(json_string, T; kw...)
# # x = T()
# # JSON3.read!(json_string, x; kw...)
# # JSON3.write(x)
# # write to file
# # Base.open("./my.json", "w") do f
# #     JSON3.write(f, x)
# #     println(f)
# # end
# # write a pretty file
# # open("my.json", "w") do f
# #     JSON3.pretty(f, JSON3.write(x))
# #     println(f)
# # end

# using StructTypes  # 導入第三方擴展包「StructTypes」，需要在控制臺先安裝第三方擴展包「StructTypes」：julia> using Pkg; Pkg.add("StructTypes") 成功之後才能使用;

# # 導入第三方擴展包;
# using Regex;  # 正則表達式包;

# # 自定義函數，用於判斷一個字符串是否符合 IPv6 格式規則，或是符合 IPv4 格式規則;
# function CheckIP(address::Core.String)::Core.Union{Core.String, Core.Bool}
#     # using Regex;
#     IPv6_pattern = r"^(::)?([a-fA-F\d]{1,4}:){7}[a-fA-F\d]{1,4}(:[a-fA-F\d]{1,4}){0,3}$|^(?:(?!.*::.*::)(?:(?!.*::$)|(?!.*:$))(?:\w+:{1,3}\w*)+)$";
#     IPv4_pattern = r"^((25[0-5]|2[0-4][0-9]|1[0-9]{3}|[1-9][0-9]{0,1})(\.(25[0-5]|2[0-4][0-9]|1[0-9]{3}|[1-9][0-9]{0,1})){3})$";

#     if match(IPv6_pattern, address) !== Core.nothing
#         return "IPv6";
#     elseif match(IPv4_pattern, address) !== Core.nothing
#         return "IPv4";
#     else
#         return false;
#     end
# end
# # export CheckIP;


# 使用 Base.MainInclude.include() 函數可導入本地 Julia 脚本文檔到當前位置執行;
Base.MainInclude.include("./Interface.jl");
# Base.MainInclude.include(Base.Filesystem.joinpath(Base.@__DIR__, "Interface.jl"));
# Base.Filesystem.joinpath(Base.@__DIR__, "Interface.jl")
# Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "lib", "Interface.jl")
# Base.Filesystem.joinpath(Base.Filesystem.pwd(), "lib", "Interface.jl")



# 自定義封裝的函數 JSONstring(Dict_Array) 將 Julia 字典（Dict）或一維數組（Array）對象轉換爲一個 JSON 格式的字符串;
# 注意，最多只能有 5 級字典（Dict）或一維數組（Array）對象嵌套，例如可以接受：{{{{}}}} 或者 [[[[]]]] 或者 {[{[]}]}  或者 [{[{}]}] 格式都可以轉換;
function JSONstring(Dict_Array::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}})::Core.String
    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;

    # 拼接字符串;
    JSON_string::Core.String = "";  # 函數返回值;
    JSON_string = JSON.json(Dict_Array);

    # # 如果字符串長度太大，可以使用反斜杠 \ 來拆分跨行表示，例如 " a \ b" 這樣 a、b 可寫在兩行裏邊;
    # # 使用星號（*）拼接字符串;
    # # response_body_String = "{" * "\"" * "Target" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Url"]) * "\"" * "," * "\"" * "request_Path" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Path"]) * "\"" * "," * "\"" * "request_Url_Query_String" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Url_Query_String"]) * "\"" * "," * "\"" * "request_POST" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_POST"]) * "\"" * "," * "\"" * "request_Authorization" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Authorization"]) * "\"" * "," * "\"" * "request_Cookie" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Cookie"]) * "\"" * "," * "\"" * "request_Nikename" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Nikename"]) * "\"" * "," * "\"" * "request_Password" * "\"" * ":" * "\"" * Base.string(response_body_Dict["request_Password"]) * "\"" * "," * "\"" * "Server_Authorization" * "\"" * ":" * "\"" * Base.string(response_body_Dict["Server_Authorization"]) * "\"" * "," * "\"" * "Server_say" * "\"" * ":" * "\"" * Base.string(response_body_Dict["Server_say"]) * "\"" * "," * "\"" * "error" * "\"" * ":" * "\"" * Base.string(response_body_Dict["error"]) * "\"" * "," * "\"" * "time" * "\"" * ":" * "\"" * Base.string(response_body_Dict["time"]) * "\"" * "}";  # 使用星號*拼接字符串;
    # # 使用 Base.string() 函數拼接字符串;
    # response_body_String = Base.string(
    #     "{",
    #     "\"",
    #     "Target",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["request_Url"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "request_Path",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["request_Path"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "request_Url_Query_String",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["request_Url_Query_String"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "request_POST",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["request_POST"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "request_Authorization",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["request_Authorization"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "request_Cookie",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["request_Cookie"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "request_Nikename",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["request_Nikename"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "request_Password",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["request_Password"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "Server_Authorization",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["Server_Authorization"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "Server_say",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["Server_say"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "error",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["error"]),
    #     "\"",
    #     ",",
    #     "\"",
    #     "time",
    #     "\"",
    #     ":",
    #     "\"",
    #     Base.string(response_body_Dict["time"]),
    #     "\"",
    #     "}"
    # );
    # # println(response_body_String);

    return JSON_string;
end

# 自定義封裝的函數 JSONparse(JSON_string) 將 JSON 格式的字符串轉換爲一個 Julia 字典（Dict）或一維數組（Array）對象;
# 注意，字符串中不能有 JSON 對象 {} 的嵌套，例如，不可以傳入 {{}} 格式的字符串，可以有 2 級一維數組對象 [] 的嵌套，例如，可以傳入 [[]] 格式的字符串，還可以傳入 {[[]]} 或者 [[[]]]  或者 [{[[]]}] 格式都可以轉換;
function JSONparse(JSON_string::Core.String)::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}}
    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;

    JSON_dict = Core.nothing;
    JSON_dict = JSON.parse(JSON_string);

    return JSON_dict;
end



# # 函數 monitor_file_do_Function() ;
# is_monitor = true;  # true, Boolean，用於判別是執行一次，還是啓動監聽服務，持續監聽目標文檔，false 值表示只執行一次，true 值表示啓動監聽服務器看守進程持續監聽;
# monitor_dir = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸入傳值的媒介目錄 "../Intermediary/";
# monitor_file = Base.Filesystem.joinpath(monitor_dir, "intermediary_write_C");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(monitor_dir, "intermediary_write_NodeJS.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於接收傳值的媒介文檔 "../Intermediary/intermediary_write_NodeJS.txt";
# output_dir = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸出傳值的媒介目錄 "../Intermediary/";
# output_file = Base.Filesystem.joinpath(output_dir, "intermediary_write_Julia.txt");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(output_dir, "intermediary_write_Julia.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於輸出傳值的媒介文檔 "../Intermediary/intermediary_write_Julia.txt";
# temp_cache_IO_data_dir = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "temp");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_cache_IO_data_dir\";
# do_Function = Core.nothing;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行數據處理功能的函數 "do_data";
# to_executable = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "NodeJS", "node.exe");  # 上一層路徑下的Node.JS解釋器可執行檔路徑C:\nodejs\node.exe：Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "NodeJS", "node,exe")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的解釋器可執行文件 "..\\NodeJS\\node.exe"，Julia 解釋器可執行檔全名 println(Base.Sys.BINDIR)：C:\Julia 1.5.1\bin，;
# to_script = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "js", "application.js");  # 上一層路徑下的 JavaScript 脚本路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "js", "Ruuter.js")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的被調用的脚本文檔 "../js/Ruuter.js";
# time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
# number_Worker_threads = Core.UInt8(0);  # Core.UInt8(1)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# isMonitorThreadsOrProcesses = 0;  # 0 || "0" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# isDoTasksOrThreads = "Tasks";  # "Tasks" || "Multi-Threading"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;

# # TCP Server 「Sockets.Sockets.listen」;
# webPath = Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath(".")), "html"));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# # webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# host::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv6(0);  # "::1";  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# port = "10001";  # ::Core.Union{Core.String, Core.UInt8} = "10001";  # Core.UInt8(5000),  # 0 ~ 65535， 監聽埠號（端口）;
# key = "username:password";  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
# session = Core.nothing;  # Base.Dict{Core.String, Core.Any}();  # Base.Dict{Core.String, Core.String}("request_Key->username:password" => key); 自定義 session 值，Base.Dict 對象;
# number_Worker_threads = Core.UInt8(0);  # Core.UInt8(1)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
# readtimeout::Core.Int = Core.Int(0);  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
# verbose::Core.Bool = Core.Bool(false);  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
# do_Function = Core.nothing;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 do_Request, "do_POST_root_directory";
# isConcurrencyHierarchy = "Tasks";  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;

# # TCP Client 「Sockets.Sockets.connect」;
# host::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv6(0);  # "::1";  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# IPVersion = "IPv6";  # "IPv6"、"IPv4";
# port = "10001";  # ::Core.Union{Core.String, Core.UInt8} = "10001";  # Core.UInt8(5000),  # 0 ~ 65535， 監聽埠號（端口）;
# Authorization = "";  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
# postData = Core.nothing;  # Base.Dict{Core.String, Core.Any}();  # Base.Dict{Core.String, Core.String}("request_Key->username:password" => key); 自定義 session 值，Base.Dict 對象;
# URL = "";
# requestPath = "";
# requestMethod = "";  # "POST",  # "GET"; # 請求方法;
# requestProtocol = "";
# # time_out = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# Cookie = "";  # "Session_ID=request_Key->username:password"，將漢字做Base64轉碼Base64.base64encode()，需要事先加載原生的 Base64 模組：using Base64 模組;
# # println(Core.String(Base64.base64decode(Cookie_value)));
# # println("Request Cook: ", Cookie);
# time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
# requestFrom = "";  # "user@email.com";
# number_Worker_threads = Core.UInt8(0);  # Core.UInt8(1)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# # readtimeout::Core.Int = Core.Int(0);  # 服務器響應數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
# connect_timeout::Core.Int = Core.Int(0);  # 服務器鏈接超時，單位：（秒），close the connection after this many seconds if it is still attempting to connect. Use to disable.connect_timeout = 0;
# do_Function = Core.nothing;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_Response";
# isConcurrencyHierarchy = "Tasks";  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# proxy = Core.nothing;  # ::Core.String = Core.nothing,  # 當需要通過代理服務器僞裝發送請求時，代理服務器的網址 URL 值字符串，pass request through a proxy given as a url; alternatively, the , , , , and environment variables are also detected/used; if set, they will be used automatically when making requests.http_proxyHTTP_PROXYhttps_proxyHTTPS_PROXYno_proxy;
# Referrer = "";  # ::Core.String = http_Client.URL,  # 請求的來源網頁 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
# query = Base.Dict{Core.String, Core.String}();  # ::Base.Dict{Core.String, Core.String} = Core.nothing,  # Base.Dict{Core.String, Core.String}(),  # Base.Dict{Core.String, Core.String}("ID" => "23", "IP" => "24"),  # 請求查詢 key => value 字典，a or of key => values to be included in the urlPairDict;

# # 控制臺傳參，通過 Base.ARGS 數組獲取從控制臺傳入的參數;
# # println(Base.typeof(Base.ARGS));
# # println(Base.ARGS);
# # println(Base.PROGRAM_FILE);  # 通過命令行啓動的，當前正在執行的 Julia 脚本文檔路徑;
# # 使用 Base.typeof("abcd") == String 方法判斷對象是否是一個字符串;
# # for X in Base.ARGS
# #     println(X)
# # end
# # for X ∈ Base.ARGS
# #     println(X)
# # end
# if Base.length(Base.ARGS) > 0
#     for i = 1:Base.length(Base.ARGS)
#         # println("Base.ARGS" * Base.string(i) * ": " * Base.string(Base.ARGS[i]));  # 通過 Base.ARGS 數組獲取從控制臺傳入的參數;
#         # 使用 Core.isa(Base.ARGS[i], Core.String) 函數判断「元素(变量实例)」是否属于「集合(变量类型集)」之间的关系，使用 Base.typeof(Base.ARGS[i]) <: Core.String 方法判断「集合」是否包含于「集合」之间的关系，或 Base.typeof(Base.ARGS[i]) === Core.String 方法判斷傳入的參數是否為 String 字符串類型;
#         if Core.isa(Base.ARGS[i], Core.String) && Base.ARGS[i] !== "" && Base.occursin("=", Base.ARGS[i])

#             ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}();  # 聲明一個聯合類型的空1維數組;
#             # ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
#             # 函數 Base.split(Base.ARGS[i], '=') 表示用等號字符'='分割字符串為數組;
#             for x in Base.split(Base.ARGS[i], '=')
#                 x = Base.convert(Core.String, x);  # 使用 convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
#                 Base.push!(ARGSIArray, x);  # 使用 push! 函數在數組末尾追加推入新元素，Base.strip(str) 去除字符串首尾兩端的空格;
#             end

#             if Base.length(ARGSIArray) > 1

#                 ARGSValue = "";
#                 # ARGSValue = join(Base.deleteat!(Base.deepcopy(ARGSIArray), 1), "=");  # 使用 Base.deepcopy() 標注數組深拷貝傳值複製，這樣在使用 Base.deleteat!(ARGSIArray, 1) 函數刪除第一個元素時候就不會改變原數組 ARGSIArray，否則為淺拷貝傳址複製，使用 deleteat!(ARGSIArray, 1) 刪除第一個元素的時候會影響原數組 ARGSIArray 的值，然後將數組從第二個元素起直至末尾拼接為一個字符串;
#                 for j = 2:Base.length(ARGSIArray)
#                     if j === 2
#                         ARGSValue = ARGSValue * ARGSIArray[j];  # 使用星號*拼接字符串;
#                     else
#                         ARGSValue = ARGSValue * "=" * ARGSIArray[j];
#                     end
#                 end

#                 # try
#                 #     g = Base.Meta.parse(Base.string(ARGSIArray[1]) * "=" * Base.string(ARGSValue));  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
#                 #     Base.MainInclude.eval(g);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
#                 #     println(Base.string(ARGSIArray[1]) * " = " * "\$" * Base.string(ARGSIArray[1]));
#                 # catch err
#                 #     println(err);
#                 # end

#                 if ARGSValue !== ""

#                     if ARGSIArray[1] === "is_monitor"
#                         # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
#                         global is_monitor = Base.parse(Bool, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 "true / false";
#                         # print("is monitor: ", is_monitor, "\n");
#                     end

#                     if ARGSIArray[1] === "monitor_file"
#                         global monitor_file = ARGSValue;  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
#                         # print("monitor file: ", monitor_file, "\n");
#                     end

#                     if ARGSIArray[1] === "monitor_dir"
#                         global monitor_dir = ARGSValue;  # 用於輸入傳值的媒介目錄 "../temp/"，當前路徑 Base.@__DIR__;
#                         # print("monitor dir: ", monitor_dir, "\n");
#                     end

#                     if ARGSIArray[1] === "output_dir"
#                         global output_dir = ARGSValue;  # 用於輸出傳值的媒介目錄 "../temp/"，當前路徑 Base.@__DIR__;
#                         # print("output dir: ", output_dir, "\n");
#                     end

#                     if ARGSIArray[1] === "output_file"
#                         global output_file = ARGSValue;  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Julia.txt";
#                         # print("output file: ", output_file, "\n");
#                     end

#                     if ARGSIArray[1] === "temp_cache_IO_data_dir"
#                         global temp_cache_IO_data_dir = ARGSValue;  # 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\"，當前路徑 Base.@__DIR__;
#                         # print("Temporary cache IO data directory: ", temp_cache_IO_data_dir, "\n");
#                     end

#                     if ARGSIArray[1] === "to_executable"
#                         global to_executable = ARGSValue;  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
#                         # print("to executable: ", to_executable, "\n");
#                     end

#                     if ARGSIArray[1] === "to_script"
#                         global to_script = ARGSValue;  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
#                         # print("to script: ", to_script, "\n");
#                     end

#                     if ARGSIArray[1] === "time_sleep"
#                         # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
#                         # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
#                         global time_sleep = Base.parse(Core.Float64, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的長整型(Core.UInt64)類型的變量，監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
#                         # print("time sleep: ", time_sleep, "\n");
#                     end

#                     if ARGSIArray[1] === "number_Worker_threads"
#                         # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
#                         # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
#                         global number_Worker_threads = Base.parse(UInt8, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(UInt8)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
#                         # print("number Worker threads: ", number_Worker_threads, "\n");
#                     end

#                     if ARGSIArray[1] === "isMonitorThreadsOrProcesses"
#                         global isMonitorThreadsOrProcesses = ARGSValue;  # 0 || "0" || "Multi-Threading" || "Multi-Processes"; # 選擇監聽動作的函數的并發層級（多協程、多綫程、多進程）;
#                         # print("isMonitorThreadsOrProcesses: ", isMonitorThreadsOrProcesses, "\n");
#                         # 當 isMonitorThreadsOrProcesses = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
#                         # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
#                         # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
#                         # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
#                         # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
#                     end

#                     if ARGSIArray[1] === "isDoTasksOrThreads"
#                         global isDoTasksOrThreads = ARGSValue;  # "Tasks" || "Multi-Threading"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
#                         # print("isDoTasksOrThreads: ", isDoTasksOrThreads, "\n");
#                         # 當 isDoTasksOrThreads = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
#                         # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
#                         # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
#                     end

#                     if ARGSIArray[1] === "do_Function"

#                         if ARGSValue === "do_data"

#                             # 使用函數 Base.@isdefined(do_data) 判斷 do_data 變量是否已經被聲明過;
#                             if Base.@isdefined(do_data)
#                                 # 使用 Core.isa(do_data, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_data) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_data) <: Function 方法判別 do_data 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
#                                 # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
#                                 # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
#                                 if Base.typeof(do_data) <: Function
#                                     global do_Function = do_data;
#                                 else
#                                     println("傳入的參數，指定的變量「" * ARGSValue * "」不是一個函數類型的變量.");
#                                     # global do_Function = Core.nothing;  # 置空;
#                                     global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                                 end
#                             else
#                                 println("傳入的參數，指定的變量「" * ARGSValue * "」未定義.");
#                                 # global do_Function = Core.nothing;  # 置空;
#                                 global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             end

#                             # try
#                             #     if length(methods(do_data)) > 0
#                             #         global do_Function = do_data;
#                             #     else
#                             #         # global do_Function = Core.nothing;  # 置空;
#                             #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             #     end
#                             # catch err
#                             #     # println(err);
#                             #     # println(Base.typeof(err));
#                             #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
#                             #     if Core.isa(err, Core.UndefVarError)
#                             #         println(err.var, " not defined.");
#                             #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
#                             #         # global do_Function = Core.nothing;  # 置空;
#                             #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             #     else
#                             #         println(err);
#                             #     end
#                             # finally
#                             #     # global do_Function = Core.nothing;  # 置空;
#                             #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             # end
#                         end

#                         if ARGSValue === "do_Request"

#                             # 使用函數 Base.@isdefined(do_Request) 判斷 do_Request 變量是否已經被聲明過;
#                             if Base.@isdefined(do_Request)
#                                 # 使用 Core.isa(do_Request, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_Request) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_Request) <: Function 方法判別 do_Request 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
#                                 # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
#                                 # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
#                                 if Base.typeof(do_Request) <: Function
#                                     global do_Function = do_Request;
#                                 else
#                                     println("傳入的參數，指定的變量「" * ARGSValue * "」不是一個函數類型的變量.");
#                                     # global do_Function = Core.nothing;  # 置空;
#                                     global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                                 end
#                             else
#                                 println("傳入的參數，指定的變量「" * ARGSValue * "」未定義.");
#                                 # global do_Function = Core.nothing;  # 置空;
#                                 global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             end

#                             # try
#                             #     if length(methods(do_Request)) > 0
#                             #         global do_Function = do_Request;
#                             #     else
#                             #         # global do_Function = Core.nothing;  # 置空;
#                             #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             #     end
#                             # catch err
#                             #     # println(err);
#                             #     # println(Base.typeof(err));
#                             #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
#                             #     if Core.isa(err, Core.UndefVarError)
#                             #         println(err.var, " not defined.");
#                             #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
#                             #         # global do_Function = Core.nothing;  # 置空;
#                             #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             #     else
#                             #         println(err);
#                             #     end
#                             # finally
#                             #     # global do_Function = Core.nothing;  # 置空;
#                             #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             # end
#                         end

#                         if ARGSValue === "do_Response"

#                             # 使用函數 Base.@isdefined(do_Response) 判斷 do_Response 變量是否已經被聲明過;
#                             if Base.@isdefined(do_Response)
#                                 # 使用 Core.isa(do_Response, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_Response) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_Response) <: Function 方法判別 do_Response 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
#                                 # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
#                                 # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
#                                 if Base.typeof(do_Response) <: Function
#                                     global do_Function = do_Response;
#                                 else
#                                     println("傳入的參數，指定的變量「" * ARGSValue * "」不是一個函數類型的變量.");
#                                     # global do_Function = Core.nothing;  # 置空;
#                                     global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                                 end
#                             else
#                                 println("傳入的參數，指定的變量「" * ARGSValue * "」未定義.");
#                                 # global do_Function = Core.nothing;  # 置空;
#                                 global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             end

#                             # try
#                             #     if length(methods(do_Response)) > 0
#                             #         global do_Function = do_Response;
#                             #     else
#                             #         # global do_Function = Core.nothing;  # 置空;
#                             #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             #     end
#                             # catch err
#                             #     # println(err);
#                             #     # println(Base.typeof(err));
#                             #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
#                             #     if Core.isa(err, Core.UndefVarError)
#                             #         println(err.var, " not defined.");
#                             #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
#                             #         # global do_Function = Core.nothing;  # 置空;
#                             #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             #     else
#                             #         println(err);
#                             #     end
#                             # finally
#                             #     # global do_Function = Core.nothing;  # 置空;
#                             #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
#                             # end
#                         end

#                         # if ARGSValue !== "do_data" && ARGSValue !== "do_data"
#                         #     # global do_Function = Core.nothing;  # 置空;
#                         #     global do_Function = (argument) -> argument;  # 匿名函數，直接返回傳入參數做返回值;
#                         # end

#                         # print("do Function: ", do_Function, "\n");
#                     end

#                     if ARGSIArray[1] === "host"
#                         global host = ARGSValue;  # 用於輸出傳值的媒介目錄 "../temp/";
#                         if Base.string(host) === "::0" || Base.string(host) === "::1" || Base.string(host) === "::" || Base.string(host) === "0" || Base.string(host) === "1"
#                             # || CheckIP(Base.string(host)) === "IPv6"
#                             global host = Sockets.IPv6(host);  # Sockets.IPv6(0);  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv6(0);  # "::0" or "::1" or "localhost"; 監聽主機域名 Host domain name;
#                         elseif Base.string(host) === "0.0.0.0" || Base.string(host) === "127.0.0.1"
#                             # || CheckIP(Base.string(host)) === "IPv4"
#                             global host = Sockets.IPv4(host);  # Sockets.IPv4("0.0.0.0");  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv4("0.0.0.0");  # "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
#                         elseif Base.string(host) === "localhost"
#                             global host = Sockets.IPv6(0);  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv4("0.0.0.0");  # "::1";  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
#                         else
#                             println("Error: host IP [ " * Base.string(host) * " ] unrecognized.");
#                             # return false
#                         end
#                         # print("host: ", Base.string(host), "\n");
#                     end

#                     if ARGSIArray[1] === "IPVersion"
#                         global IPVersion = ARGSValue;  # "IPv6"、"IPv4";
#                         # print("IP Version: ", IPVersion, "\n");
#                     end

#                     if ARGSIArray[1] === "port"
#                         global port = ARGSValue;  # Core.UInt8(5000),  # 0 ~ 65535， 監聽埠號（端口）;
#                         global port = Base.parse(Core.UInt64, port);
#                         # print("port: ", Base.string(port), "\n");
#                     end

#                     if ARGSIArray[1] === "key"
#                         if Base.string(ARGSValue) === "nothing" || Base.string(ARGSValue) === ""
#                             global key = "";
#                             # global key = Core.nothing;
#                         else
#                             global key = Base.string(ARGSValue);  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
#                         end
#                         # print("key: ", key, "\n");
#                     end

#                     if ARGSIArray[1] === "session"
#                         # global session = ARGSValue;  # 用於輸入傳值的媒介目錄 "../temp/";
#                         # g = Base.Meta.parse(Base.string(ARGSIArray[1]) * Base.string(ARGSValue));
#                         g = Base.Meta.parse("session=" * Base.string(ARGSValue));
#                         Base.MainInclude.eval(g);
#                         # print("session: ", session, "\n");
#                     end

#                     if ARGSIArray[1] === "isConcurrencyHierarchy"
#                         global isConcurrencyHierarchy = ARGSValue;  # "Tasks" || "Multi-Threading" || "Multi-Processes"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
#                         # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
#                         # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
#                         # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
#                         # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
#                         # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
#                         # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
#                     end

#                     if ARGSIArray[1] === "Authorization"
#                         global Authorization = ARGSValue;  # 客戶端發送的請求頭中的 Authorizater 參數值;
#                         # print("Authorization: ", Authorization, "\n");
#                     end

#                     if ARGSIArray[1] === "Cookie"
#                         global Cookie = ARGSValue;  # 客戶端發送的請求頭中的 Cookie 參數值;
#                         # print("Cookie: ", Cookie, "\n");
#                     end

#                     if ARGSIArray[1] === "URL"
#                         global URL = ARGSValue;
#                         # print("URL: ", URL, "\n");
#                     end

#                     if ARGSIArray[1] === "proxy"
#                         global proxy = ARGSValue;
#                         # print("Proxy: ", proxy, "\n");
#                     end

#                     if ARGSIArray[1] === "Referrer"
#                         global Referrer = ARGSValue;
#                         # print("Referrer: ", Referrer, "\n");
#                     end

#                     if ARGSIArray[1] === "query"
#                         # https://github.com/JuliaIO/JSON.jl
#                         # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
#                         # s = "{\"a_number\" : 5.0, \"an_array\" : [\"string\", 9]}"
#                         # j = JSONparse(s)  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
#                         # # j = JSON.parse(s)  # 第三方 JSON 庫中的 JSON.parse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
#                         # Dict{AbstractString,Any} with 2 entries:
#                         #     "an_array" => {"string",9}
#                         #     "a_number" => 5.0
#                         global query = JSONparse(ARGSValue);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
#                         # global query = JSON.parse(ARGSValue);  # 第三方 JSON 庫中的 JSON.parse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
#                         # print("query: ", ARGSValue, "\n");
#                         # print("query: ", "\n");
#                         # print(query);
#                     end

#                     if ARGSIArray[1] === "readtimeout"
#                         # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
#                         # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
#                         global readtimeout = Base.parse(Core.Int, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(Int)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
#                         # print("Read Timeout: ", readtimeout, "\n");
#                     end

#                     if ARGSIArray[1] === "connecttimeout"
#                         # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
#                         # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
#                         global connect_timeout = Base.parse(Core.Int, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(Int)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
#                         # print("Connect Timeout: ", connect_timeout, "\n");
#                     end

#                     if ARGSIArray[1] === "verbose"
#                         # global verbose = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
#                         global verbose = Base.parse(Core.Bool, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 "true / false";
#                         # print("verbose: ", verbose, "\n");
#                     end

#                     if ARGSIArray[1] === "requestFrom"
#                         global requestFrom = ARGSValue;  # 客戶端發送的請求頭中的 From 參數值;
#                         # print("requestFrom: ", requestFrom, "\n");
#                     end

#                     if ARGSIArray[1] === "requestPath"
#                         global requestPath = ARGSValue;
#                         # print("requestPath: ", requestPath, "\n");
#                     end

#                     if ARGSIArray[1] === "requestMethod"
#                         global requestMethod = ARGSValue;
#                         # print("requestMethod: ", requestMethod, "\n");
#                     end

#                     if ARGSIArray[1] === "requestProtocol"
#                         global requestProtocol = ARGSValue;
#                         # print("requestProtocol: ", requestProtocol, "\n");
#                     end

#                     if ARGSIArray[1] === "postData"
#                         # global postData = ARGSValue;  # 用於輸入傳值的媒介目錄 "../temp/";
#                         # g = Base.Meta.parse(Base.string(ARGSIArray[1]) * Base.string(ARGSValue));
#                         g = Base.Meta.parse("postData=" * Base.string(ARGSValue));
#                         Base.MainInclude.eval(g);
#                         # print("postData: ", postData, "\n");
#                     end

#                     if ARGSIArray[1] === "webPath"
#                         global webPath = ARGSValue;  # 用於輸入服務器的根目錄 "../";
#                         # print("webPath: ", webPath, "\n");
#                     end
#                 end
#             end
#         end
#     end
# end




# 示例函數，處理從硬盤文檔讀取到的JSON對象數據，然後返回處理之後的結果JSON對象，使用雙冒號::固定變量允許類型;
function do_data(data_Str::Core.String)::Core.String
    # println(data_Str);

    request_form_value::Core.String = data_Str;  # 函數接收到的參數值;

    response_data_Dict = Base.Dict{Core.String, Core.Any}();  # 函數返回值，聲明一個空字典;
    response_data_String::Core.String = "";

    # require_data_Dict = Base.Dict{Core.String, Core.Any}();  # Base.Dict{Core.String, Int64}()聲明一個空字典並指定數據類型;
    require_data_Dict = Base.Dict();  # 聲明一個空字典，函數接收到的參數;
    # # 使用自定義函數isStringJSON(request_form_value)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    # if isStringJSON(request_form_value)
        require_data_Dict = JSONparse(request_form_value);  # 使用自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # else
    #     require_data_Dict["Client_say"] = data_Str;  # Base.Dict(data_Str);  # Base.Dict("aa" => 1, "bb" => 2, "cc" => 3);
    # end
    # println(require_data_Dict);

    return_file_creat_time = Dates.now();  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
    # println(Base.string(Dates.now()))

    response_data_Dict["Server_say"] = Base.string(request_form_value);  # Base.Dict("Julia_say" => Base.string(request_form_value));
    response_data_Dict["time"] = Base.string(return_file_creat_time);  # Base.Dict("Julia_say" => Base.string(request_form_value), "time" => string(return_file_creat_time));
    # println(response_data_Dict);

    response_data_String = "{\"Server_say\":\"" * Base.string(request_form_value) * "\",\"time\":\"" * Base.string(return_file_creat_time) * "\"}";  # 使用星號*拼接字符串;
    # response_data_String = JSONstring(response_data_Dict);  # 使用自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # response_data_String = JSON.json(response_data_Dict);  # 使用第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # println(response_data_String);

    return response_data_String;
end


# # 使用示例;
# is_monitor = false;  # true; # Boolean，用於判別是執行一次，還是啓動監聽服務，持續監聽目標文檔，false 值表示只執行一次，true 值表示啓動監聽服務器看守進程持續監聽;
# monitor_dir = "D:/temp";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸入傳值的媒介目錄 "../Intermediary/";
# monitor_file = "D:/temp/intermediary_write_NodeJS.txt";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(monitor_dir, "intermediary_write_NodeJS.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於接收傳值的媒介文檔 "../Intermediary/intermediary_write_NodeJS.txt";
# output_dir = "D:/temp";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸出傳值的媒介目錄 "../Intermediary/";
# output_file = "D:/temp/intermediary_write_Julia.txt";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(output_dir, "intermediary_write_Julia.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於輸出傳值的媒介文檔 "../Intermediary/intermediary_write_Julia.txt";
# temp_cache_IO_data_dir = "D:/temp";  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_cache_IO_data_dir\";
# do_Function = do_data;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行數據處理功能的函數 "do_data";
# to_executable = "";  # C:/Progra~1/nodejs/node.exe";  # 上一層路徑下的Node.JS解釋器可執行檔路徑C:\nodejs\node.exe：Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "NodeJS", "node,exe")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的解釋器可執行文件 "..\\NodeJS\\node.exe"，Julia 解釋器可執行檔全名 println(Base.Sys.BINDIR)：C:\Julia 1.5.1\bin，;
# to_script = "";  # "C:/Users/china/Documents/Node.js/Criss/jl/test.js";  # 上一層路徑下的 JavaScript 脚本路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "js", "Ruuter.js")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的被調用的脚本文檔 "../js/Ruuter.js";
# time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
# number_Worker_threads = Core.UInt8(0);  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# isMonitorThreadsOrProcesses = 0;  # "Multi-Threading"; # "Multi-Processes"; # 選擇監聽動作的函數的并發層級（多協程、多綫程、多進程）;
# # 當 isMonitorThreadsOrProcesses = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# isDoTasksOrThreads = "Tasks";  # "Multi-Threading"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
# # 當 isDoTasksOrThreads = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl

# # a = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
# a = monitor_file_Run(
#     is_monitor=is_monitor,  # 用於判別是執行一次，還是啓動監聽服務，持續監聽目標文檔，false 值表示只執行一次，true 值表示啓動監聽服務器看守進程持續監聽;
#     monitor_file=monitor_file,  # 用於接收傳值的媒介文檔;
#     monitor_dir=monitor_dir,  # 用於輸入傳值的媒介目錄;
#     do_Function=do_Function,  # 用於接收執行數據處理功能的函數;
#     output_dir=output_dir,  # 用於輸出傳值的媒介目錄;
#     output_file=output_file,  # 用於輸出傳值的媒介文檔;
#     to_executable=to_executable,  # 用於對返回數據執行功能的解釋器二進制可執行檔;
#     to_script=to_script,  # 用於對返回數據執行功能的被調用的脚本文檔;
#     temp_cache_IO_data_dir=temp_cache_IO_data_dir,  # 用於暫存傳入傳出數據的臨時媒介文件夾;
#     number_Worker_threads=number_Worker_threads,  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目;
#     time_sleep=time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     read_file_do_Function=read_file_do_Function,  # 從指定的硬盤文檔讀取數據字符串，並調用相應的數據處理函數處理數據，然後將處理得到的結果再寫入指定的硬盤文檔;
#     monitor_file_do_Function=monitor_file_do_Function,  # 自動監聽指定的硬盤文檔，當硬盤指定目錄出現指定監聽的文檔時，就調用讀文檔處理數據函數;
#     isMonitorThreadsOrProcesses=isMonitorThreadsOrProcesses,  # 0 || "0" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     isDoTasksOrThreads=isDoTasksOrThreads # "Tasks" || "Multi-Threading"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# );
# # println(typeof(a))
# println(a[1])
# println(a[2])
# println(a[3])







# 示例函數，處理從客戶端 GET 或 POST 請求的信息，然後返回處理之後的結果JSON對象字符串數據;
function do_Request(request_Dict::Base.Dict{Core.String, Core.Any})::Core.String

    # print("當前協程 task: ", Base.current_task(), "\n");
    # print("當前協程 task 的 ID: ", Base.objectid(Base.current_task()), "\n");
    # print("當前綫程 thread 的 PID: ", Base.Threads.threadid(), "\n");
    # print("Julia 進程可用的綫程數目上綫: ", Base.Threads.nthreads(), "\n");
    # print("當前進程的 PID: ", Distributed.myid(), "\n");  # 需要事先加載原生的支持多進程標準模組 using Distributed 模組;
    # println(request_Dict);

    request_POST_String::Core.String = "";  # request_Dict["request_body_String"];  # 客戶端發送 post 請求時的請求體數據;
    request_POST_bytes_Array::Core.Union{Base.IOStream, Base.IOBuffer, Core.Nothing, Core.String, Core.Array{Core.UInt8, 1}, Base.Vector{UInt8}} = Base.IOBuffer();  # Core.Array{Core.UInt8, 1}();  # Core.Array{Core.UInt8, 1}();  # ::Core.Union{Base.Vector{Core.UInt8}, Core.String, Base.IOBuffer};
    request_POST_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}();
    request_Url::Core.String = "";  # request_Dict["Target"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
    request_Path::Core.String = "";  # request_Dict["request_Path"];  # 客戶端發送請求的路徑 "/index.html";
    request_Url_Query_String::Core.String = "";  # request_Dict["request_Url_Query_String"];  # 客戶端發送請求 url 中的查詢字符串 "a=1&b=2";
    request_Url_Query_Dict = Base.Dict{Core.String, Core.Any}();  # 客戶端請求 url 中的查詢字符串值解析字典 Base.Dict("a" => 1, "b" => 2);
    request_Authorization::Core.String = "";  # request_Dict["Authorization"];  # 客戶端發送請求的用戶名密碼驗證字符串;
    request_Cookie::Core.String = "";  # request_Dict["Cookie"];  # 客戶端發送請求的 Cookie 值字符串;
    request_Nikename::Core.String = "";  # request_Dict["request_Nikename"];  # 客戶端發送請求的驗證昵稱值字符串;
    request_Password::Core.String = "";  # request_Dict["request_Password"];  # 客戶端發送請求的驗證密碼值字符串;
    # request_time::Core.String = "";  # request_Dict["time"];  # 客戶端發送請求的 time 值字符串;
    # request_Date::Core.String = "";  # request_Dict["Date"];  # 客戶端發送請求的日期值字符串;
    request_IP::Core.String = "";  # request_Dict["request_IP"];  # 客戶端發送請求的 IP 地址字符串;
    # request_Method::Core.String = "";  # request_Dict["request_Method"];  # 客戶端發送請求的方法值字符串 "get"、"post";
    # request_Protocol::Core.String = "";  # request_Dict["request_Protocol"];  # 客戶端發送請求的協議值字符串 "HTTP/1.1:"、"https:";
    request_User_Agent::Core.String = "";  # request_Dict["User-Agent"];  # 客戶端發送請求的客戶端名字值字符串;
    request_From::Core.String = "";  # request_Dict["From"];  # 客戶端發送請求的來源值字符串;
    request_Host::Core.String = "";  # request_Dict["Host"];  # 客戶端發送請求的服務器名字和埠號值字符串 "127.0.0.1:8000"、"localhost:8000";
    if Base.length(request_Dict) > 0
        # Base.isa(request_Dict, Base.Dict)

        if Base.haskey(request_Dict, "request_body_String")
            request_POST_String = request_Dict["request_body_String"];  # 客戶端發送 post 請求時的請求體數據;
        end
        if Base.haskey(request_Dict, "request_body_bytes_Array")
            request_POST_bytes_Array = request_Dict["request_body_bytes_Array"];  # 客戶端發送 post 請求時的請求體數據;
        end
        if Base.haskey(request_Dict, "request_body_Dict")
            request_POST_Dict = request_Dict["request_body_Dict"];  # 客戶端發送 post 請求時的請求體數據;
        end
        if Base.haskey(request_Dict, "request_Url")
            request_Url = request_Dict["request_Url"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
        elseif Base.haskey(request_Dict, "Target")
            request_Url = request_Dict["Target"];  # 客戶端發送請求的 url 字符串 "/index.html?a=1&b=2#idStr";
        else
        end
        if Base.haskey(request_Dict, "request_Path")
            request_Path = request_Dict["request_Path"];  # 客戶端發送請求的路徑 "/index.html";
        end
        if Base.haskey(request_Dict, "request_Url_Query_String")
            request_Url_Query_String = request_Dict["request_Url_Query_String"];  # 客戶端發送請求 url 中的查詢字符串 "a=1&b=2";
        end
        if Base.haskey(request_Dict, "request_Url_Query_Dict") && Base.isa(request_Dict["request_Url_Query_Dict"], Base.Dict)
            request_Url_Query_Dict = request_Dict["request_Url_Query_Dict"];  # 客戶端請求 url 中的查詢字符串值解析字典 Base.Dict("a" => 1, "b" => 2);
        end
        if Base.haskey(request_Dict, "Host")
            request_Host = request_Dict["Host"];  # 客戶端發送請求的目標服務器主機名和埠號字符串，127.0.0.7:8000;
        end
        if Base.haskey(request_Dict, "Authorization")
            request_Authorization = request_Dict["Authorization"];  # 客戶端發送請求的用戶名密碼驗證字符串;
        end
        if Base.haskey(request_Dict, "Cookie")
            request_Cookie = request_Dict["Cookie"];  # 客戶端發送請求的 Cookie 值字符串;
        end
        if Base.haskey(request_Dict, "request_Nikename")
            request_Nikename = request_Dict["request_Nikename"];  # 客戶端發送請求的驗證昵稱值字符串;
        end
        if Base.haskey(request_Dict, "request_Password")
            request_Password = request_Dict["request_Password"];  # 客戶端發送請求的驗證密碼值字符串;
        end
        # if Base.haskey(request_Dict, "time")
        #     request_time = request_Dict["time"];  # 客戶端發送請求的 time 值字符串;
        # end
        # if Base.haskey(request_Dict, "Date")
        #     request_Date = request_Dict["Date"];  # 客戶端發送請求的日期值字符串;
        # end
        if Base.haskey(request_Dict, "request_IP")
            request_IP = request_Dict["request_IP"];  # 客戶端發送請求的 IP 地址字符串;
        end
        # if Base.haskey(request_Dict, "request_Method")
        #     request_Method = request_Dict["request_Method"];  # 客戶端發送請求的方法值字符串 "get"、"post";
        # end
        # if Base.haskey(request_Dict, "request_Protocol")
        #     request_Protocol = request_Dict["request_Protocol"];  # 客戶端發送請求的協議值字符串 "http:"、"https:";
        # end
        if Base.haskey(request_Dict, "User-Agent")
            request_User_Agent = request_Dict["User-Agent"];  # 客戶端發送請求的客戶端名字值字符串;
        end
        if Base.haskey(request_Dict, "From")
            request_From = request_Dict["From"];  # 客戶端發送請求的來源值字符串;
        end
        # if Base.haskey(request_Dict, "Host")
        #     request_Host = request_Dict["Host"];  # 客戶端發送請求的服務器名字值字符串 "127.0.0.1"、"localhost";
        # end
    end

    if Base.length(request_Dict) === 0 || !Base.haskey(request_Dict, "Host") || request_Host === ""
        # 使用 Core.isa(Base.ARGS[i], Core.String) 函數判断「元素(变量实例)」是否属于「集合(变量类型集)」之间的关系，使用 Base.typeof(Base.ARGS[i]) <: Core.String 方法判断「集合」是否包含于「集合」之间的关系，或 Base.typeof(Base.ARGS[i]) === Core.String 方法判斷傳入的參數是否為 String 字符串類型;
        # println(host);
        # println(Base.typeof(host));
        # println(Core.isa(host, Sockets.IPv6));
        # println(Base.typeof(host) <: Sockets.IPv6);
        # println(Base.typeof(host) === Sockets.IPv6);
        # println(Core.isa(host, Sockets.IPv4));
        # println(Base.typeof(host) <: Sockets.IPv4);
        # println(Base.typeof(host) === Sockets.IPv4);
        # println(Base.typeof(Sockets.IPv4("0.0.0.0")));
        # println(Base.typeof(Sockets.IPv6("0")));
        # println(request_IP);
        if Base.haskey(request_Dict, "request_IP") && request_IP !== ""
            if Base.typeof(host) === Sockets.IPv6
                request_Host = Base.string("[", Base.string(request_IP), "]:", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，[::1]:8000;
            elseif Base.typeof(host) === Sockets.IPv4
                request_Host = Base.string(Base.string(request_IP), ":", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，127.0.0.1:8000;
            else
            end
        # else
        #     if Base.typeof(host) === Sockets.IPv6
        #         if Base.string(host) === "localhost" || Base.string(host) === "::" || Base.string(host) === "0" || Base.string(host) === "::0" || Base.string(host) === "::1"
        #             request_Host = Base.string("[::1]:", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，[::1]:8000;
        #         else
        #             request_Host = Base.string("[", Base.string(host), "]:", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，[::1]:8000;
        #         end
        #     elseif Base.typeof(host) === Sockets.IPv4
        #         if Base.string(host) === "localhost" || Base.string(host) === "0.0.0.0" || Base.string(host) === "127.0.0.1"
        #             request_Host = Base.string("127.0.0.1:", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，[::1]:8000;
        #         else
        #             request_Host = Base.string(Base.string(host), ":", Base.string(port));  # 客戶端發送請求的目標服務器主機名和埠號字符串，127.0.0.1:8000;
        #         end
        #     else
        #     end
        end
    end
    # println(request_Host);

    # # 將客戶端請求 url 中的查詢字符串值解析為 Julia 字典類型;
    # # request_Url_Query_Dict = Base.Dict{Core.String, Core.Any}();  # 客戶端請求 url 中的查詢字符串值解析字典 Base.Dict("a" => 1, "b" => 2);
    # if Base.isa(request_Url_Query_String, Core.String) && request_Url_Query_String !== ""
    #     if Base.occursin('&', request_Url_Query_String)
    #         # url_Query_Array = Core.Array{Core.Any, 1}();  # 聲明一個任意類型的空1維數組，可以使用 Base.push! 函數在數組末尾追加推入新元素;
    #         # url_Query_Array = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
    #         # 函數 Base.split(request_Url_Query_String, '&') 表示用等號字符'&'分割字符串為數組;
    #         for XXX in Base.split(request_Url_Query_String, '&')
    #             temp = Base.strip(XXX);  # Base.strip(str) 去除字符串首尾兩端的空格;
    #             temp = Base.convert(Core.String, temp);  # 使用 Base.convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
    #             # temp = Base.string(temp);
    #             if Base.isa(temp, Core.String) && Base.occursin('=', temp)
    #                 tempKey = Base.split(temp, '=')[1];
    #                 tempKey = Base.strip(tempKey);
    #                 tempKey = Base.convert(Core.String, tempKey);
    #                 tempKey = Base.string(tempKey);
    #                 # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
    #                 # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
    #                 # # Base64.base64decode("base64_Str");  # 解碼;
    #                 tempValue = Base.split(temp, '=')[2];
    #                 tempValue = Base.strip(tempValue);
    #                 tempValue = Base.convert(Core.String, tempValue);
    #                 tempValue = Base.string(tempValue);
    #                 # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
    #                 # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
    #                 # # Base64.base64decode("base64_Str");  # 解碼;
    #                 request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
    #             else
    #                 request_Url_Query_Dict[Base.string(temp)] = Base.string("");
    #             end
    #         end
    #     else
    #         if Base.isa(request_Url_Query_String, Core.String) && Base.occursin('=', request_Url_Query_String)
    #             tempKey = Base.split(request_Url_Query_String, '=')[1];
    #             tempKey = Base.strip(tempKey);
    #             tempKey = Base.convert(Core.String, tempKey);
    #             tempKey = Base.string(tempKey);
    #             # tempKey = Core.String(Base64.base64decode(tempKey));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
    #             # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
    #             # # Base64.base64decode("base64_Str");  # 解碼;
    #             tempValue = Base.split(request_Url_Query_String, '=')[2];
    #             tempValue = Base.strip(tempValue);
    #             tempValue = Base.convert(Core.String, tempValue);
    #             tempValue = Base.string(tempValue);
    #             # tempValue = Core.String(Base64.base64decode(tempValue));  # 讀取客戶端發送的請求 url 中的查詢字符串 "/index.html?a=1&b=2#id" ，並是使用 Core.String(<object byets>) 方法將字節流數據轉換爲字符串類型，需要事先加載原生的 Base64 模組：using Base64 模組;
    #             # # Base64.base64encode("text_Str"; context=nothing);  # 編碼;
    #             # # Base64.base64decode("base64_Str");  # 解碼;
    #             request_Url_Query_Dict[Base.string(tempKey)] = Base.string(tempValue);
    #         else
    #             request_Url_Query_Dict[Base.string(request_Url_Query_String)] = Base.string("");
    #         end
    #     end
    # end

    # 將客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
    request_data_Dict = Base.Dict{Core.String, Core.Any}();  # 聲明一個空字典，客戶端 post 請求發送的字符串數據解析為 Julia 字典（Dict）對象;
    # # request_data_Dict = Core.nothing;
    # if Base.isa(request_POST_String, Core.String) && request_POST_String !== ""
    #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
    #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    #     request_data_Dict = JSONparse(request_POST_String);  # 使用自定義函數 JSONparse() 將請求 Post 字符串解析為 Julia 字典（Dict）對象類型;
    # end
    # println(request_data_Dict);

    response_body_Dict = Base.Dict{Core.String, Core.Any}();  # 函數返回值，聲明一個空字典;
    response_body_String::Core.String = "";

    # # require_data_Dict = Base.Dict{Core.String, Core.Any}();  # Base.Dict{Core.String, Int64}()聲明一個空字典並指定數據類型;
    # require_data_Dict = Base.Dict();  # 聲明一個空字典，函數接收到的參數;
    # # 使用自定義函數isStringJSON(request_form_value)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    # if isStringJSON(request_form_value)
    #     require_data_Dict = JSONparse(request_form_value);  # 使用自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # require_data_Dict = JSON.parse(request_form_value);  # 使用第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # else
    #     require_data_Dict["Client_say"] = data_Str;  # Base.Dict(data_Str);  # Base.Dict("aa" => 1, "bb" => 2, "cc" => 3);
    # end

    # 需要先加載 Julia 原生的 Dates 模組：using Dates;
    # 函數 Dates.now() 返回當前日期時間對象 2021-06-28T12:12:50.544，使用 Base.string(Dates.now()) 方法，可以返回當前日期時間字符串 2021-06-28T12:12:50.544。
    # 函數 Dates.time() 當前日期時間的 Unix 值 1.652232489777e9，UNIX 時間，或稱爲 POSIX 時間，是 UNIX 或類 UNIX 系統使用的時間表示方式：從 UTC 1970 年 1 月 1 日 0 時 0 分 0 秒起至現在的縂秒數，不考慮閏秒。
    # 函數 Dates.unix2datetime(Dates.time()) 將 Unix 時間轉化爲日期（時間）對象，使用 Base.string(Dates.unix2datetime(Dates.time())) 方法，可以返回當前日期時間字符串 2021-06-28T12:12:50。
    return_file_creat_time = Dates.now();  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
    # println(Base.string(Dates.now()))

    response_body_Dict["request_Url"] = Base.string(request_Url);  # Base.Dict("Target" => Base.string(request_Url));
    # response_body_Dict["request_Path"] = Base.string(request_Path);  # Base.Dict("request_Path" => Base.string(request_Path));
    # response_body_Dict["request_Url_Query_String"] = Base.string(request_Url_Query_String);  # Base.Dict("request_Url_Query_String" => Base.string(request_Url_Query_String));
    # response_body_Dict["request_POST"] = Base.string(request_POST_String);  # Base.Dict("request_POST" => Base.string(request_POST_String));
    response_body_Dict["request_Authorization"] = Base.string(request_Authorization);  # Base.Dict("request_Authorization" => Base.string(request_Authorization));
    response_body_Dict["request_Cookie"] = Base.string(request_Cookie);  # Base.Dict("request_Cookie" => Base.string(request_Cookie));
    # response_body_Dict["request_Nikename"] = Base.string(request_Nikename);  # Base.Dict("request_Nikename" => Base.string(request_Nikename));
    # response_body_Dict["request_Password"] = Base.string(request_Password);  # Base.Dict("request_Password" => Base.string(request_Password));
    response_body_Dict["time"] = Base.string(return_file_creat_time);  # Base.Dict("request_POST" => Base.string(request_POST_String), "time" => string(return_file_creat_time));
    # response_body_Dict["Server_Authorization"] = Base.string(key);  # "username:password"，Base.Dict("Server_Authorization" => Base.string(key));
    response_body_Dict["Server_say"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
    response_body_Dict["error"] = Base.string("");  # Base.Dict("Server_say" => Base.string(request_POST_String));
    # println(response_body_Dict);

    # # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    # # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    # # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
    # response_body_String = JSONstring(response_body_Dict);

    # webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
    web_path::Core.String = "";  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
    file_data::Core.String = "";  # 用於保存從硬盤讀取文檔中的數據;
    dir_list_Arror = Core.Array{Core.String, 1}();  # Core.Array{Core.Any, 1}(); # 用於保存從硬盤讀取文件夾中包含的子文檔和子文件夾名稱清單的字符串數組;

    fileName::Core.String = "";  # "/JuliaServer.jl" 自定義的待替換的文件路徑全名;
    # Base.isa(request_Url_Query_Dict, Base.Dict)
    if Base.haskey(request_Url_Query_Dict, "fileName")
        fileName = Base.string(request_Url_Query_Dict["fileName"]);  # "/JuliaServer.jl" 自定義的待替換的文件路徑全名;
    end
    if Base.haskey(request_Url_Query_Dict, "Key")
        global key = Base.string(request_Url_Query_Dict["Key"]);  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
    end
    algorithmUser::Core.String = "";  # 使用算法的驗證賬號;
    if Base.haskey(request_Url_Query_Dict, "algorithmUser")
        algorithmUser = Base.string(request_Url_Query_Dict["algorithmUser"]);  # "username" 使用算法的驗證賬號;
    end
    algorithmPass::Core.String = "";  # 使用算法的驗證密碼;
    if Base.haskey(request_Url_Query_Dict, "algorithmPass")
        algorithmPass = Base.string(request_Url_Query_Dict["algorithmPass"]);  # "password" 使用算法的驗證賬號;
    end
    algorithmName::Core.String = "";  # "Fitting"、"Simulation" 具體算法的名稱;
    if Base.haskey(request_Url_Query_Dict, "algorithmName")
        algorithmName = Base.string(request_Url_Query_Dict["algorithmName"]);  # "Fitting"、"Simulation" 具體算法的名稱;
    end

    # println(request_Path);
    if request_Path === "/"
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "index.html"));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), "/index.html"));  # 拼接本地當前目錄下的請求文檔名;
        # println(web_path);

        file_data = "";
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(web_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(web_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(web_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                else
                    response_body_Dict["Server_say"] = "文檔: " * web_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("指定的文檔: " * web_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的文檔: " * web_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "請求文檔: " * web_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        response_body_String = file_data;
        # println(response_body_String);

        return response_body_String;

    elseif request_Path === "/index.html"
        # 客戶端或瀏覽器請求 url = http://127.0.0.1:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
        file_data = "";

        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(web_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(web_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(web_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(file_data);
                else
                    response_body_Dict["Server_say"] = "文檔: " * web_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("指定的文檔: " * web_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的文檔: " * web_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "請求文檔: " * web_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        response_body_String = file_data;
        # println(response_body_String);

        return response_body_String;

    elseif request_Path === "/administrator.html"
        # 客戶端或瀏覽器請求 url = http://localhost:10001/index.html?Key=username:password&algorithmUser=username&algorithmPass=password

        web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/administrator.html" 字符串首的斜杠 '/' 字符;
        file_data = "";

        directoryHTML = "<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>";

        # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組;
        if Base.Filesystem.ispath(webPath) && Base.Filesystem.isdir(webPath)

            dir_list_Arror = Base.Filesystem.readdir(webPath);  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
            # Base.length(Base.Filesystem.readdir(webPath));
            # if Base.length(dir_list_Arror) > 0

                for item in dir_list_Arror

                    # if request_Path === "/"
                    #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, item), "?fileName=", Base.string(request_Path, item), "&Key=", Base.string(key), "#");
                    #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, item), "&Key=", Base.string(key), "#");
                    # elseif request_Path === "/index.html"
                    #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                    #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                    # else
                    #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, "/", item), "?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                    #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                    # end

                    if request_Host === ""
                        name_href_url_string = Base.string(Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        delete_href_url_string = Base.string("/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                    else
                        name_href_url_string = Base.string("http://", Base.string(request_Host), Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        # name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        delete_href_url_string = Base.string("http://", Base.string(request_Host), "/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        # delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                    end

                    downloadFile_href_string = """fileDownload('post', 'UpLoadData', '$(Base.string(name_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '$(Base.string(item))', function(error, response){})""";
                    deleteFile_href_string = """deleteFile('post', 'UpLoadData', '$(Base.string(delete_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})""";

                    statsObj = Base.stat(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(item))));

                    if Base.Filesystem.isfile(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(item))))
                        # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Float64(statsObj.size) / Core.Float64(1024.0)), " KiloBytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
                        # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
                        # directoryHTML = directoryHTML * "<tr><td><a href=\"javascript:" * Base.string(downloadFile_href_string) * "\">" * Base.string(item) * "</a></td><td>" * Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes") * "</td><td>" * Base.string(Dates.unix2datetime(statsObj.mtime)) * "</td><td><a href=\"javascript:" * Base.string(deleteFile_href_string) * "\">刪除</a></td></tr>";
                        directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
                        # directoryHTML = directoryHTML * """<tr><td><a onclick="$(downloadFile_href_string)" href="javascript:void(0)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a onclick="$(deleteFile_href_string)" href="javascript:void(0)">刪除</a></td></tr>""";
                        # directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>""";
                    elseif Base.Filesystem.isdir(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(item))))
                        # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td></td><td></td></tr>""";
                        # directoryHTML = directoryHTML * "<tr><td><a href=\"" * Base.string(name_href_url_string) * "\">" * Base.string(item) * "</a></td><td>" * Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes") * "</td><td>" * Base.string(Dates.unix2datetime(statsObj.mtime)) * "</td><td><a href=\"javascript:" * Base.string(deleteFile_href_string) * "\">刪除</a></td></tr>";
                        directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td></td><td></td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
                        # directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="$(delete_href_url_string)">刪除</a></td></tr>""";
                    else
                    end

                end

            # end

        else

            response_body_Dict["Server_say"] = "服務器的運行路徑: " * webPath * " 無法識別.";
            response_body_Dict["error"] = "Folder = { " * Base.string(webPath) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end
        # 同步讀取硬盤 .html 文檔，返回字符串;
        if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)

            fRIO = Core.nothing;  # ::IOStream;
            try
                # line = Base.Filesystem.readlink(web_path);  # 讀取文檔中的一行數據;
                # Base.readlines — Function
                # Base.readlines(io::IO=stdin; keep::Bool=false)
                # Base.readlines(filename::AbstractString; keep::Bool=false)
                # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                # for line in eachline(web_path)
                #     print(line);
                # end
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                # 在 Base.open() 函數中，還可以調用函數;
                # Base.open(Base.readline, "sdy.txt");
                # 也可以調用自定義函數;
                # readFunc(s::IOStream) = Base.read(s, Char);
                # Base.open(readFunc, "sdy.txt");
                # 還可以像Python中的 with open...as 的用法一樣打開文件;
                # Base.open("sdy.txt","r") do stream
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # 也可以將上述程序定義成函數再用open操作;
                # function readFunc2(stream)
                #     for line in eachline(stream)
                #         println(line);
                #     end
                # end
                # Base.open(readFunc2, "sdy.txt");

                fRIO = Base.open(web_path, "r");
                # nb = countlines(fRIO);  # 計算文檔中數據行數;
                # seekstart(fRIO);  # 指針返回文檔的起始位置;

                # Keyword	Description				Default
                # read		open for reading		!write
                # write		open for writing		truncate | append
                # create	create if non-existent	!read & write | truncate | append
                # truncate	truncate to zero size	!read & write
                # append	seek to end				false

                # Mode	Description						Keywords
                # r		read							none
                # w		write, create, truncate			write = true
                # a		write, create, append			append = true
                # r+	read, write						read = true, write = true
                # w+	read, write, create, truncate	truncate = true, read = true
                # a+	read, write, create, append		append = true, read = true

                # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                # Base.read(io, Core.String);
                # "JuliaLang is a GitHub organization";
                # Base.read(filename::AbstractString, Core.String);
                # Read the entire contents of a file as a string.
                # Base.read(s::IOStream, nb::Integer; all=true);
                # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                # Base.read(command::Cmd)
                # Run command and return the resulting output as an array of bytes.
                # Base.read(command::Cmd, Core.String)
                # Run command and return the resulting output as a String.
                # Base.read!(stream::IO, array::Union{Array, BitArray})
                # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                # Read binary data from an I/O stream or file, filling in array.
                # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                # 使用 isreadable(io) 函數判斷文檔是否可讀;
                if Base.isreadable(fRIO)
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                    file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    # println(file_data);
                else
                    response_body_Dict["Server_say"] = "文檔: " * web_path * " 無法讀取數據.";
                    response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) unable to read.";

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                # Base.ismarked(io);  # Return true if stream s is marked;
                # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                # Base.close(io);  # 關閉緩衝區;
                # println(a)
                # Base.redirect_stdout — Function
                # redirect_stdout([stream]) -> (rd, wr)
                # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                # If called with the optional stream argument, then returns stream itself.
                # Base.redirect_stdout — Method
                # redirect_stdout(f::Function, stream)
                # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                # Base.redirect_stderr — Function
                # redirect_stderr([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stderr.
                # Base.redirect_stderr — Method
                # redirect_stderr(f::Function, stream)
                # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                # Base.redirect_stdin — Function
                # redirect_stdin([stream]) -> (rd, wr)
                # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                # Base.redirect_stdin — Method
                # redirect_stdin(f::Function, stream)
                # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

            catch err

                if Core.isa(err, Core.InterruptException)

                    print("\n");
                    # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                    # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                    println("[ Ctrl ] + [ c ] received, will be return Function.");

                    # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                    # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                    response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                    response_body_Dict["error"] = Base.string(err);

                else

                    println("指定的文檔: " * web_path * " 無法讀取.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的文檔: " * web_path * " 無法讀取.";
                    response_body_Dict["error"] = Base.string(err);
                end

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            finally
                Base.close(fRIO);
            end

            fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
            # Base.GC.gc();  # 内存回收函數 gc();

        else

            response_body_Dict["Server_say"] = "請求文檔: " * web_path * " 無法識別.";
            response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end
        # 替換 .html 文檔中指定的位置字符串;
        if file_data !== ""
            response_body_String = Base.string(Base.replace(file_data, "<!-- directoryHTML -->" => directoryHTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
        else
            response_body_Dict["Server_say"] = "文檔: " * web_path * " 爲空.";
            response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) empty.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            # Base.exit(0);
            return response_body_String;
        end
        # println(response_body_String);

        return response_body_String;

    elseif request_Path === "/uploadFile"
        # 客戶端或瀏覽器請求 url = http://localhost:10001/uploadFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=JuliaServer.jl

        if fileName === ""
            println("Upload file name empty { " * fileName * " }.");
            response_body_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " * Base.string(fileName) * " } 爲空.";
            response_body_Dict["error"] = "File name = { " * Base.string(fileName) * " } empty.";
            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        web_path = "";
        if Base.string(fileName)[begin] === '/' || Base.string(fileName)[begin] === '\\'
            web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(Base.string(fileName)[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(fileName)));  # 拼接本地當前目錄下的請求文檔名;
        else
            web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(fileName)));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(fileName)));  # 拼接本地當前目錄下的請求文檔名;
        end

        # println(request_POST_String);
        # file_data = Base.string(request_POST_String);
        # println(file_data);

        file_data_UInt8Array = Core.Array{Core.UInt8, 1}();
        # file_data_UInt8Array = Core.Array{Core.Union{Core.UInt8, Core.String}, 1}();
        if Base.isa(request_POST_String, Core.String) && request_POST_String !== ""
            if Base.occursin("[", request_POST_String) && Base.occursin("]", request_POST_String) && request_POST_String !== "[]" && request_POST_String !== "\"[]\"" && request_POST_String !== "\\\"[]\\\""
                file_data_UInt8Array_String = "";
                if request_POST_String[begin] === '\\' && request_POST_String[begin+1] === '\"' && request_POST_String[begin+2] === '[' && request_POST_String[end-2] === ']' && request_POST_String[end-1] === '\\' && request_POST_String[end] === '\"'
                    file_data_UInt8Array_String = Base.string(request_POST_String[begin+3:end-3]);  # 刪除數組字符串首端的 '\"[' 字符和尾端的 ']\"' 字符;
                elseif request_POST_String[begin] === '\"' && request_POST_String[begin+1] === '[' && request_POST_String[end-1] === ']' && request_POST_String[end] === '\"'
                    file_data_UInt8Array_String = Base.string(request_POST_String[begin+2:end-2]);  # 刪除數組字符串首端的 '"[' 字符和尾端的 ']"' 字符;
                elseif request_POST_String[begin] === '[' && request_POST_String[end] === ']'
                    file_data_UInt8Array_String = Base.string(request_POST_String[begin+1:end-1]);  # 刪除數組字符串首端的 '[' 字符和尾端的 ']' 字符;
                else
                end
                # println(file_data_UInt8Array_String);
                if file_data_UInt8Array_String !== "" && file_data_UInt8Array_String !== ","
                    if Base.occursin(",", file_data_UInt8Array_String)
                        file_data_UInt8Array = [Base.parse(Core.UInt8, X, base=10) for X = Base.split(file_data_UInt8Array_String, ",")];  # Julia 的數組推導式：[x+y for x=[[1,2] [3,4]], y=10:10:30 if isodd(x)] 返回值為：6-element Array{Int64,1}[11,13,21,23,31,33]，函數 Base.parse() 表示將字符串類型變量解析為數字類型變量，參數 base=10 表示基於十進制轉換;
                        # file_data_UInt8Array_String = Base.string("[", Base.string(Base.join(file_data_UInt8Array, ",")), "]");
                        # file_data_UInt8Array_String = "[" * Base.string(Base.join(file_data_UInt8Array, ",")) * "]";
                    else
                        Base.push!(file_data_UInt8Array, Base.parse(Core.UInt8, file_data_UInt8Array_String, base=10));  # 使用 push! 函數在數組末尾追加推入新元素，函數 Base.parse() 表示將字符串類型變量解析為數字類型變量，參數 base=10 表示基於十進制轉換;
                    end
                end
            end
        end

        # file_data_bytes_Array = Core.Array{Core.Any, 1}();  # 聲明一個 Core.Any 類型的空一維數組，客戶端 post 請求發送的字符串數據解析為 Julia 數組（Array）對象;
        # if Base.isa(request_POST_String, Core.String) && request_POST_String !== ""
        #     file_data_bytes_Array = JSONparse(request_POST_String);  # 使用自定義函數將 JSON 字符串轉換爲 Core.Any 類型的一維數組;
        #     # JSONstring(Dict_Array::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}})::Core.String
        #     # JSONparse(JSON_string::Core.String)::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}}
        # end
        # println(file_data_bytes_Array);
        # file_data_UInt8Array = Core.Array{Core.UInt8, 1}();
        # # file_data_UInt8Array = Core.Array{Core.Union{Core.UInt8, Core.String}, 1}();
        # for i = 1:Base.length(file_data_bytes_Array)
        #     # 使用 Core.isa(do_data, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_data) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_data) <: Function 方法判別 do_data 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
        #     if Core.isa(file_data_bytes_Array[i], Core.UInt8)
        #         Base.push!(file_data_UInt8Array, file_data_bytes_Array[i]);  # 使用 push! 函數在數組末尾追加推入新元素;
        #     elseif Core.isa(file_data_bytes_Array[i], Core.String) && file_data_bytes_Array[i] !== ""
        #         Base.push!(file_data_UInt8Array, Base.parse(Core.UInt8, file_data_bytes_Array[i], base=10));  # 函數 Base.parse() 表示將字符串類型變量解析為數字類型變量，參數 base=10 表示基於十進制轉換;
        #     elseif Core.isa(file_data_bytes_Array[i], Core.Float64)
        #         Base.push!(file_data_UInt8Array, Base.convert(Core.UInt8, file_data_bytes_Array[i]));
        #     elseif Core.isa(file_data_bytes_Array[i], Core.Int64)
        #         Base.push!(file_data_UInt8Array, Base.convert(Core.UInt8, file_data_bytes_Array[i]));
        #     else
        #         Base.push!(file_data_UInt8Array, Base.convert(Core.UInt8, file_data_bytes_Array[i]));
        #     end
        # end
        # println(file_data_UInt8Array);
        # request_data_Dict = file_data_UInt8Array;

        # 使用 Julia 原生的基礎模組 Base 中的 Base.Filesystem 模塊中的 Base.Filesystem.ispath() 函數判斷指定的文檔是否存在，如果存在則判斷操作權限，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
        if Base.Filesystem.ispath(webPath) && Base.Filesystem.isfile(web_path)

            # 檢查待寫入文檔操作權限;
            if Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
                # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
                println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                try
                    # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
                    # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                    Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                    # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                    # 八進制值    說明
                    # 0o400      所有者可讀
                    # 0o200      所有者可寫
                    # 0o100      所有者可執行或搜索
                    # 0o40       群組可讀
                    # 0o20       群組可寫
                    # 0o10       群組可執行或搜索
                    # 0o4        其他人可讀
                    # 0o2        其他人可寫
                    # 0o1        其他人可執行或搜索
                    # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                    # 數字	說明
                    # 7	可讀、可寫、可執行
                    # 6	可讀、可寫
                    # 5	可讀、可執行
                    # 4	唯讀
                    # 3	可寫、可執行
                    # 2	只寫
                    # 1	只可執行
                    # 0	沒有許可權
                    # 例如，八進制值 0o765 表示：
                    # 1) 、所有者可以讀取、寫入和執行該文檔；
                    # 2) 、群組可以讀和寫入該文檔；
                    # 3) 、其他人可以讀取和執行該文檔；
                    # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                    # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                catch err
                    println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "文檔 [ " * "/" * Base.string(fileName) * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .";  # "document [ file = " * "/" * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                    # response_body_Dict["Server_say"] = "文檔 [ " * Base.string(web_path) * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .";  # "document [ file = " * Base.string(web_path) * " ] change the permissions mode=0o777 fail.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end
            end

            # 同步刪除，已經存在的文檔，重新創建;
            try
                # Base.Filesystem.rm(path::AbstractString; force::Bool=false, recursive::Bool=false)
                # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                Base.Filesystem.rm(web_path, force=true, recursive=false);  # 刪除給定路徑下的文檔、鏈接或空目錄，如果傳遞參數 force=true 時，則不存在的路徑不被視爲錯誤，如果傳遞參數 recursive=true 并且路徑是目錄時，則遞歸刪除所有内容;
                # Base.Filesystem.rm(path::AbstractString, force::Bool=false, recursive::Bool=false)
                # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                # println("媒介文檔: " * web_path * " 已被刪除.");
            catch err
                println("文檔: " * web_path * " 無法刪除.");
                println(err);
                # println(err.msg);
                # println(Base.typeof(err));

                response_body_Dict["Server_say"] = "文檔: " * "/" * Base.string(fileName) * " 無法刪除.";  # "document [ file = " * "/" * Base.string(fileName) * " ] not delete.";
                # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 無法刪除.";  # "document [ file = " * Base.string(web_path) * " ] not delete.";
                response_body_Dict["error"] = Base.string(err);

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end

            # Base.sleep(time_sleep);  # 程序休眠，單位為秒，0.02;
            # # Base.sleep(seconds)  Block the current task for a specified number of seconds. The minimum sleep time is 1 millisecond or input of 0.001.

            # # 判斷文檔是否已經從硬盤刪除;
            # if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)
            #     println("文檔: " * web_path * " 無法刪除.");

            #     response_body_Dict["Server_say"] = "文檔: " * web_path * " 無法刪除.";  # "document [ output file = " * Base.string(web_path) * " ] not delete.";
            #     response_body_Dict["error"] = Base.string(err);

            #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            #     # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #     # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_body_String = JSONstring(response_body_Dict);
            #     # println(response_body_String);
            #     # Base.exit(0);
            #     return response_body_String;
            # end
        else

            # 截取目標寫入目錄;
            writeDirectory::Core.String = "";
            # println(fileName);
            if Base.isa(fileName, Core.String) && Base.occursin('/', fileName)
                tempArray = Core.Array{Core.String, 1}();
                tempArray = Base.split(fileName, '/');
                if Core.Int64(Base.length(tempArray)) <= Core.Int64(2)
                    writeDirectory = "/";
                else
                    for i = 1:Core.Int64(Core.Int64(Base.length(tempArray)) - Core.Int64(1))
                        if Core.Int64(i) === Core.Int64(1)
                            writeDirectory = Base.string(tempArray[i]);
                        else
                            writeDirectory = Base.string(writeDirectory) * "/" * Base.string(tempArray[i]);
                        end
                    end
                end
            elseif Base.isa(fileName, Core.String) && Base.occursin('\\', fileName)
                tempArray = Core.Array{Core.String, 1}();
                tempArray = Base.split(fileName, '\\');
                if Core.Int64(Base.length(tempArray)) <= Core.Int64(2)
                    writeDirectory = "\\";
                else
                    for i = 1:Core.Int64(Core.Int64(Base.length(tempArray)) - Core.Int64(1))
                        if Core.Int64(i) === Core.Int64(1)
                            writeDirectory = Base.string(tempArray[i]);
                        else
                            writeDirectory = Base.string(writeDirectory) * "\\" * Base.string(tempArray[i]);
                        end
                    end
                end
            else
                writeDirectory = "/";
            end
            # println(writeDirectory);
            AbsolutewriteDirectory::Core.String = "";
            if Base.string(writeDirectory)[begin] === '/' || Base.string(writeDirectory)[begin] === '\\'
                AbsolutewriteDirectory = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), writeDirectory[begin+1:end]));
            else
                AbsolutewriteDirectory = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), writeDirectory));
            end
            # println(AbsolutewriteDirectory);

            # 判斷目標寫入目錄是否存在，如果不存在則創建;
            # 使用 Julia 原生的基礎模組 Base 中的 Base.Filesystem 模塊中的 Base.Filesystem.ispath() 函數判斷指定的寫入目錄（文件夾）是否存在，如果不存在，則創建目錄，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
            # 同步判斷，使用 Julia 原生模組 Base.Filesystem.isdir(AbsolutewriteDirectory) 方法判斷是否為目錄（文件夾）;
            if !(Base.Filesystem.ispath(AbsolutewriteDirectory) && Base.Filesystem.isdir(AbsolutewriteDirectory))
                # 同步創建，創建指定的寫入目錄（文件夾）;
                try
                    # 同步遞歸創建目錄 Base.Filesystem.mkpath(path::AbstractString; mode::Unsigned=0o777)，返回值(return) path;
                    Base.Filesystem.mkpath(AbsolutewriteDirectory, mode=0o777);  # 同遞歸創建目錄，返回值(return) path;
                    # println("目錄: " * AbsolutewriteDirectory * " 創建成功.");
                catch err

                    println("指定的寫入目錄（文件夾）: " * AbsolutewriteDirectory * " 無法創建.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的寫入目錄（文件夾）: " * Base.string(writeDirectory) * " 無法創建.\n" * "path [ writeDirectory = " * Base.string(writeDirectory) * " ] mkpath fail.";
                    # response_body_Dict["error"] = "path [ writeDirectory = " * Base.string(writeDirectory) * " ] mkpath fail.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end
            end

            # 判斷指定的寫入目錄（文件夾）是否創建成功;
            if !(Base.Filesystem.ispath(AbsolutewriteDirectory) && Base.Filesystem.isdir(AbsolutewriteDirectory))

                println("指定的寫入目錄（文件夾） [ " * Base.string(AbsolutewriteDirectory) * " ] 無法被創建.");

                response_body_Dict["Server_say"] = "指定的寫入目錄（文件夾） [ " * Base.string(writeDirectory) * " ] 無法被創建.\n" * "path [ writeDirectory = " * Base.string(writeDirectory) * " ] mkpath fail.";
                response_body_Dict["error"] = "path [ writeDirectory = " * Base.string(writeDirectory) * " ] mkpath fail.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;

            elseif Base.stat(AbsolutewriteDirectory).mode !== Core.UInt64(16822) && Base.stat(AbsolutewriteDirectory).mode !== Core.UInt64(16895)

                # 十進制 16822 等於八進制 40666，十進制 16895 等於八進制 40777，修改文件夾權限，使用 Base.stat(AbsolutewriteDirectory) 函數讀取文檔信息，使用 Base.stat(AbsolutewriteDirectory).mode 方法提取文檔權限碼;
                # println("指定的寫入目錄（文件夾） [ " * AbsolutewriteDirectory * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                try
                    # 使用 Base.Filesystem.chmod(AbsolutewriteDirectory, mode=0o777; recursive=true) 函數修改文檔操作權限;
                    # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                    Base.Filesystem.chmod(AbsolutewriteDirectory, mode=0o777; recursive=true);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                    # println("目錄: " * AbsolutewriteDirectory * " 操作權限成功修改爲 mode=0o777 .");

                    # 八進制值    說明
                    # 0o400      所有者可讀
                    # 0o200      所有者可寫
                    # 0o100      所有者可執行或搜索
                    # 0o40       群組可讀
                    # 0o20       群組可寫
                    # 0o10       群組可執行或搜索
                    # 0o4        其他人可讀
                    # 0o2        其他人可寫
                    # 0o1        其他人可執行或搜索
                    # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                    # 數字	說明
                    # 7	可讀、可寫、可執行
                    # 6	可讀、可寫
                    # 5	可讀、可執行
                    # 4	唯讀
                    # 3	可寫、可執行
                    # 2	只寫
                    # 1	只可執行
                    # 0	沒有許可權
                    # 例如，八進制值 0o765 表示：
                    # 1) 、所有者可以讀取、寫入和執行該文檔；
                    # 2) 、群組可以讀和寫入該文檔；
                    # 3) 、其他人可以讀取和執行該文檔；
                    # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                    # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                catch err

                    println("指定的寫入目錄（文件夾）: " * Base.string(AbsolutewriteDirectory) * " 無法修改操作權限爲 mode=0o777 .");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "指定的寫入目錄（文件夾）: " * Base.string(writeDirectory) * " 無法修改操作權限爲 mode=0o777 .\n" * "path [ writeDirectory = " * Base.string(writeDirectory) * " ] change the permissions mode=0o777 fail.";
                    # response_body_Dict["error"] = "path [ writeDirectory = " * Base.string(writeDirectory) * " ] change the permissions mode=0o777 fail.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end
            else
            end

            # # 判斷文件夾權限;
            # if !(Base.stat(AbsolutewriteDirectory).mode === Core.UInt64(16822) || Base.stat(AbsolutewriteDirectory).mode === Core.UInt64(16895))
            #     # 十進制 16822 等於八進制 40666，十進制 16895 等於八進制 40777，修改文件夾權限，使用 Base.stat(AbsolutewriteDirectory) 函數讀取文檔信息，使用 Base.stat(AbsolutewriteDirectory).mode 方法提取文檔權限碼;
            #     println("指定的寫入目錄（文件夾）: " * AbsolutewriteDirectory * " 無法修改操作權限爲 mode=0o777 .");

            #     response_body_Dict["Server_say"] = "指定的寫入目錄（文件夾）: " * Base.string(writeDirectory) * " 無法修改操作權限爲 mode=0o777 .\n" * "path [ writeDirectory = " * Base.string(writeDirectory) * " ] change the permissions mode=0o777 fail.";
            #     response_body_Dict["error"] = "path [ writeDirectory = " * Base.string(writeDirectory) * " ] change the permissions mode=0o777 fail.";

            #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            #     # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #     # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            #     response_body_String = JSONstring(response_body_Dict);
            #     # println(response_body_String);
            #     # Base.exit(0);
            #     return response_body_String;
            # end
        end

        # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
        # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
        # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
        # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
        # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
        # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
        # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
        # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
        # Base.ismarked(io);  # Return true if stream s is marked;
        # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
        # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
        # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
        # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
        # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
        # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
        # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
        # Base.close(io);  # 關閉緩衝區;
        # println(a)
        # Base.redirect_stdout — Function
        # redirect_stdout([stream]) -> (rd, wr)
        # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
        # If called with the optional stream argument, then returns stream itself.
        # Base.redirect_stdout — Method
        # redirect_stdout(f::Function, stream)
        # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
        # Base.redirect_stderr — Function
        # redirect_stderr([stream]) -> (rd, wr)
        # Like redirect_stdout, but for stderr.
        # Base.redirect_stderr — Method
        # redirect_stderr(f::Function, stream)
        # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
        # Base.redirect_stdin — Function
        # redirect_stdin([stream]) -> (rd, wr)
        # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
        # Base.redirect_stdin — Method
        # redirect_stdin(f::Function, stream)
        # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

        # 同步創建一個空的文檔;
        # Base.Filesystem.touch — Function
        # touch(path::AbstractString)
        # Update the last-modified timestamp on a file to the current time. Return path.
        output_file_path = Base.Filesystem.touch(web_path);  # 創建一個空文檔;
        if !(Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path))
            println("文檔: " * web_path * " 無法創建.");

            response_body_Dict["Server_say"] = "文檔: " * "/" * Base.string(fileName) * " 無法創建.";
            # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 無法創建.";
            response_body_Dict["error"] = "document [ file = " * "/" * Base.string(fileName) * " ] not create.";
            # response_body_Dict["error"] = "document [ file = " * Base.string(web_path) * " ] not create.";

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            # Base.exit(0);
            return response_body_String;
        elseif Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
            # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
            println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
            try
                # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
                # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                # 八進制值    說明
                # 0o400      所有者可讀
                # 0o200      所有者可寫
                # 0o100      所有者可執行或搜索
                # 0o40       群組可讀
                # 0o20       群組可寫
                # 0o10       群組可執行或搜索
                # 0o4        其他人可讀
                # 0o2        其他人可寫
                # 0o1        其他人可執行或搜索
                # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                # 數字	說明
                # 7	可讀、可寫、可執行
                # 6	可讀、可寫
                # 5	可讀、可執行
                # 4	唯讀
                # 3	可寫、可執行
                # 2	只寫
                # 1	只可執行
                # 0	沒有許可權
                # 例如，八進制值 0o765 表示：
                # 1) 、所有者可以讀取、寫入和執行該文檔；
                # 2) 、群組可以讀和寫入該文檔；
                # 3) 、其他人可以讀取和執行該文檔；
                # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

            catch err
                println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                println(err);
                # println(err.msg);
                # println(Base.typeof(err));

                response_body_Dict["Server_say"] = "文檔: " * "/" * Base.string(fileName) * " 無法修改操作權限爲 mode=0o777 .";  # "document [ file = " * "/" * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 無法修改操作權限爲 mode=0o777 .";  # "document [ file = " * Base.string(web_path) * " ] change the permissions mode=0o777 fail.";
                response_body_Dict["error"] = Base.string(err);

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end
        else
        end

        # 同步寫入文檔中的數據;
        fWIO = Core.nothing;  # ::IOStream;
        try
            # numBytes = Base.write(fWIO, file_data_UInt8Array);  # Base.write(io::IO, x) 一次全部寫入緩衝中的數據到指定文檔中，二進制字節數據，返回值為寫入的字節數;
            # numBytes = write(web_path, file_data);  # 一次全部寫入字符串數據到指定文檔中，字符串類型 "utf-8"，返回值為寫入的字節數;
            # # write(filename::AbstractString, x)
            # # Write the canonical binary representation of a value to the given I/O stream or file. Return the number of bytes written into the stream. See also print to write a text representation (with an encoding that may depend upon io).
            # # You can write multiple values with the same write call. i.e. the following are equivalent:
            # println(numBytes);
            # println(Base.stat(web_path).size);
            # println(Base.stat(web_path).mtime);
            # # println(Dates.now());  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
            # println(Base.stat(web_path).ctime);
            # # Base.displaysize([io::IO]) -> (lines, columns)
            # # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
            # # Base.countlines — Function
            # # Base.countlines(io::IO; eol::AbstractChar = '\n')
            # # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.
            # println(Base.countlines(web_path, eol='\\n'));


            # 在 Base.open() 函數中，還可以調用函數;
            # Base.open(Base.readline, "sdy.txt");
            # 也可以調用自定義函數;
            # readFunc(s::IOStream) = Base.read(s, Char);
            # Base.open(readFunc, "sdy.txt");
            # 還可以像Python中的 with open...as 的用法一樣打開文件;
            # Base.open("sdy.txt","r") do stream
            #     for line in eachline(stream)
            #         println(line);
            #     end
            # end
            # 也可以將上述程序定義成函數再用open操作;
            # function readFunc2(stream)
            #     for line in eachline(stream)
            #         println(line);
            #     end
            # end
            # Base.open(readFunc2, "sdy.txt");

            fWIO = Base.open(web_path, "w");
            # nb = countlines(fWIO);  # 計算文檔中數據行數;
            # seekstart(fWIO);  # 指針返回文檔的起始位置;

            # Keyword	Description				Default
            # read		open for reading		!write
            # write		open for writing		truncate | append
            # create	create if non-existent	!read & write | truncate | append
            # truncate	truncate to zero size	!read & write
            # append	seek to end				false

            # Mode	Description						Keywords
            # r		read							none
            # w		write, create, truncate			write = true
            # a		write, create, append			append = true
            # r+	read, write						read = true, write = true
            # w+	read, write, create, truncate	truncate = true, read = true
            # a+	read, write, create, append		append = true, read = true

            # 使用 iswritable(io) 函數判斷文檔是否可寫;
            if Base.iswritable(fWIO)

                # numBytes = Base.write(fWIO, file_data);  # Base.write(io::IO, x) 一次全部寫入緩衝中的數據到指定文檔中，字符串類型 "utf-8"，返回值為寫入的字節數;
                numBytes = Base.write(fWIO, file_data_UInt8Array);  # Base.write(io::IO, x) 一次全部寫入緩衝中的數據到指定文檔中，二進制字節數據，返回值為寫入的字節數;
                Base.flush(fWIO);  # 將當前寫入操作的緩衝區所有數據都提交給傳出傳入流;
                # println(numBytes);
                # println(Base.stat(web_path).size);
                # println(Base.stat(web_path).mtime);
                # println(Dates.now());  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
                # println(Base.stat(web_path).ctime);
                # Base.displaysize([io::IO]) -> (lines, columns)
                # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                # Base.countlines — Function
                # Base.countlines(io::IO; eol::AbstractChar = '\n')
                # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.
                # println(Base.countlines(web_path, eol='\n'));

                response_body_Dict["Server_say"] = "向文檔: " * Base.string(fileName) * " 中寫入 " * Base.string(numBytes) * " 字節(Bytes)數據.";  # "Write file ( " * Base.string(web_path) * " ) " * Base.string(numBytes) * " Bytes data.";
                # response_body_Dict["Server_say"] = "向文檔: " * Base.string(web_path) * " 中寫入 " * Base.string(numBytes) * " 字節(Bytes)數據.";  # "Write file ( " * Base.string(web_path) * " ) " * Base.string(numBytes) * " Bytes data.";
                response_body_Dict["error"] = "";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                # return response_body_String;
            else
                println("無法向文檔: " * Base.string(web_path) * " 寫入數據.");
                response_body_Dict["Server_say"] = "無法向文檔: " * Base.string(fileName) * " 寫入數據.";
                response_body_Dict["error"] = "file ( " * Base.string(fileName) * " ) unable to write.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end

            # io = Base.IOBuffer("JuliaLang is a GitHub organization");
            # Base.IOStream();  # 包裝 OS 文檔描述符的緩衝 I/O 流。主要用於表示 open 返回的文檔;
            # A buffered IO stream wrapping an OS file descriptor. Mostly used to represent files returned by open.
            # Base.write — Function
            # write(io::IO, x)
            # write(filename::AbstractString, x)
            # Write the canonical binary representation of a value to the given I/O stream or file. Return the number of bytes written into the stream. See also print to write a text representation (with an encoding that may depend upon io).
            # You can write multiple values with the same write call. i.e. the following are equivalent:
            # write(io, x, y...)
            # write(io, x) + write(io, y...)

            # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
            # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
            # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
            # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
            # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
            # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
            # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
            # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
            # Base.ismarked(io);  # Return true if stream s is marked;
            # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
            # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
            # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
            # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
            # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
            # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
            # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
            # Base.close(io);  # 關閉緩衝區;
            # println(a)
            # Base.redirect_stdout — Function
            # redirect_stdout([stream]) -> (rd, wr)
            # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
            # If called with the optional stream argument, then returns stream itself.
            # Base.redirect_stdout — Method
            # redirect_stdout(f::Function, stream)
            # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
            # Base.redirect_stderr — Function
            # redirect_stderr([stream]) -> (rd, wr)
            # Like redirect_stdout, but for stderr.
            # Base.redirect_stderr — Method
            # redirect_stderr(f::Function, stream)
            # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
            # Base.redirect_stdin — Function
            # redirect_stdin([stream]) -> (rd, wr)
            # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
            # Base.redirect_stdin — Method
            # redirect_stdin(f::Function, stream)
            # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

        catch err

            if Core.isa(err, Core.InterruptException)

                print("\n");
                # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                println("[ Ctrl ] + [ c ] received, will be return Function.");

                # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                response_body_Dict["error"] = Base.string(err);

            else

                println("向文檔: " * web_path * " 中寫入數據發生錯誤.");
                println(err);
                # println(err.msg);
                # println(Base.typeof(err));

                response_body_Dict["Server_say"] = "向文檔: " * "/" * Base.string(fileName) * " 中寫入數據發生錯誤.";  # "document [ file = " * Base.string(web_path) * " ] not write."
                # response_body_Dict["Server_say"] = "向文檔: " * Base.string(fileName) * " 中寫入數據發生錯誤.";  # "document [ file = " * Base.string(web_path) * " ] not write."
                response_body_Dict["error"] = Base.string(err);

            end

            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            # Base.exit(0);
            return response_body_String;

        finally
            # Base.flush(fWIO);  # 將當前寫入操作的緩衝區所有數據都提交給傳出傳入流;
            # # 使用 Base.eof() 函數判斷是否已經寫到最後一個位置;
            # if Base.eof(fWIO)
            #     Base.close(fWIO);  # Close an I/O stream. Performs a flush first;
            # end
            Base.close(fWIO);  # Close an I/O stream. Performs a flush first;
        end

        # response_body_String = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
        fWIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
        # Base.GC.gc();  # 内存回收函數 gc();

        return response_body_String;

    elseif request_Path === "/deleteFile"
        # 客戶端或瀏覽器請求 url = http://localhost:10001/deleteFile?Key=username:password&algorithmUser=username&algorithmPass=password&fileName=JuliaServer.jl

        if fileName === ""
            println("Upload file name empty { " * fileName * " }.");
            response_body_Dict["Server_say"] = "上傳參數錯誤，目標替換文檔名稱字符串 file name = { " * Base.string(fileName) * " } 爲空.";
            response_body_Dict["error"] = "File name = { " * Base.string(fileName) * " } empty.";
            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        if fileName !== ""

            web_path = "";
            if Base.string(fileName)[begin] === '/' || Base.string(fileName)[begin] === '\\'
                web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(Base.string(fileName)[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(fileName)));  # 拼接本地當前目錄下的請求文檔名;
            else
                web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(fileName)));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(fileName)));  # 拼接本地當前目錄下的請求文檔名;
            end
            file_data = Base.string(request_POST_String);

            # 使用 Julia 原生的基礎模組 Base 中的 Base.Filesystem 模塊中的 Base.Filesystem.ispath() 函數判斷指定的文檔是否存在，如果存在則判斷操作權限，並為所有者和組用戶提供讀、寫、執行權限，默認模式為 0o777;
            if Base.Filesystem.ispath(webPath) && Base.Filesystem.isfile(web_path)

                # # 檢查待刪除文檔的操作權限;
                # if Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
                #     # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
                #     # println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                #     try
                #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
                #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                #         # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                #         # 八進制值    說明
                #         # 0o400      所有者可讀
                #         # 0o200      所有者可寫
                #         # 0o100      所有者可執行或搜索
                #         # 0o40       群組可讀
                #         # 0o20       群組可寫
                #         # 0o10       群組可執行或搜索
                #         # 0o4        其他人可讀
                #         # 0o2        其他人可寫
                #         # 0o1        其他人可執行或搜索
                #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                #         # 數字	說明
                #         # 7	可讀、可寫、可執行
                #         # 6	可讀、可寫
                #         # 5	可讀、可執行
                #         # 4	唯讀
                #         # 3	可寫、可執行
                #         # 2	只寫
                #         # 1	只可執行
                #         # 0	沒有許可權
                #         # 例如，八進制值 0o765 表示：
                #         # 1) 、所有者可以讀取、寫入和執行該文檔；
                #         # 2) 、群組可以讀和寫入該文檔；
                #         # 3) 、其他人可以讀取和執行該文檔；
                #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                #     catch err
                #         println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                #         println(err);
                #         # println(err.msg);
                #         # println(Base.typeof(err));

                #         response_body_Dict["Server_say"] = "文檔 [ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         # response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         response_body_Dict["error"] = Base.string(err);

                #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #         # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #         # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #         response_body_String = JSONstring(response_body_Dict);
                #         # println(response_body_String);
                #         # Base.exit(0);
                #         return response_body_String;
                #     end
                # end

                # 同步刪除，已經存在的文檔，重新創建;
                try
                    # Base.Filesystem.rm(path::AbstractString; force::Bool=false, recursive::Bool=false)
                    # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                    Base.Filesystem.rm(web_path, force=true, recursive=false);  # 刪除給定路徑下的文檔、鏈接或空目錄，如果傳遞參數 force=true 時，則不存在的路徑不被視爲錯誤，如果傳遞參數 recursive=true 并且路徑是目錄時，則遞歸刪除所有内容;
                    # Base.Filesystem.rm(path::AbstractString, force::Bool=false, recursive::Bool=false)
                    # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                    # println("文檔: " * web_path * " 已被刪除.");
                catch err
                    println("文檔: " * web_path * " 無法刪除.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "文檔: " * Base.string(fileName) * " 無法刪除.";  # "document file = [ " * Base.string(fileName) * " ] not delete.";
                    # response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] not delete.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # Base.sleep(time_sleep);  # 程序休眠，單位為秒，0.02;
                # # Base.sleep(seconds)  Block the current task for a specified number of seconds. The minimum sleep time is 1 millisecond or input of 0.001.

                # # 判斷文檔是否已經從硬盤刪除;
                # if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)
                #     println("文檔: " * web_path * " 無法刪除.");

                #     response_body_Dict["Server_say"] = "文檔: " * Base.string(fileName) * " 無法被刪除.";  # "document file = [ " * Base.string(fileName) * " ] not delete.";
                #     response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] not delete.";

                #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #     # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #     # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_body_String = JSONstring(response_body_Dict);
                #     # println(response_body_String);
                #     # Base.exit(0);
                #     return response_body_String;
                # end
            elseif Base.Filesystem.ispath(webPath) && Base.Filesystem.isdir(web_path)

                # # 檢查待刪除目錄（文件夾）操作權限;
                # if Base.stat(web_path).mode !== Core.UInt64(16822) && Base.stat(web_path).mode !== Core.UInt64(16895)
                #     # 十進制 16822 等於八進制 40666，十進制 16895 等於八進制 40777，修改文件夾權限，使用 Base.stat(monitor_dir) 函數讀取文檔信息，使用 Base.stat(monitor_dir).mode 方法提取文檔權限碼;
                #     # println("文件夾 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                #     try
                #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文件夾操作權限;
                #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=true);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                #         # println("文件夾: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                #         # 八進制值    說明
                #         # 0o400      所有者可讀
                #         # 0o200      所有者可寫
                #         # 0o100      所有者可執行或搜索
                #         # 0o40       群組可讀
                #         # 0o20       群組可寫
                #         # 0o10       群組可執行或搜索
                #         # 0o4        其他人可讀
                #         # 0o2        其他人可寫
                #         # 0o1        其他人可執行或搜索
                #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                #         # 數字	說明
                #         # 7	可讀、可寫、可執行
                #         # 6	可讀、可寫
                #         # 5	可讀、可執行
                #         # 4	唯讀
                #         # 3	可寫、可執行
                #         # 2	只寫
                #         # 1	只可執行
                #         # 0	沒有許可權
                #         # 例如，八進制值 0o765 表示：
                #         # 1) 、所有者可以讀取、寫入和執行該文檔；
                #         # 2) 、群組可以讀和寫入該文檔；
                #         # 3) 、其他人可以讀取和執行該文檔；
                #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                #     catch err
                #         println("目錄（文件夾）: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                #         println(err);
                #         # println(err.msg);
                #         # println(Base.typeof(err));

                #         response_body_Dict["Server_say"] = "目錄（文件夾）：[ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "directory = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         # response_body_Dict["error"] = "directory = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         response_body_Dict["error"] = Base.string(err);

                #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #         # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #         # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #         response_body_String = JSONstring(response_body_Dict);
                #         # println(response_body_String);
                #         # Base.exit(0);
                #         return response_body_String;
                #     end
                # end

                # 同步刪除，已經存在的文檔，重新創建;
                try
                    # Base.Filesystem.rm(path::AbstractString; force::Bool=false, recursive::Bool=false)
                    # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                    Base.Filesystem.rm(web_path, force=true, recursive=true);  # 刪除給定路徑下的文檔、鏈接或空目錄，如果傳遞參數 force=true 時，則不存在的路徑不被視爲錯誤，如果傳遞參數 recursive=true 并且路徑是目錄時，則遞歸刪除所有内容;
                    # Base.Filesystem.rm(path::AbstractString, force::Bool=false, recursive::Bool=false)
                    # Delete the file, link, or empty directory at the given path. If force=true is passed, a non-existing path is not treated as error. If recursive=true is passed and the path is a directory, then all contents are removed recursively.
                    # println("目錄（文件夾）: " * web_path * " 已被刪除.");
                catch err
                    println("目錄（文件夾）: " * web_path * " 無法刪除.");
                    println(err);
                    # println(err.msg);
                    # println(Base.typeof(err));

                    response_body_Dict["Server_say"] = "目錄（文件夾）: " * Base.string(fileName) * " 無法刪除.";  # "directory = [ " * Base.string(fileName) * " ] not delete.";
                    # response_body_Dict["error"] = "directory = [ " * Base.string(fileName) * " ] not delete.";
                    response_body_Dict["error"] = Base.string(err);

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;
                end

                # Base.sleep(time_sleep);  # 程序休眠，單位為秒，0.02;
                # # Base.sleep(seconds)  Block the current task for a specified number of seconds. The minimum sleep time is 1 millisecond or input of 0.001.

                # # 判斷目錄（文件夾）是否已經從硬盤刪除;
                # if Base.Filesystem.ispath(web_path) && Base.Filesystem.isdir(web_path)
                #     println("目錄（文件夾）: " * web_path * " 無法被刪除.");

                #     response_body_Dict["Server_say"] = "目錄（文件夾）: " * Base.string(fileName) * " 無法被刪除.";  # "directory = [ " * Base.string(fileName) * " ] not delete.";
                #     response_body_Dict["error"] = "directory = [ " * Base.string(fileName) * " ] not delete.";

                #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #     # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #     # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #     response_body_String = JSONstring(response_body_Dict);
                #     # println(response_body_String);
                #     # Base.exit(0);
                #     return response_body_String;
                # end
            else

                println("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " * Base.string(web_path) * " } 無法識別.");
                # response_body_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " * Base.string(web_path) * " } 無法識別.";
                response_body_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " * Base.string(fileName) * " } 無法識別.";
                # response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";
                response_body_Dict["error"] = "file = { " * Base.string(fileName) * " } unrecognized.";
                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                return response_body_String;
            end
        end

        # web_path_index_Html = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "index.html"));
        # # web_path_index_Html::Core.String = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "index.html"));
        # # file_data = Base.string(request_POST_String);
        # # web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/index.html" 字符串首的斜杠 '/' 字符;
        # println(fileName);
        # # 截取當前所在目錄（文件夾）;
        # currentDirectory::Core.String = "";
        # if Base.isa(fileName, Core.String) && Base.occursin('/', fileName)
        #     tempArray = Core.Array{Core.String, 1}();
        #     tempArray = Base.split(fileName, '/');
        #     if Core.Int64(Base.length(tempArray)) <= Core.Int64(2)
        #         currentDirectory = "/";
        #     else
        #         for i = 1:Core.Int64(Core.Int64(Base.length(tempArray)) - Core.Int64(1))
        #             if Core.Int64(i) === Core.Int64(1)
        #                 currentDirectory = Base.string(tempArray[i]);
        #             else
        #                 currentDirectory = Base.string(currentDirectory) * "/" * Base.string(tempArray[i]);
        #             end
        #         end
        #     end
        # else
        #     currentDirectory = "/";
        # end
        # # println(currentDirectory);
        # if Base.string(currentDirectory)[begin] === '/' || Base.string(currentDirectory)[begin] === '\\'
        #     web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), currentDirectory[begin+1:end]));
        # else
        #     web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), currentDirectory));
        # end
        # # println(web_path);

        # # 讀取服務器返回的響應值文檔字符串;
        # if Base.Filesystem.ispath(web_path) && Base.Filesystem.isdir(web_path)

        #     directoryHTML = "<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>";

        #     # 同步讀取指定硬盤文件夾（當前所處目錄文件夾）下包含的内容名稱清單，返回字符串數組;
        #     dir_list_Arror = Base.Filesystem.readdir(web_path);  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
        #     # Base.length(Base.Filesystem.readdir(web_path));
        #     # if Base.length(dir_list_Arror) > 0
        #         for item in dir_list_Arror

        #             name_href_url_string = "";
        #             delete_href_url_string = "";
        #             if currentDirectory === "/"
        #                 name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(currentDirectory, item), "?fileName=", Base.string(currentDirectory, item), "&Key=", Base.string(key), "#");
        #                 delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(currentDirectory, item), "&Key=", Base.string(key), "#");
        #             else
        #                 name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(currentDirectory, "/", item), "?fileName=", Base.string(currentDirectory, "/", item), "&Key=", Base.string(key), "#");
        #                 delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(currentDirectory, "/", item), "&Key=", Base.string(key), "#");
        #             end
        #             downloadFile_href_string = """fileDownload('post', 'UpLoadData', '$(Base.string(name_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '$(Base.string(item))', function(error, response){})""";
        #             deleteFile_href_string = """deleteFile('post', 'UpLoadData', '$(Base.string(delete_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})""";

        #             statsObj = Base.stat(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))));

        #             if Base.Filesystem.isfile(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))))
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Float64(statsObj.size) / Core.Float64(1024.0)), " KiloBytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
        #                 directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
        #                 # directoryHTML = directoryHTML * """<tr><td><a onclick="$(downloadFile_href_string)" href="javascript:void(0)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a onclick="$(deleteFile_href_string)" href="javascript:void(0)">刪除</a></td></tr>""";
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>""";
        #             elseif Base.Filesystem.isdir(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))))
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td></td><td></td></tr>""";
        #                 directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td></td><td></td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
        #                 # directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="$(delete_href_url_string)">刪除</a></td></tr>""";
        #             else
        #             end

        #         end
        #     # end

        #     # 同步讀取硬盤 .html 文檔，返回字符串;
        #     if Base.Filesystem.ispath(web_path_index_Html) && Base.Filesystem.isfile(web_path_index_Html)

        #         fRIO = Core.nothing;  # ::IOStream;
        #         try
        #             # line = Base.Filesystem.readlink(web_path_index_Html);  # 讀取文檔中的一行數據;
        #             # Base.readlines — Function
        #             # Base.readlines(io::IO=stdin; keep::Bool=false)
        #             # Base.readlines(filename::AbstractString; keep::Bool=false)
        #             # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
        #             # for line in eachline(web_path_index_Html)
        #             #     print(line);
        #             # end
        #             # Base.displaysize([io::IO]) -> (lines, columns)
        #             # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
        #             # Base.countlines — Function
        #             # Base.countlines(io::IO; eol::AbstractChar = '\n')
        #             # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

        #             # 在 Base.open() 函數中，還可以調用函數;
        #             # Base.open(Base.readline, "sdy.txt");
        #             # 也可以調用自定義函數;
        #             # readFunc(s::IOStream) = Base.read(s, Char);
        #             # Base.open(readFunc, "sdy.txt");
        #             # 還可以像Python中的 with open...as 的用法一樣打開文件;
        #             # Base.open("sdy.txt","r") do stream
        #             #     for line in eachline(stream)
        #             #         println(line);
        #             #     end
        #             # end
        #             # 也可以將上述程序定義成函數再用open操作;
        #             # function readFunc2(stream)
        #             #     for line in eachline(stream)
        #             #         println(line);
        #             #     end
        #             # end
        #             # Base.open(readFunc2, "sdy.txt");

        #             fRIO = Base.open(web_path_index_Html, "r");
        #             # nb = countlines(fRIO);  # 計算文檔中數據行數;
        #             # seekstart(fRIO);  # 指針返回文檔的起始位置;

        #             # Keyword	Description				Default
        #             # read		open for reading		!write
        #             # write		open for writing		truncate | append
        #             # create	create if non-existent	!read & write | truncate | append
        #             # truncate	truncate to zero size	!read & write
        #             # append	seek to end				false

        #             # Mode	Description						Keywords
        #             # r		read							none
        #             # w		write, create, truncate			write = true
        #             # a		write, create, append			append = true
        #             # r+	read, write						read = true, write = true
        #             # w+	read, write, create, truncate	truncate = true, read = true
        #             # a+	read, write, create, append		append = true, read = true

        #             # io = Base.IOBuffer("JuliaLang is a GitHub organization");
        #             # Base.read(io, Core.String);
        #             # "JuliaLang is a GitHub organization";
        #             # Base.read(filename::AbstractString, Core.String);
        #             # Read the entire contents of a file as a string.
        #             # Base.read(s::IOStream, nb::Integer; all=true);
        #             # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
        #             # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
        #             # Base.read(command::Cmd)
        #             # Run command and return the resulting output as an array of bytes.
        #             # Base.read(command::Cmd, Core.String)
        #             # Run command and return the resulting output as a String.
        #             # Base.read!(stream::IO, array::Union{Array, BitArray})
        #             # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
        #             # Read binary data from an I/O stream or file, filling in array.
        #             # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
        #             # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
        #             # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
        #             # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
        #             # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

        #             # 使用 isreadable(io) 函數判斷文檔是否可讀;
        #             if Base.isreadable(fRIO)
        #                 # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
        #                 file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
        #             else
        #                 response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path_index_Html) * " 無法讀取數據.";
        #                 response_body_Dict["error"] = "File ( " * Base.string(web_path_index_Html) * " ) unable to read.";

        #                 # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #                 # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #                 # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #                 # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #                 # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #                 # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #                 response_body_String = JSONstring(response_body_Dict);
        #                 # println(response_body_String);
        #                 # Base.exit(0);
        #                 return response_body_String;
        #             end

        #             # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
        #             # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
        #             # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
        #             # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
        #             # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
        #             # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
        #             # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
        #             # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
        #             # Base.ismarked(io);  # Return true if stream s is marked;
        #             # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
        #             # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
        #             # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
        #             # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
        #             # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
        #             # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
        #             # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
        #             # Base.close(io);  # 關閉緩衝區;
        #             # println(a)
        #             # Base.redirect_stdout — Function
        #             # redirect_stdout([stream]) -> (rd, wr)
        #             # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
        #             # If called with the optional stream argument, then returns stream itself.
        #             # Base.redirect_stdout — Method
        #             # redirect_stdout(f::Function, stream)
        #             # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
        #             # Base.redirect_stderr — Function
        #             # redirect_stderr([stream]) -> (rd, wr)
        #             # Like redirect_stdout, but for stderr.
        #             # Base.redirect_stderr — Method
        #             # redirect_stderr(f::Function, stream)
        #             # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
        #             # Base.redirect_stdin — Function
        #             # redirect_stdin([stream]) -> (rd, wr)
        #             # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
        #             # Base.redirect_stdin — Method
        #             # redirect_stdin(f::Function, stream)
        #             # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

        #         catch err

        #             if Core.isa(err, Core.InterruptException)

        #                 print("\n");
        #                 # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
        #                 # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
        #                 println("[ Ctrl ] + [ c ] received, will be return Function.");

        #                 # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
        #                 # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

        #                 response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
        #                 response_body_Dict["error"] = Base.string(err);

        #             else

        #                 println("指定的文檔: " * web_path_index_Html * " 無法讀取.");
        #                 println(err);
        #                 # println(err.msg);
        #                 # println(Base.typeof(err));

        #                 response_body_Dict["Server_say"] = "指定的文檔: " * Base.string(web_path_index_Html) * " 無法讀取.";
        #                 response_body_Dict["error"] = Base.string(err);
        #             end

        #             # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #             # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #             # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #             # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #             # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #             # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #             response_body_String = JSONstring(response_body_Dict);
        #             # println(response_body_String);
        #             # Base.exit(0);
        #             return response_body_String;

        #         finally
        #             Base.close(fRIO);
        #         end

        #         fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
        #         # Base.GC.gc();  # 内存回收函數 gc();

        #     else

        #         response_body_Dict["Server_say"] = "請求文檔: " * Base.string(web_path_index_Html) * " 無法識別.";
        #         response_body_Dict["error"] = "File = { " * Base.string(web_path_index_Html) * " } unrecognized.";

        #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #         # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #         # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #         response_body_String = JSONstring(response_body_Dict);
        #         # println(response_body_String);
        #         return response_body_String;
        #     end
        #     # 替換 .html 文檔中指定的位置字符串;
        #     if file_data !== ""
        #         response_body_String = Base.string(Base.replace(file_data, "<!-- directoryHTML -->" => directoryHTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
        #     else
        #         response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path_index_Html) * " 爲空.";
        #         response_body_Dict["error"] = "File ( " * Base.string(web_path_index_Html) * " ) empty.";

        #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #         # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #         # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #         response_body_String = JSONstring(response_body_Dict);
        #         # println(response_body_String);
        #         # Base.exit(0);
        #         return response_body_String;
        #     end
        #     # println(response_body_String);

        #     return response_body_String;

        # else

        #     # response_body_Dict["Server_say"] = "目錄（文件夾）: " * Base.string(web_path) * " 無法識別.";
        #     response_body_Dict["Server_say"] = "目錄（文件夾）: " * Base.string(currentDirectory) * " 無法識別.";
        #     response_body_Dict["error"] = "directory = { " * Base.string(currentDirectory) * " } unrecognized.";

        #     # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
        #     # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #     # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
        #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
        #     # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
        #     response_body_String = JSONstring(response_body_Dict);
        #     # println(response_body_String);
        #     return response_body_String;
        # end

        return response_body_String;

    else

        web_path = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), Base.string(request_Path[begin+1:end])));  # Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath("."), Base.string(request_Path)));  # 拼接本地當前目錄下的請求文檔名，request_Path[begin+1:end] 表示刪除 "/administrator.html" 字符串首的斜杠 '/' 字符;
        # web_path_index_Html::Core.String = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "administrator.html"));
        web_path_index_Html = Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(webPath), "administrator.html"));
        file_data = "";

        if Base.Filesystem.ispath(webPath) && Base.Filesystem.isfile(web_path)

            # # 檢查待讀取文檔的操作權限;
            # if Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
            #     # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
            #     # println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
            #     try
            #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
            #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
            #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
            #         # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

            #         # 八進制值    說明
            #         # 0o400      所有者可讀
            #         # 0o200      所有者可寫
            #         # 0o100      所有者可執行或搜索
            #         # 0o40       群組可讀
            #         # 0o20       群組可寫
            #         # 0o10       群組可執行或搜索
            #         # 0o4        其他人可讀
            #         # 0o2        其他人可寫
            #         # 0o1        其他人可執行或搜索
            #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
            #         # 數字	說明
            #         # 7	可讀、可寫、可執行
            #         # 6	可讀、可寫
            #         # 5	可讀、可執行
            #         # 4	唯讀
            #         # 3	可寫、可執行
            #         # 2	只寫
            #         # 1	只可執行
            #         # 0	沒有許可權
            #         # 例如，八進制值 0o765 表示：
            #         # 1) 、所有者可以讀取、寫入和執行該文檔；
            #         # 2) 、群組可以讀和寫入該文檔；
            #         # 3) 、其他人可以讀取和執行該文檔；
            #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
            #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

            #     catch err
            #         println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
            #         println(err);
            #         # println(err.msg);
            #         # println(Base.typeof(err));

            #         response_body_Dict["Server_say"] = "文檔 [ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
            #         # response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
            #         response_body_Dict["error"] = Base.string(err);

            #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            #         # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #         # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_body_String = JSONstring(response_body_Dict);
            #         # println(response_body_String);
            #         # Base.exit(0);
            #         return response_body_String;
            #     end
            # end

            # 同步讀取硬盤文檔，返回字符串;
            if Base.Filesystem.ispath(web_path) && Base.Filesystem.isfile(web_path)

                # # 檢查待讀取文檔的操作權限;
                # if Base.stat(web_path).mode !== Core.UInt64(33206) && Base.stat(web_path).mode !== Core.UInt64(33279)
                #     # 十進制 33206 等於八進制 100666，十進制 33279 等於八進制 100777，修改文件夾權限，使用 Base.stat(web_path) 函數讀取文檔信息，使用 Base.stat(web_path).mode 方法提取文檔權限碼;
                #     # println("文檔 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
                #     try
                #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文檔操作權限;
                #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
                #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=false);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
                #         # println("文檔: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

                #         # 八進制值    說明
                #         # 0o400      所有者可讀
                #         # 0o200      所有者可寫
                #         # 0o100      所有者可執行或搜索
                #         # 0o40       群組可讀
                #         # 0o20       群組可寫
                #         # 0o10       群組可執行或搜索
                #         # 0o4        其他人可讀
                #         # 0o2        其他人可寫
                #         # 0o1        其他人可執行或搜索
                #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
                #         # 數字	說明
                #         # 7	可讀、可寫、可執行
                #         # 6	可讀、可寫
                #         # 5	可讀、可執行
                #         # 4	唯讀
                #         # 3	可寫、可執行
                #         # 2	只寫
                #         # 1	只可執行
                #         # 0	沒有許可權
                #         # 例如，八進制值 0o765 表示：
                #         # 1) 、所有者可以讀取、寫入和執行該文檔；
                #         # 2) 、群組可以讀和寫入該文檔；
                #         # 3) 、其他人可以讀取和執行該文檔；
                #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
                #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

                #     catch err
                #         println("文檔: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
                #         println(err);
                #         # println(err.msg);
                #         # println(Base.typeof(err));

                #         response_body_Dict["Server_say"] = "文檔 [ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         # response_body_Dict["error"] = "document file = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
                #         response_body_Dict["error"] = Base.string(err);

                #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                #         # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #         # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                #         response_body_String = JSONstring(response_body_Dict);
                #         # println(response_body_String);
                #         # Base.exit(0);
                #         return response_body_String;
                #     end
                # end

                # 獲取待讀取文檔的大小，單位：字節（Bytes），1 字節（Bytes） = 8 比特（bits），1 比特（bits）即 1 個二進制位，一個英文字母占用 1 個字節，一個漢字符占用 2 個字節;
                # file_size = Core.Int64(Core.Int64(Base.stat(web_path).size) * Core.Int64(8));  # 查看文檔大小，單位：字節（Bytes），1 字節（Bytes） = 8 比特（bits），1 比特（bits）即 1 個二進制位，一個英文字母占用 1 個字節，一個漢字符占用 2 個字節，乘以 8 表示轉換爲二進制比特（bits）數;
                # Base.ceil() 函數表示向上取整，Base.cld(x1, x2) 函數表示向上取整除法 x1 ÷ x2;
                file_size = Core.Int64(Base.stat(web_path).size);
                # println(file_size);

                # fRIO = Core.nothing;  # ::IOStream;
                try
                    # line = Base.Filesystem.readlink(web_path);  # 讀取文檔中的一行數據;
                    # Base.readlines — Function
                    # Base.readlines(io::IO=stdin; keep::Bool=false)
                    # Base.readlines(filename::AbstractString; keep::Bool=false)
                    # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                    # for line in eachline(web_path)
                    #     print(line);
                    # end
                    # Base.displaysize([io::IO]) -> (lines, columns)
                    # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                    # Base.countlines — Function
                    # Base.countlines(io::IO; eol::AbstractChar = '\n')
                    # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                    # 在 Base.open() 函數中，還可以調用函數;
                    # Base.open(Base.readline, "sdy.txt");
                    # 也可以調用自定義函數;
                    # readFunc(s::IOStream) = Base.read(s, Char);
                    # Base.open(readFunc, "sdy.txt");
                    # 還可以像Python中的 with open...as 的用法一樣打開文件;
                    # Base.open("sdy.txt","r") do stream
                    #     for line in eachline(stream)
                    #         println(line);
                    #     end
                    # end
                    # 也可以將上述程序定義成函數再用open操作;
                    # function readFunc2(stream)
                    #     for line in eachline(stream)
                    #         println(line);
                    #     end
                    # end
                    # Base.open(readFunc2, "sdy.txt");

                    fRIO = Base.open(web_path, "r");
                    # nb = countlines(fRIO);  # 計算文檔中數據行數;
                    # seekstart(fRIO);  # 指針返回文檔的起始位置;

                    # Keyword	Description				Default
                    # read		open for reading		!write
                    # write		open for writing		truncate | append
                    # create	create if non-existent	!read & write | truncate | append
                    # truncate	truncate to zero size	!read & write
                    # append	seek to end				false

                    # Mode	Description						Keywords
                    # r		read							none
                    # w		write, create, truncate			write = true
                    # a		write, create, append			append = true
                    # r+	read, write						read = true, write = true
                    # w+	read, write, create, truncate	truncate = true, read = true
                    # a+	read, write, create, append		append = true, read = true

                    # 使用 isreadable(io) 函數判斷文檔是否可讀;
                    if Base.isreadable(fRIO)

                        # Base.read!(filename::AbstractString, array::Core.Union{Core.Array, Base.BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                        file_data_bytes_Array = Core.Array{Core.UInt8}(undef, file_size);  # 創建一個長度為待讀取文檔大小（單位：字節(Bytes)，1 字節(Bytes) = 8 比特(bits)）的一維 Core.UInt8 類型的數組;
                        # Base.readbytes!(web_path, file_data_bytes_Array, nb=Base.length(file_data_bytes_Array); all=true);  # 一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型，注意承接讀取到的數據的數組長度必須大於等於待讀取文檔的大小（單位：字節(Bytes)，1 字節(Bytes) = 8 比特(bits)）;
                        Base.read!(web_path, file_data_bytes_Array);  # 一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型，注意承接讀取到的數據的數組長度必須大於等於待讀取文檔的大小（單位：字節(Bytes)，1 字節(Bytes) = 8 比特(bits)）;
                        # println(file_data_bytes_Array);
                        # file_data_UInt8Array = Core.Array{Core.Union{Core.UInt8, Core.String}, 1}();
                        file_data_UInt8Array = Core.Array{Core.Any, 1}();  # 注意，自定義的數組轉字符串函數 JSONstring() 只能接受 Core.Any 類型的一維數組;
                        # for X in file_data_bytes_Array
                        #     X = Base.convert(Core.String, Base.bitstring(X));  # 使用 convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量，函數 Base.bitstring() 表示將二進制數字轉爲二進制數字的字符串，例如 Base.bitstring(11100101) === "11100101";
                        #     Base.push!(file_data_UInt8Array, X);  # 使用 push! 函數在數組末尾追加推入新元素，Base.strip(str) 去除字符串首尾兩端的空格;
                        # end
                        for i = 1:Base.length(file_data_bytes_Array)
                            # Base.push!(file_data_UInt8Array, Base.string(Base.bitstring(file_data_bytes_Array[i])));  # 使用 push! 函數在數組末尾追加推入新元素，函數 Base.bitstring() 表示將二進制數字轉爲二進制數字的字符串，例如 Base.bitstring(11100101) === "11100101";
                            Base.push!(file_data_UInt8Array, Core.UInt8(file_data_bytes_Array[i]));  # 使用 push! 函數在數組末尾追加推入新元素;
                        end
                        # println(file_data_UInt8Array);
                        # file_data = Base.string("[", Base.string(Base.join(file_data_UInt8Array, ",")), "]");
                        file_data = "[" * Base.string(Base.join(file_data_UInt8Array, ",")) * "]";
                        # file_data_UInt8Array = [Base.parse(Core.UInt8, X, base=10) for X=Base.split(file_data, ",")];  # Julia 的數組推導式：[x+y for x=[[1,2] [3,4]], y=10:10:30 if isodd(x)] 返回值為：6-element Array{Int64,1}[11,13,21,23,31,33]，函數 Base.parse() 表示將字符串類型變量解析為數字類型變量，參數 base=10 表示基於十進制轉換;
                        # file_data = JSONstring(file_data_UInt8Array);  # 使用自定義函數將 Core.Any 類型的一維數組轉換爲 JSON 字符串;
                        # JSONstring(Dict_Array::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}})::Core.String
                        # JSONparse(JSON_string::Core.String)::Core.Union{Base.Dict{Core.String, Core.Any}, Core.Array{Core.Any, 1}, Base.Vector{Core.Any}}

                        # file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                        # println(file_data);

                    else

                        println("指定的文檔: " * Base.string(request_Path) * " 無法讀取數據.";);
                        # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 無法讀取數據.";
                        response_body_Dict["Server_say"] = "文檔: " * Base.string(request_Path) * " 無法讀取數據.";
                        # response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) unable to read.";
                        response_body_Dict["error"] = "File ( " * Base.string(request_Path) * " ) unable to read.";

                        # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                        # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                        # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                        # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                        # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                        # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                        response_body_String = JSONstring(response_body_Dict);
                        # println(response_body_String);
                        # Base.exit(0);
                        return response_body_String;
                    end

                    # 讀取輸入輸出的管道流（IOStream）中的數據保存在指定的内存緩衝區（Base.IOBuffer）中;
                    # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                    # Base.read(io, Core.String);
                    # "JuliaLang is a GitHub organization";
                    # Base.read(filename::AbstractString, Core.String);
                    # Read the entire contents of a file as a string.
                    # Base.read(s::IOStream, nb::Integer; all=true);
                    # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                    # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                    # Base.read(command::Cmd)
                    # Run command and return the resulting output as an array of bytes.
                    # Base.read(command::Cmd, Core.String)
                    # Run command and return the resulting output as a String.
                    # Base.read!(stream::IO, array::Union{Array, BitArray})
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                    # Read binary data from an I/O stream or file, filling in array.
                    # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                    # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                    # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                    # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                    # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                    # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                    # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                    # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                    # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                    # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                    # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                    # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                    # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                    # Base.ismarked(io);  # Return true if stream s is marked;
                    # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                    # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                    # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                    # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                    # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                    # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                    # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                    # Base.close(io);  # 關閉緩衝區;
                    # println(a)
                    # Base.redirect_stdout — Function
                    # redirect_stdout([stream]) -> (rd, wr)
                    # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                    # If called with the optional stream argument, then returns stream itself.
                    # Base.redirect_stdout — Method
                    # redirect_stdout(f::Function, stream)
                    # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                    # Base.redirect_stderr — Function
                    # redirect_stderr([stream]) -> (rd, wr)
                    # Like redirect_stdout, but for stderr.
                    # Base.redirect_stderr — Method
                    # redirect_stderr(f::Function, stream)
                    # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                    # Base.redirect_stdin — Function
                    # redirect_stdin([stream]) -> (rd, wr)
                    # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                    # Base.redirect_stdin — Method
                    # redirect_stdin(f::Function, stream)
                    # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

                catch err

                    if Core.isa(err, Core.InterruptException)

                        print("\n");
                        # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                        # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                        println("[ Ctrl ] + [ c ] received, will be return Function.");

                        # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                        # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                        response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                        response_body_Dict["error"] = Base.string(err);

                    else

                        println("指定的文檔: " * web_path * " 無法讀取.");
                        println(err);
                        # println(err.msg);
                        # println(Base.typeof(err));

                        response_body_Dict["Server_say"] = "指定的文檔: " * Base.string(request_Path) * " 無法讀取.";
                        # response_body_Dict["Server_say"] = "指定的文檔: " * Base.string(web_path) * " 無法讀取.";
                        response_body_Dict["error"] = Base.string(err);
                    end

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;

                finally
                    Base.close(fRIO);
                end

                fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
                # Base.GC.gc();  # 内存回收函數 gc();

            else

                # response_body_Dict["Server_say"] = "請求文檔: " * Base.string(web_path) * " 無法識別.";
                response_body_Dict["Server_say"] = "請求文檔: " * Base.string(request_Path) * " 無法識別.";
                # response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";
                response_body_Dict["error"] = "File = { " * Base.string(request_Path) * " } unrecognized.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                return response_body_String;
            end

            if file_data !== ""
                # response_body_String = Base.string(Base.replace(file_data, "<!-- directoryHTML -->" => directoryHTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
                response_body_String = Base.string(file_data);
            else
                # response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path) * " 爲空.";
                response_body_Dict["Server_say"] = "文檔: " * Base.string(request_Path) * " 爲空.";
                # response_body_Dict["error"] = "File ( " * Base.string(web_path) * " ) empty.";
                response_body_Dict["error"] = "File ( " * Base.string(request_Path) * " ) empty.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end
            # println(response_body_String);

            return response_body_String;

        elseif Base.Filesystem.ispath(webPath) && Base.Filesystem.isdir(web_path)

            # # 檢查待讀取目錄（文件夾）操作權限;
            # if Base.stat(web_path).mode !== Core.UInt64(16822) && Base.stat(web_path).mode !== Core.UInt64(16895)
            #     # 十進制 16822 等於八進制 40666，十進制 16895 等於八進制 40777，修改文件夾權限，使用 Base.stat(monitor_dir) 函數讀取文檔信息，使用 Base.stat(monitor_dir).mode 方法提取文檔權限碼;
            #     # println("文件夾 [ " * web_path * " ] 操作權限不爲 mode=0o777 或 mode=0o666 .");
            #     try
            #         # 使用 Base.Filesystem.chmod(web_path, mode=0o777; recursive=false) 函數修改文件夾操作權限;
            #         # Base.Filesystem.chmod(path::AbstractString, mode::Integer; recursive::Bool=false)  # Return path;
            #         Base.Filesystem.chmod(web_path, mode=0o777; recursive=true);  # recursive=true 表示遞歸修改文件夾下所有文檔權限;
            #         # println("文件夾: " * web_path * " 操作權限成功修改爲 mode=0o777 .");

            #         # 八進制值    說明
            #         # 0o400      所有者可讀
            #         # 0o200      所有者可寫
            #         # 0o100      所有者可執行或搜索
            #         # 0o40       群組可讀
            #         # 0o20       群組可寫
            #         # 0o10       群組可執行或搜索
            #         # 0o4        其他人可讀
            #         # 0o2        其他人可寫
            #         # 0o1        其他人可執行或搜索
            #         # 構造 mode 更簡單的方法是使用三個八進位數字的序列（例如 765），最左邊的數位（示例中的 7）指定文檔所有者的許可權，中間的數字（示例中的 6）指定群組的許可權，最右邊的數字（示例中的 5）指定其他人的許可權；
            #         # 數字	說明
            #         # 7	可讀、可寫、可執行
            #         # 6	可讀、可寫
            #         # 5	可讀、可執行
            #         # 4	唯讀
            #         # 3	可寫、可執行
            #         # 2	只寫
            #         # 1	只可執行
            #         # 0	沒有許可權
            #         # 例如，八進制值 0o765 表示：
            #         # 1) 、所有者可以讀取、寫入和執行該文檔；
            #         # 2) 、群組可以讀和寫入該文檔；
            #         # 3) 、其他人可以讀取和執行該文檔；
            #         # 當使用期望的文檔模式的原始數字時，任何大於 0o777 的值都可能導致不支持一致的特定於平臺的行為，因此，諸如 S_ISVTX、 S_ISGID 或 S_ISUID 之類的常量不會在 fs.constants 中公開；
            #         # 注意，在 Windows 系統上，只能更改寫入許可權，並且不會實現群組、所有者或其他人的許可權之間的區別；

            #     catch err
            #         println("目錄（文件夾）: " * web_path * " 無法修改操作權限爲 mode=0o777 .");
            #         println(err);
            #         # println(err.msg);
            #         # println(Base.typeof(err));

            #         response_body_Dict["Server_say"] = "目錄（文件夾）：[ " * Base.string(fileName) * " ] 無法修改操作權限爲 mode=0o777 .";  # "directory = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
            #         # response_body_Dict["error"] = "directory = [ " * Base.string(fileName) * " ] change the permissions mode=0o777 fail.";
            #         response_body_Dict["error"] = Base.string(err);

            #         # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            #         # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #         # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #         # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            #         # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            #         # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            #         response_body_String = JSONstring(response_body_Dict);
            #         # println(response_body_String);
            #         # Base.exit(0);
            #         return response_body_String;
            #     end
            # end

            directoryHTML = "<tr><td>文檔或路徑名稱</td><td>文檔大小（單位：Bytes）</td><td>文檔修改時間</td><td>操作</td></tr>";

            # 同步讀取指定硬盤文件夾下包含的内容名稱清單，返回字符串數組;
            if Base.Filesystem.ispath(web_path) && Base.Filesystem.isdir(web_path)

                dir_list_Arror = Base.Filesystem.readdir(web_path);  # 使用 函數讀取指定文件夾下包含的内容名稱清單，返回值為字符串數組;
                # Base.length(Base.Filesystem.readdir(web_path));
                # if Base.length(dir_list_Arror) > 0

                    for item in dir_list_Arror

                        # if request_Path === "/"
                        #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, item), "?fileName=", Base.string(request_Path, item), "&Key=", Base.string(key), "#");
                        #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, item), "&Key=", Base.string(key), "#");
                        # elseif request_Path === "/index.html"
                        #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string("/", item), "?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string("/", item), "&Key=", Base.string(key), "#");
                        # else
                        #     name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, "/", item), "?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        #     delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        # end
                        name_href_url_string = Base.string("http://", Base.string(request_Host), Base.string(request_Path, "/", item), "?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        # name_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), Base.string(request_Path, "/", item), "?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        delete_href_url_string = Base.string("http://", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        # delete_href_url_string = Base.string("http://", Base.string(key), "@", Base.string(request_Host), "/deleteFile?fileName=", Base.string(request_Path, "/", item), "&Key=", Base.string(key), "#");
                        downloadFile_href_string = """fileDownload('post', 'UpLoadData', '$(Base.string(name_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', 'directoryDiv', window, 'bytes', '<fenliejiangefuhao>', '\n', '$(Base.string(item))', function(error, response){})""";
                        deleteFile_href_string = """deleteFile('post', 'UpLoadData', '$(Base.string(delete_href_url_string))', parseInt(0), '$(Base.string(key))', 'Session_ID=request_Key->$(Base.string(key))', 'abort_button_id_string', 'UploadFileLabel', function(error, response){})""";

                        statsObj = Base.stat(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))));

                        if Base.Filesystem.isfile(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))))
                            # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Float64(statsObj.size) / Core.Float64(1024.0)), " KiloBytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
                            # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td></tr>""";
                            directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
                            # directoryHTML = directoryHTML * """<tr><td><a onclick="$(downloadFile_href_string)" href="javascript:void(0)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a onclick="$(deleteFile_href_string)" href="javascript:void(0)">刪除</a></td></tr>""";
                            # directoryHTML = directoryHTML * """<tr><td><a href="javascript:$(downloadFile_href_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="${delete_href_url_string}">刪除</a></td></tr>""";
                        elseif Base.Filesystem.isdir(Base.string(Base.Filesystem.joinpath(Base.Filesystem.abspath(web_path), Base.string(item))))
                            # directoryHTML = directoryHTML * """<tr><td><a href="#">$(Base.string(item))</a></td><td></td><td></td></tr>""";
                            directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td></td><td></td><td><a href="javascript:$(deleteFile_href_string)">刪除</a></td></tr>""";
                            # directoryHTML = directoryHTML * """<tr><td><a href="$(name_href_url_string)">$(Base.string(item))</a></td><td>$(Base.string(Base.string(Core.Int64(statsObj.size)), " Bytes"))</td><td>$(Base.string(Dates.unix2datetime(statsObj.mtime)))</td><td><a href="$(delete_href_url_string)">刪除</a></td></tr>""";
                        else
                        end

                    end

                # end

            else

                # response_body_Dict["Server_say"] = "服務器的運行路徑: " * Base.string(web_path) * " 無法識別.";
                response_body_Dict["Server_say"] = "服務器的運行路徑: " * Base.string(request_Path) * " 無法識別.";
                # response_body_Dict["error"] = "Folder = { " * Base.string(web_path) * " } unrecognized.";
                response_body_Dict["error"] = "Folder = { " * Base.string(request_Path) * " } unrecognized.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                return response_body_String;
            end
            # 同步讀取硬盤 .html 文檔，返回字符串;
            if Base.Filesystem.ispath(web_path_index_Html) && Base.Filesystem.isfile(web_path_index_Html)

                fRIO = Core.nothing;  # ::IOStream;
                try
                    # line = Base.Filesystem.readlink(web_path_index_Html);  # 讀取文檔中的一行數據;
                    # Base.readlines — Function
                    # Base.readlines(io::IO=stdin; keep::Bool=false)
                    # Base.readlines(filename::AbstractString; keep::Bool=false)
                    # Read all lines of an I/O stream or a file as a vector of strings. Behavior is equivalent to saving the result of reading readline repeatedly with the same arguments and saving the resulting lines as a vector of strings.
                    # for line in eachline(web_path_index_Html)
                    #     print(line);
                    # end
                    # Base.displaysize([io::IO]) -> (lines, columns)
                    # Return the nominal size of the screen that may be used for rendering output to this IO object. If no input is provided, the environment variables LINES and COLUMNS are read. If those are not set, a default size of (24, 80) is returned.
                    # Base.countlines — Function
                    # Base.countlines(io::IO; eol::AbstractChar = '\n')
                    # Read io until the end of the stream/file and count the number of lines. To specify a file pass the filename as the first argument. EOL markers other than '\n' are supported by passing them as the second argument. The last non-empty line of io is counted even if it does not end with the EOL, matching the length returned by eachline and readlines.

                    # 在 Base.open() 函數中，還可以調用函數;
                    # Base.open(Base.readline, "sdy.txt");
                    # 也可以調用自定義函數;
                    # readFunc(s::IOStream) = Base.read(s, Char);
                    # Base.open(readFunc, "sdy.txt");
                    # 還可以像Python中的 with open...as 的用法一樣打開文件;
                    # Base.open("sdy.txt","r") do stream
                    #     for line in eachline(stream)
                    #         println(line);
                    #     end
                    # end
                    # 也可以將上述程序定義成函數再用open操作;
                    # function readFunc2(stream)
                    #     for line in eachline(stream)
                    #         println(line);
                    #     end
                    # end
                    # Base.open(readFunc2, "sdy.txt");

                    fRIO = Base.open(web_path_index_Html, "r");
                    # nb = countlines(fRIO);  # 計算文檔中數據行數;
                    # seekstart(fRIO);  # 指針返回文檔的起始位置;

                    # Keyword	Description				Default
                    # read		open for reading		!write
                    # write		open for writing		truncate | append
                    # create	create if non-existent	!read & write | truncate | append
                    # truncate	truncate to zero size	!read & write
                    # append	seek to end				false

                    # Mode	Description						Keywords
                    # r		read							none
                    # w		write, create, truncate			write = true
                    # a		write, create, append			append = true
                    # r+	read, write						read = true, write = true
                    # w+	read, write, create, truncate	truncate = true, read = true
                    # a+	read, write, create, append		append = true, read = true

                    # io = Base.IOBuffer("JuliaLang is a GitHub organization");
                    # Base.read(io, Core.String);
                    # "JuliaLang is a GitHub organization";
                    # Base.read(filename::AbstractString, Core.String);
                    # Read the entire contents of a file as a string.
                    # Base.read(s::IOStream, nb::Integer; all=true);
                    # Read at most nb bytes from s, returning a Base.Vector{UInt8} of the bytes read.
                    # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.
                    # Base.read(command::Cmd)
                    # Run command and return the resulting output as an array of bytes.
                    # Base.read(command::Cmd, Core.String)
                    # Run command and return the resulting output as a String.
                    # Base.read!(stream::IO, array::Union{Array, BitArray})
                    # Base.read!(filename::AbstractString, array::Union{Array, BitArray})
                    # Read binary data from an I/O stream or file, filling in array.
                    # Base.readbytes!(stream::IO, b::AbstractVector{UInt8}, nb=length(b))
                    # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                    # Base.readbytes!(stream::IOStream, b::AbstractVector{UInt8}, nb=length(b); all::Bool=true)
                    # Read at most nb bytes from stream into b, returning the number of bytes read. The size of b will be increased if needed (i.e. if nb is greater than length(b) and enough bytes could be read), but it will never be decreased.
                    # If all is true (the default), this function will block repeatedly trying to read all requested bytes, until an error or end-of-file occurs. If all is false, at most one read call is performed, and the amount of data returned is device-dependent. Note that not all stream types support the all option.

                    # 使用 isreadable(io) 函數判斷文檔是否可讀;
                    if Base.isreadable(fRIO)
                        # Base.read!(filename::AbstractString, array::Union{Array, BitArray});  一次全部讀入文檔中的數據，將讀取到的數據解析為二進制數組類型;
                        file_data = Base.read(fRIO, Core.String);  # Base.read(filename::AbstractString, Core.String) 一次全部讀入文檔中的數據，將讀取到的數據解析為字符串類型 "utf-8" ;
                    else
                        response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path_index_Html) * " 無法讀取數據.";
                        response_body_Dict["error"] = "File ( " * Base.string(web_path_index_Html) * " ) unable to read.";

                        # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                        # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                        # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                        # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                        # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                        # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                        response_body_String = JSONstring(response_body_Dict);
                        # println(response_body_String);
                        # Base.exit(0);
                        return response_body_String;
                    end

                    # 在内存中創建一個用於輸入輸出的管道流（IOStream）的緩衝區（Base.IOBuffer）;
                    # io = Base.Base.IOBuffer();  # 在内存中創建一個輸入輸出管道流（IOStream）的緩衝區（Base.IOBuffer）;
                    # Base.write(io, "How are you.", "Fine, thankyou, and you?");  # 向緩衝區寫入數據;
                    # println(Base.string(Base.take!(io)));  # 使用 take!(io) 方法取出緩衝區數據，使用 String() 方法，將從緩衝區取出的數據强制轉換爲字符串類型;
                    # println(Base.position(io));  # position(io) 表示顯示指定緩衝區當前所在的讀寫位置（position）;
                    # Base.mark(io);  # Add a mark at the current position of stream s. Return the marked position;
                    # Base.unmark(io);  # Remove a mark from stream s. Return true if the stream was marked, false otherwise;
                    # Base.reset(io);  # Reset a stream s to a previously marked position, and remove the mark. Return the previously marked position. Throw an error if the stream is not marked;
                    # Base.ismarked(io);  # Return true if stream s is marked;
                    # Base.eof(stream);  # -> Bool，測試 I/O 流是否在文檔末尾，如果流還沒有用盡，這個函數將阻塞以等待更多的數據（如果需要），然後返回 false 值，因此，在看到 eof() 函數返回 false 值後讀取一個字節總是安全的，只要緩衝區的數據仍然可用，即使鏈接的遠端已關閉，eof() 函數也將返回 false 值;
                    # Test whether an I/O stream is at end-of-file. If the stream is not yet exhausted, this function will block to wait for more data if necessary, and then return false. Therefore it is always safe to read one byte after seeing eof return false. eof will return false as long as buffered data is still available, even if the remote end of a connection is closed.
                    # Base.skip(io, 3);  # skip(io, 3) 表示將指定緩衝區的讀寫位置（position），從當前所在的讀寫位置（position）跳轉到後延 3 個字符之後的讀寫位置（position）;
                    # Base.seekstart(io);  # 移動讀寫位置（position）到緩衝區首部;
                    # Base.seekend(io);  # 移動讀寫位置（position）到緩衝區尾部;
                    # Base.seek(io, 0);  # 移動讀寫位置（position）到緩衝區首部，因爲剛才的寫入 write() 操作之後，讀寫位置（position）已經被移動到了文檔尾部了，如果不移動到首部，則讀出爲空;
                    # a = Base.read(io, Core.String);  # 從緩衝區讀出數據;
                    # Base.close(io);  # 關閉緩衝區;
                    # println(a)
                    # Base.redirect_stdout — Function
                    # redirect_stdout([stream]) -> (rd, wr)
                    # Create a pipe to which all C and Julia level stdout output will be redirected. Returns a tuple (rd, wr) representing the pipe ends. Data written to stdout may now be read from the rd end of the pipe. The wr end is given for convenience in case the old stdout object was cached by the user and needs to be replaced elsewhere.
                    # If called with the optional stream argument, then returns stream itself.
                    # Base.redirect_stdout — Method
                    # redirect_stdout(f::Function, stream)
                    # Run the function f while redirecting stdout to stream. Upon completion, stdout is restored to its prior setting.
                    # Base.redirect_stderr — Function
                    # redirect_stderr([stream]) -> (rd, wr)
                    # Like redirect_stdout, but for stderr.
                    # Base.redirect_stderr — Method
                    # redirect_stderr(f::Function, stream)
                    # Run the function f while redirecting stderr to stream. Upon completion, stderr is restored to its prior setting.
                    # Base.redirect_stdin — Function
                    # redirect_stdin([stream]) -> (rd, wr)
                    # Like redirect_stdout, but for stdin. Note that the order of the return tuple is still (rd, wr), i.e. data to be read from stdin may be written to wr.
                    # Base.redirect_stdin — Method
                    # redirect_stdin(f::Function, stream)
                    # Run the function f while redirecting stdin to stream. Upon completion, stdin is restored to its prior setting.

                catch err

                    if Core.isa(err, Core.InterruptException)

                        print("\n");
                        # println("接收到鍵盤 [ Ctrl ] + [ c ] 信號 (sigint)「" * Base.string(err) * "」進程被終止.");
                        # Core.InterruptException 表示用戶中斷執行，通常是輸入：[ Ctrl ] + [ c ];
                        println("[ Ctrl ] + [ c ] received, will be return Function.");

                        # println("主進程: process-" * Base.string(Distributed.myid()) * " , 主執行緒（綫程）: thread-" * Base.string(Base.Threads.threadid()) * " , 調度任務（協程）: task-" * Base.string(Base.objectid(Base.current_task())) * " 正在關閉 ...");  # 當使用 Distributed.myid() 時，需要事先加載原生的支持多進程標準模組 using Distributed 模組;
                        # println("Main process-" * Base.string(Distributed.myid()) * " Main thread-" * Base.string(Base.Threads.threadid()) * " Dispatch task-" * Base.string(Base.objectid(Base.current_task())) * " being exit ...");  # Distributed.myid() 需要事先加載原生的支持多進程標準模組 using Distributed 模組;

                        response_body_Dict["Server_say"] = "[ Ctrl ] + [ c ] received, the process was aborted.";
                        response_body_Dict["error"] = Base.string(err);

                    else

                        println("指定的文檔: " * web_path_index_Html * " 無法讀取.");
                        println(err);
                        # println(err.msg);
                        # println(Base.typeof(err));

                        response_body_Dict["Server_say"] = "指定的文檔: " * Base.string(web_path_index_Html) * " 無法讀取.";
                        response_body_Dict["error"] = Base.string(err);
                    end

                    # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                    # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                    # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                    # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                    response_body_String = JSONstring(response_body_Dict);
                    # println(response_body_String);
                    # Base.exit(0);
                    return response_body_String;

                finally
                    Base.close(fRIO);
                end

                fRIO = Core.nothing;  # 將已經使用完畢後續不再使用的變量置空，便於内存回收機制回收内存;
                # Base.GC.gc();  # 内存回收函數 gc();

            else

                response_body_Dict["Server_say"] = "請求文檔: " * Base.string(web_path_index_Html) * " 無法識別.";
                response_body_Dict["error"] = "File = { " * Base.string(web_path_index_Html) * " } unrecognized.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                return response_body_String;
            end
            # 替換 .html 文檔中指定的位置字符串;
            if file_data !== ""
                response_body_String = Base.string(Base.replace(file_data, "<!-- directoryHTML -->" => directoryHTML));  # 函數 Base.replace("GFG is a CS portal.", "CS" => "Computer Science") 表示在指定字符串中查找並替換指定字符串;
            else
                response_body_Dict["Server_say"] = "文檔: " * Base.string(web_path_index_Html) * " 爲空.";
                response_body_Dict["error"] = "File ( " * Base.string(web_path_index_Html) * " ) empty.";

                # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
                # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
                # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
                # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
                response_body_String = JSONstring(response_body_Dict);
                # println(response_body_String);
                # Base.exit(0);
                return response_body_String;
            end
            # println(response_body_String);

            return response_body_String;

        else

            println("上傳參數錯誤，指定的文檔或文件夾名稱字符串 { " * Base.string(web_path) * " } 無法識別.");
            # response_body_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " * Base.string(web_path) * " } 無法識別.";
            response_body_Dict["Server_say"] = "上傳參數錯誤，指定的文檔或文件夾名稱字符串 file = { " * Base.string(request_Path) * " } 無法識別.";
            # response_body_Dict["error"] = "File = { " * Base.string(web_path) * " } unrecognized.";
            response_body_Dict["error"] = "File = { " * Base.string(request_Path) * " } unrecognized.";
            # 將 Julia 字典（Dict）對象轉換為 JSON 字符串;
            # Julia_Dict = JSONparse(JSON_Str);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSONstring(Julia_Dict);  # 自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
            # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
            # 使用自定義函數 JSONstring() 將 Julia 字典（Dict）對象轉換爲 JSON 字符串;
            response_body_String = JSONstring(response_body_Dict);
            # println(response_body_String);
            return response_body_String;
        end

        return response_body_String;
    end

end



# # 媒介服務器函數服務端（後端） TCP_Server() 使用説明;
# # 控制臺命令行使用:
# # C:\>C:\Criss\Julia\Julia-1.6.2\bin\julia.exe -p 4 --project=C:/Criss/jl/ C:\Criss\jl\src\Router.jl
# # 啓動運行;
# # 參數 -p 4 表示設定允許 4 個進程并發;
# # 參數 --project=C:/Criss/jl/ 表示隔離全局環境，只是用項目私人環境 C:/Criss/jl/ 啓動 Julia 解釋器;
# # 媒介服務器函數服務端（後端） TCP_Server() 使用説明;
# webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# # webPath = Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath(".")), "html"));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# host = Sockets.IPv6(0);  # "::1";  # "0.0.0.0";  # ::Core.String = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
# key = "username:password";  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
# session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# do_Function = do_Request;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_POST_root_directory";
# number_Worker_threads = 0;#Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# time_sleep = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# TCP_Server = TCP_Server;
# # worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
# # total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;

# # a = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
# a = TCP_Server_Run(
#     host = host,  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
#     port = port,  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
#     do_Function = do_Function,  # do_Request,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request_root_directory";
#     key = key,  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
#     session = session,  # ::Base.Dict{Core.String, Core.Any}("request_Key->username:password" => Key),  # 保存網站的 Session 數據;
#     number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
#     time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     # total_worker_called_number = total_worker_called_number,  # Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
#     TCP_Server = TCP_Server
# );
# # println(typeof(a))
# # println(a[1])
# # println(a[2])
# # println(a[3])



# # 使用 Julia 語言的第三方擴展包「HTTP」製作的，媒介服務器函數服務端（後端） HTTP.listen!() 使用説明;
# using HTTP;  # 導入第三方擴展包「HTTP」，用於創建 HTTP server 服務器，需要在控制臺先安裝第三方擴展包「HTTP」：julia> using Pkg; Pkg.add("HTTP") 成功之後才能使用;
# using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# # 控制臺命令行使用:
# # C:\>C:\Criss\Julia\Julia-1.9.3\bin\julia.exe -p 4 --project=C:/Criss/jl/ C:\Criss\jl\src\Router.jl
# # 啓動運行;
# # 參數 -p 4 表示設定允許 4 個進程并發;
# # 參數 --project=C:/Criss/jl/ 表示隔離全局環境，只是用項目私人環境 C:/Criss/jl/ 啓動 Julia 解釋器;
# # 媒介服務器函數服務端（後端） http_Server() 使用説明;
# webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# # webPath = Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath(".")), "html"));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# host = Sockets.IPv6(0);  # "::1";  # "0.0.0.0";  # ::Core.String = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
# key = "username:password";  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
# session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# do_Function = do_Request;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_POST_root_directory";
# number_Worker_threads = Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# time_sleep = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# readtimeout = Core.Int(0);  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
# verbose = Core.Bool(false);  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
# isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# http_Server = http_Server;
# # worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
# # total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;

# # a = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
# a = http_Server_Run(
#     host = host,  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
#     port = port,  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
#     do_Function = do_Function,  # do_Request,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request_root_directory";
#     key = key,  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
#     session = session,  # ::Base.Dict{Core.String, Core.Any}("request_Key->username:password" => Key),  # 保存網站的 Session 數據;
#     number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
#     time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     readtimeout = readtimeout,  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
#     verbose = verbose,  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
#     isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     # total_worker_called_number = total_worker_called_number,  # Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
#     http_Server = http_Server
# );
# # println(typeof(a))
# # println(a[1])
# # println(a[2])
# # println(a[3])






# using HTTP;  # 導入第三方擴展包「HTTP」，用於創建 HTTP server 服務器，需要在控制臺先安裝第三方擴展包「HTTP」：julia> using Pkg; Pkg.add("HTTP") 成功之後才能使用;
# Cookie Persistence;
mycookiejar::HTTP.CookieJar = HTTP.CookieJar();
# HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers)
# HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI)


# 示例函數，處理從服務器端返回的響應信息;
function do_Response(response_Dict::Core.Union{Core.String, Base.Dict})::Core.Union{Core.String, Base.Dict}

    # print("當前協程 task: ", Base.current_task(), "\n");
    # print("當前協程 task 的 ID: ", Base.objectid(Base.current_task()), "\n");
    # print("當前綫程 thread 的 PID: ", Base.Threads.threadid(), "\n");
    # print("Julia 進程可用的綫程數目上綫: ", Base.Threads.nthreads(), "\n");
    # print("當前進程的 PID: ", Distributed.myid(), "\n");  # 需要事先加載原生的支持多進程標準模組 using Distributed 模組;
    # println(data_Str);

    if Base.length(request_Dict) > 0
        # Base.isa(request_Dict, Base.Dict)

        if Base.haskey(request_Dict, "request_IP")
        end
        if Base.haskey(request_Dict, "request_Path")
        end
        if Base.haskey(request_Dict, "request_Method")
        end
    end

    request_data_Dict = Base.Dict{Core.String, Core.Any}();  # 函數返回值，聲明一個空字典;
    request_data_Dict = request_Dict;
    request_form_value::Core.String = request_data_Dict["request_Data"];  # 函數接收到的參數值;

    response_data_Dict = Base.Dict{Core.String, Core.Any}();  # 函數返回值，聲明一個空字典;
    response_data_String::Core.String = "";

    # # require_data_Dict = Base.Dict{Core.String, Core.Any}();  # Base.Dict{Core.String, Int64}()聲明一個空字典並指定數據類型;
    # require_data_Dict = Base.Dict();  # 聲明一個空字典，函數接收到的參數;
    # # 使用自定義函數isStringJSON(request_form_value)判斷讀取到的請求體表單"form"數據 request_form_value 是否為JSON格式的字符串;
    # if isStringJSON(request_form_value)
    #     require_data_Dict = JSONparse(request_form_value);  # 使用自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # require_data_Dict = JSON.parse(request_form_value);  # 使用第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # Julia_Dict = JSON.parse(JSON_Str);  # 第三方擴展包「JSON」中的函數，將 JSON 字符串轉換爲 Julia 的字典對象;
    #     # JSON_Str = JSON.json(Julia_Dict);  # 第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # else
    #     require_data_Dict["Client_say"] = data_Str;  # Base.Dict(data_Str);  # Base.Dict("aa" => 1, "bb" => 2, "cc" => 3);
    # end

    return_file_creat_time = Dates.now();  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
    # println(Base.string(Dates.now()))

    response_data_Dict["Julia_say"] = Base.string(request_form_value);  # Base.Dict("Julia_say" => Base.string(request_form_value));
    response_data_Dict["time"] = Base.string(return_file_creat_time);  # Base.Dict("Julia_say" => Base.string(request_form_value), "time" => string(return_file_creat_time));
    # println(response_data_Dict);

    # response_data_String = JSONstring(response_data_Dict);  # 使用自定義的 JSONstring() 函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    # response_data_String = JSON.json(response_data_Dict);  # 使用第三方擴展包「JSON」中的函數，將 Julia 的字典對象轉換爲 JSON 字符串;
    response_data_String = "{\"Julia_say\":\"" * Base.string(request_form_value) * "\",\"time\":\"" * Base.string(return_file_creat_time) * "\"}";  # 使用星號*拼接字符串;
    # println(response_data_String);

    return response_data_String;
end



# # 媒介服務器函數客戶端（前端） TCP_Client() 使用説明;
# host = Sockets.IPv6("::1");  # "::1";  # "127.0.0.1"; # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# IPVersion = "IPv6";  # "IPv6"、"IPv4";
# port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
# URL = "";
# requestPath = "/";
# requestMethod = "GET";  # "POST",  # "GET"; # 請求方法;
# requestProtocol = "HTTP";
# time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
# # time_out = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# Authorization = "username:password";  # 自定義的訪問網站簡單驗證用戶名和密碼 "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
# Cookie_name = "session_id";
# Cookie_value = "request_Key->username:password";
# # Cookie = Cookie_name * "=" * Cookie_value;  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
# Cookie = Cookie_name * "=" * Base64.base64encode(Cookie_value; context=nothing);  # "Session_ID=request_Key->username:password"，將漢字做Base64轉碼Base64.base64encode()，需要事先加載原生的 Base64 模組：using Base64 模組;
# # println(Core.String(Base64.base64decode(Cookie_value)));
# # println("Request Cook: ", Cookie);
# requestFrom = "user@email.com";
# # do_Function = do_Response;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_Response";
# # session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# # number_Worker_threads = Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# # time_sleep = Core.Float16(0.02);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# # isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# # TCP_Server = TCP_Server;
# # worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
# # total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
# postData = Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect.");  # ::Core.Union{Core.String, Base.Dict}，postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";

# # a = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
# a = TCP_Client(
#     host,  # ::Core.String = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
#     port;  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
#     IPVersion=IPVersion,  # "IPv6"、"IPv4";
#     postData=postData,  # ::Core.Union{Core.String, Base.Dict} = "";  # Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
#     URL=URL,  # ::Core.String = "",
#     requestPath=requestPath,  # ::Core.String = "/",
#     requestMethod=requestMethod,  # ::Core.String = "GET",  # "POST",  # "GET"; # 請求方法;
#     requestProtocol=requestProtocol,  # ::Core.String = "HTTP",
#     # time_out=time_out,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     Authorization=Authorization,  # ::Core.String = ":",  # "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
#     Cookie=Cookie,  # ::Core.String = "",  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
#     requestFrom=requestFrom,  # ::Core.String = "user@email.com",
#     # do_Function=do_Function,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
#     # session=session,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => TCP_Server.key),  # 保存網站的 Session 數據;
#     # number_Worker_threads=number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.UInt8(0),  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
#     # time_sleep=time_sleep,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     # isConcurrencyHierarchy=isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     # worker_queues_Dict=worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     # total_worker_called_number=total_worker_called_number,  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
# );
# # println(typeof(a))
# println(a[1])
# println(a[2])
# println(a[3])



# # 使用 Julia 語言的第三方擴展包「HTTP」製作的，媒介服務器函數客戶端（前端） http_Client() 使用説明;
# # using HTTP;  # 導入第三方擴展包「HTTP」，用於創建 HTTP server 服務器，需要在控制臺先安裝第三方擴展包「HTTP」：julia> using Pkg; Pkg.add("HTTP") 成功之後才能使用;
# # using JSON;  # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
# webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# host = Sockets.IPv6("::1"); # ::Core.String = "127.0.0.1", # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
# IPVersion = "IPv6";  # "IPv6"、"IPv4";
# port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
# proxy = Core.nothing;  # ::Core.String = Core.nothing,  # 當需要通過代理服務器僞裝發送請求時，代理服務器的網址 URL 值字符串，pass request through a proxy given as a url; alternatively, the , , , , and environment variables are also detected/used; if set, they will be used automatically when making requests.http_proxyHTTP_PROXYhttps_proxyHTTPS_PROXYno_proxy;
# URL = "";  # "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  # http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1
# requestPath = "/";
# requestMethod = "POST";  # "POST",  # "GET"; # 請求方法;
# requestProtocol = "HTTP";  # Base.Unicode.lowercase(requestProtocol);  # 轉小寫字母;
# Referrer = URL;  # ::Core.String = http_Client.URL,  # 請求的來源網頁 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
# # time_out = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# Authorization = "username:password";  # 自定義的訪問網站簡單驗證用戶名和密碼 "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
# Basicbasicauth = true;  # ::Core.Bool = true,  # 設置從請求網址 URL 中解析截取請求的賬號和密碼，Basic authentication is detected automatically from the provided url's (in the form userinfoscheme://user:password@host) and adds the 「Authorization:」 header; this can be disabled by passing Basicbasicauth = false;
# Cookie_name = "session_id";
# Cookie_value = "request_Key->username:password";
# # Cookie = Cookie_name * "=" * Cookie_value;  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
# Cookie = Cookie_name * "=" * Base64.base64encode(Cookie_value; context=nothing);  # "Session_ID=request_Key->username:password"，將漢字做Base64轉碼Base64.base64encode()，需要事先加載原生的 Base64 模組：using Base64 模組;
# # println(Core.String(Base64.base64decode(Cookie_value)));
# # println("Request Cook: ", Cookie);
# query = Base.Dict{Core.String, Core.String}();  # ::Base.Dict{Core.String, Core.String} = Core.nothing,  # Base.Dict{Core.String, Core.String}(),  # Base.Dict{Core.String, Core.String}("ID" => "23", "IP" => "24"),  # 請求查詢 key => value 字典，a or of key => values to be included in the urlPairDict;
# requestFrom = "user@email.com";
# # do_Function = do_Response;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_Response";
# # session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# # number_Worker_threads = Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# # time_sleep = Core.Float16(0.02);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# readtimeout = Core.Int(0);  # 服務器響應數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
# connect_timeout = Core.Int(0);  # 服務器鏈接超時，單位：（秒），close the connection after this many seconds if it is still attempting to connect. Use to disable.connect_timeout = 0;
# # isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# # http_Server = http_Server;
# # worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
# response_stream::Core.Union{Base.IOStream, Base.IOBuffer, Core.Array{Core.UInt8, 1}, Base.Vector{UInt8}, Core.Nothing, Core.Bool, Core.Int64} = Core.nothing;  # Base.IOBuffer(),  # 設置接收到的響應值類型爲二進制字節流 IO 對象，a writeable stream or any -like type for which is defined. The response body will be written to this stream instead of returned as a .IOIOTwrite(T, AbstractVector{UInt8})Base.Vector{UInt8};
# cookiejar = mycookiejar;  # ::HTTP.CookieJar = HTTP.CookieJar()  # Cookie Persistence; # HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers);  # HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI);

# # total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
# postData = Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.9.3 HTTP.request().");  # ::Core.Union{Core.String, Base.Dict}，postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";

# # a = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
# a = http_Client(
#     host,  # ::Core.String,  # "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
#     port;  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String};  # 0 ~ 65535，監聽埠號（端口）;
#     IPVersion = IPVersion,  # "IPv6"、"IPv4";
#     postData = postData,  # ::Core.Union{Core.String, Base.Dict} = "",  # Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
#     proxy = proxy,  # ::Core.String = Core.nothing,  # 當需要通過代理服務器僞裝發送請求時，代理服務器的網址 URL 值字符串，pass request through a proxy given as a url; alternatively, the , , , , and environment variables are also detected/used; if set, they will be used automatically when making requests.http_proxyHTTP_PROXYhttps_proxyHTTPS_PROXYno_proxy;
#     requestPath = requestPath,  # ::Core.String = "/",
#     requestProtocol = requestProtocol,  # ::Core.String = "HTTP",
#     query = query,  # ::Base.Dict{Core.String, Core.String} = Core.nothing,  # Base.Dict{Core.String, Core.String}(),  # Base.Dict{Core.String, Core.String}("ID" => "23"),  # 請求查詢 key => value 字典，a or of key => values to be included in the urlPairDict;
#     URL = URL,  # ::Core.String = "",  # Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  # 請求網址 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
#     requestMethod = requestMethod,  # ::Core.String = "GET",  # "POST",  # "GET"; # 請求方法;
#     # time_out = time_out,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     readtimeout = readtimeout,  # ::Core.Int = Core.Int(0),  # 服務器響應數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
#     connect_timeout = connect_timeout,  # ::Core.Int = Core.Int(30),  # 服務器鏈接超時，單位：（秒），close the connection after this many seconds if it is still attempting to connect. Use to disable.connect_timeout = 0;
#     Authorization = Authorization,  # ::Core.String = ":",  # "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
#     Basicbasicauth = Basicbasicauth,  # ::Core.Bool = true,  # 設置從請求網址 URL 中解析截取請求的賬號和密碼，Basic authentication is detected automatically from the provided url's (in the form userinfoscheme://user:password@host) and adds the 「Authorization:」 header; this can be disabled by passing Basicbasicauth = false;
#     Cookie = Cookie,  # ::Core.String = "",  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
#     Referrer = Referrer,  # ::Core.String = http_Client.URL,  # 請求的來源網頁 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
#     requestFrom = requestFrom,  # ::Core.String = "user@email.com",
#     # do_Function = do_Function,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
#     # session = session,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => http_Server.key),  # 保存網站的 Session 數據;
#     # number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.UInt8(0),  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
#     # time_sleep = time_sleep,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
#     # isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
#     # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     # total_worker_called_number = total_worker_called_number,  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}(),  # 記錄每個綫程纍加的被調用運算的總次數;
#     response_stream = response_stream,  # Core.nothing,  # Base.IOBuffer(),  # 設置接收到的響應值類型爲二進制字節流 IO 對象，a writeable stream or any -like type for which is defined. The response body will be written to this stream instead of returned as a .IOIOTwrite(T, AbstractVector{UInt8})Base.Vector{UInt8};
#     cookiejar = cookiejar  # ::HTTP.CookieJar = HTTP.CookieJar()  # Cookie Persistence; # HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers);  # HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI);
# );
# # println(typeof(a))
# println(a[1])
# println(a[2])
# println(a[3])



# 函數使用示例;
# 控制臺命令行使用:
# C:\>C:\Criss\Julia\Julia-1.9.3\bin\julia.exe --project=C:/Criss/jl/ C:/Criss/jl/application.jl
# 啓動運行;
# 參數 --project=C:/Criss/jl/ 表示使用 Julia 創建的隔離環境 jl 啓動運行;

# 配置預設值;
interface_Function = monitor_file_Run;  # monitor_file_Run;  # TCP_Server_Run;  # http_Server_Run;  # TCP_Client;  # http_Client;
interface_Function_name_str = "interface_File_Monitor";  # "interface_File_Monitor";  # "interface_TCP_Server";  # "interface_http_Server";  # "interface_TCP_Client";  # "interface_http_Client";

# 配置當 interface_Function = monitor_file_Run 時的預設值;
is_monitor = true;  # true; # Boolean，用於判別是執行一次，還是啓動監聽服務，持續監聽目標文檔，false 值表示只執行一次，true 值表示啓動監聽服務器看守進程持續監聽;
monitor_dir = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸入傳值的媒介目錄 "../Intermediary/";
monitor_file = Base.Filesystem.joinpath(monitor_dir, "intermediary_write_C");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(monitor_dir, "intermediary_write_NodeJS.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於接收傳值的媒介文檔 "../Intermediary/intermediary_write_NodeJS.txt";
output_dir = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，用於輸出傳值的媒介目錄 "../Intermediary/";
output_file = Base.Filesystem.joinpath(output_dir, "intermediary_write_Julia.txt");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(output_dir, "intermediary_write_Julia.txt")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於輸出傳值的媒介文檔 "../Intermediary/intermediary_write_Julia.txt";
temp_cache_IO_data_dir = Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "temp");  # 上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "temp")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__，一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_cache_IO_data_dir\";
do_Function_data = do_data;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行數據處理功能的函數 "do_data";
# do_Function = Core.nothing;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行數據處理功能的函數 "do_data";
to_executable = "";  # Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "NodeJS", "node.exe");  # C:/Progra~1/nodejs/node.exe";  # 上一層路徑下的Node.JS解釋器可執行檔路徑C:\nodejs\node.exe：Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "NodeJS", "node.exe")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的解釋器可執行文件 "..\\NodeJS\\node.exe"，Julia 解釋器可執行檔全名 println(Base.Sys.BINDIR)：C:\Julia 1.5.1\bin，;
to_script = "";  # Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "js", "application.js");  # "C:/Users/china/Documents/Node.js/Criss/jl/test.js";  # 上一層路徑下的 JavaScript 脚本路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "js", "Ruuter.js")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，用於對返回數據執行功能的被調用的脚本文檔 "../js/Ruuter.js";
time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
number_Worker_threads = Core.UInt8(0);  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
isMonitorThreadsOrProcesses = 0;  # "Multi-Threading"; # "Multi-Processes"; # 選擇監聽動作的函數的并發層級（多協程、多綫程、多進程）;
# 當 isMonitorThreadsOrProcesses = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
isDoTasksOrThreads = "Tasks";  # "Multi-Threading"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
# 當 isDoTasksOrThreads = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
do_Function_name_str_data = "do_data";

# 配置當 interface_Function = TCP_Server_Run; interface_Function = http_Server_Run; 時的預設值;
webPath = Base.string(Base.Filesystem.abspath("."));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
# webPath = Base.string(Base.Filesystem.joinpath(Base.string(Base.Filesystem.abspath(".")), "html"));  # 服務器運行的本地硬盤根目錄，可以使用函數：上一層路徑下的temp路徑 Base.Filesystem.joinpath(Base.Filesystem.abspath(".."), "Intermediary")，當前目錄：Base.Filesystem.abspath(".") 或 Base.Filesystem.pwd()，當前路徑 Base.@__DIR__;
host::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv6(0);  # "::1";  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
port = "10001";  # ::Core.Union{Core.String, Core.UInt8} = "10001";  # Core.UInt8(5000),  # 0 ~ 65535， 監聽埠號（端口）;
key = "username:password";  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
session = Base.Dict{Core.String, Core.Any}();  # Base.Dict{Core.String, Core.String}("request_Key->username:password" => key); 自定義 session 值，Base.Dict 對象;
# number_Worker_threads = Core.UInt8(0);  # Core.UInt8(1)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# time_sleep = Core.Float16(0.02);  # Core.Float64(0.02)，監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒，自定義函數檢查輸入合規性 CheckString(delay, 'positive_integer');
readtimeout::Core.Int = Core.Int(0);  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
verbose::Core.Bool = Core.Bool(false);  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
do_Function_Request = do_Request;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 do_Request, "do_POST_root_directory";
# do_Function = Core.nothing;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 do_Request, "do_POST_root_directory";
do_Function_name_str_Request = "do_Request";
isConcurrencyHierarchy = "Tasks";  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# println(Base.Threads.threadid()); # 查看當前綫程 ID 號;

# 配置當 interface_Function = TCP_Client; interface_Function = http_Client; 時的預設值;
# host = Sockets.IPv6("::1"); # ::Core.String = "127.0.0.1", # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
IPVersion = "IPv6";  # "IPv6"、"IPv4";
# port = Core.UInt64(10001);  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = Core.UInt8(8000),  # 0 ~ 65535， 監聽埠號（端口）;
proxy = Core.nothing;  # ::Core.String = Core.nothing,  # 當需要通過代理服務器僞裝發送請求時，代理服務器的網址 URL 值字符串，pass request through a proxy given as a url; alternatively, the , , , , and environment variables are also detected/used; if set, they will be used automatically when making requests.http_proxyHTTP_PROXYhttps_proxyHTTPS_PROXYno_proxy;
URL = "";  # "http://username:password@[fe80::e458:959e:cf12:695%25]:10001/index.html?a=1&b=2&c=3#a1";  # http://username:password@127.0.0.1:8081/index.html?a=1&b=2&c=3#a1
requestPath = "/";
requestMethod = "POST";  # "POST",  # "GET"; # 請求方法;
requestProtocol = "HTTP";  # Base.Unicode.lowercase(requestProtocol);  # 轉小寫字母;
Referrer = URL;  # ::Core.String = http_Client.URL,  # 請求的來源網頁 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
# time_out = Core.Float16(0);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
Authorization = "username:password";  # 自定義的訪問網站簡單驗證用戶名和密碼 "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
Basicbasicauth = true;  # ::Core.Bool = true,  # 設置從請求網址 URL 中解析截取請求的賬號和密碼，Basic authentication is detected automatically from the provided url's (in the form userinfoscheme://user:password@host) and adds the 「Authorization:」 header; this can be disabled by passing Basicbasicauth = false;
Cookie_name = "session_id";
Cookie_value = "request_Key->username:password";
# Cookie = Cookie_name * "=" * Cookie_value;  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
Cookie = Cookie_name * "=" * Base64.base64encode(Cookie_value; context=nothing);  # "Session_ID=request_Key->username:password"，將漢字做Base64轉碼Base64.base64encode()，需要事先加載原生的 Base64 模組：using Base64 模組;
# println(Core.String(Base64.base64decode(Cookie_value)));
# println("Request Cook: ", Cookie);
query = Base.Dict{Core.String, Core.String}();  # ::Base.Dict{Core.String, Core.String} = Core.nothing,  # Base.Dict{Core.String, Core.String}(),  # Base.Dict{Core.String, Core.String}("ID" => "23", "IP" => "24"),  # 請求查詢 key => value 字典，a or of key => values to be included in the urlPairDict;
requestFrom = "user@email.com";
do_Function_Response = do_Response;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_Response";
# do_Function = Core.nothing;  # (argument) -> begin argument; end; 匿名函數對象，用於接收執行對根目錄(/)的 POST 請求處理功能的函數 "do_Response";
do_Function_name_str_Response = "do_Response";
# session = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => key);  # 保存網站的 Session 數據;
# number_Worker_threads = Core.UInt8(Base.Sys.CPU_THREADS);  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
# time_sleep = Core.Float16(0.02);  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
# readtimeout = Core.Int(0);  # 服務器響應數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
connect_timeout = Core.Int(0);  # 服務器鏈接超時，單位：（秒），close the connection after this many seconds if it is still attempting to connect. Use to disable.connect_timeout = 0;
# isConcurrencyHierarchy = "Tasks";  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
# print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
# 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
# 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
# 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
# println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
# println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
# http_Server = http_Server;
# worker_queues_Dict::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
response_stream::Core.Union{Base.IOStream, Base.IOBuffer, Core.Array{Core.UInt8, 1}, Base.Vector{UInt8}, Core.Nothing, Core.Bool, Core.Int64} = Core.nothing;  # Base.IOBuffer(),  # 設置接收到的響應值類型爲二進制字節流 IO 對象，a writeable stream or any -like type for which is defined. The response body will be written to this stream instead of returned as a .IOIOTwrite(T, AbstractVector{UInt8})Base.Vector{UInt8};
cookiejar = mycookiejar;  # ::HTTP.CookieJar = HTTP.CookieJar()  # Cookie Persistence; # HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers);  # HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI);
# total_worker_called_number = Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
postData = Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.9.3 HTTP.request().");  # ::Core.Union{Core.String, Base.Dict}，postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";

# 控制臺傳參，通過 Base.ARGS 數組獲取從控制臺傳入的參數;
# println(Base.typeof(Base.ARGS));
# println(Base.ARGS);
# println(Base.PROGRAM_FILE);  # 通過命令行啓動的，當前正在執行的 Julia 脚本文檔路徑;
# 使用 Base.typeof("abcd") == String 方法判斷對象是否是一個字符串;
# for X in Base.ARGS
#     println(X)
# end
# for X ∈ Base.ARGS
#     println(X)
# end
if Base.length(Base.ARGS) > 0
    for i = 1:Base.length(Base.ARGS)
        # println("Base.ARGS" * Base.string(i) * ": " * Base.string(Base.ARGS[i]));  # 通過 Base.ARGS 數組獲取從控制臺傳入的參數;
        # 使用 Core.isa(Base.ARGS[i], Core.String) 函數判断「元素(变量实例)」是否属于「集合(变量类型集)」之间的关系，使用 Base.typeof(Base.ARGS[i]) <: Core.String 方法判断「集合」是否包含于「集合」之间的关系，或 Base.typeof(Base.ARGS[i]) === Core.String 方法判斷傳入的參數是否為 String 字符串類型;
        if Core.isa(Base.ARGS[i], Core.String) && Base.ARGS[i] !== "" && Base.occursin("=", Base.ARGS[i])

            ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String}, 1}();  # 聲明一個聯合類型的空1維數組;
            # ARGSIArray = Core.Array{Core.Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}();  # 聲明一個聯合類型的空1維數組;
            # 函數 Base.split(Base.ARGS[i], '=') 表示用等號字符'='分割字符串為數組;
            for x in Base.split(Base.ARGS[i], '=')
                x = Base.convert(Core.String, x);  # 使用 convert() 函數將子字符串(SubString)型轉換為字符串(String)型變量;
                Base.push!(ARGSIArray, x);  # 使用 push! 函數在數組末尾追加推入新元素，Base.strip(str) 去除字符串首尾兩端的空格;
            end

            if Base.length(ARGSIArray) > 1

                ARGSValue = "";
                # ARGSValue = join(Base.deleteat!(Base.deepcopy(ARGSIArray), 1), "=");  # 使用 Base.deepcopy() 標注數組深拷貝傳值複製，這樣在使用 Base.deleteat!(ARGSIArray, 1) 函數刪除第一個元素時候就不會改變原數組 ARGSIArray，否則為淺拷貝傳址複製，使用 deleteat!(ARGSIArray, 1) 刪除第一個元素的時候會影響原數組 ARGSIArray 的值，然後將數組從第二個元素起直至末尾拼接為一個字符串;
                for j = 2:Base.length(ARGSIArray)
                    if j === 2
                        ARGSValue = ARGSValue * ARGSIArray[j];  # 使用星號*拼接字符串;
                    else
                        ARGSValue = ARGSValue * "=" * ARGSIArray[j];
                    end
                end

                # try
                #     g = Base.Meta.parse(Base.string(ARGSIArray[1]) * "=" * Base.string(ARGSValue));  # 先使用 Base.Meta.parse() 函數解析字符串為代碼;
                #     Base.MainInclude.eval(g);  # 然後再使用 Base.MainInclude.eval() 函數執行字符串代碼語句;
                #     println(Base.string(ARGSIArray[1]) * " = " * "\$" * Base.string(ARGSIArray[1]));
                # catch err
                #     println(err);
                # end

                if ARGSValue !== ""

                    # 接收當 interface_Function = Interface_File_Monitor 時的傳入參數值;
                    # 用於接收執行功能的函數 do_Function = "do_data"; "do_Request";
                    if ARGSIArray[1] === "interface_Function"

                        global interface_Function_name_str = ARGSValue;
                        # global interface_Function = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;

                        if ARGSValue === "file_Monitor"
                            global interface_Function = monitor_file_Run;
                            global interface_Function_name_str = "interface_File_Monitor";

                            global do_Function_name_str_data = "do_data";
                            global do_Function_data = do_data;
                            # global do_Function = do_data;
                        end

                        if ARGSValue === "TCP_Server"
                            global interface_Function = TCP_Server_Run;
                            global interface_Function_name_str = "interface_TCP_Server";

                            global do_Function_name_str_Request = "do_Request";
                            global do_Function_Request = do_Request;
                            # global do_Function = do_Request;
                        end

                        if ARGSValue === "http_Server"
                            global interface_Function = http_Server_Run;
                            global interface_Function_name_str = "interface_http_Server";

                            global do_Function_name_str_Request = "do_Request";
                            global do_Function_Request = do_Request;
                            # global do_Function = do_Request;
                        end

                        if ARGSValue === "TCP_Client"
                            global interface_Function = TCP_Client;
                            global interface_Function_name_str = "interface_TCP_Client";

                            global do_Function_name_str_Response = "do_Response";
                            global do_Function_Response = do_Response;
                            # global do_Function = do_Response;
                        end

                        if ARGSValue === "http_Client"
                            global interface_Function = http_Client;
                            global interface_Function_name_str = "interface_http_Client";

                            global do_Function_name_str_Response = "do_Response";
                            global do_Function_Response = do_Response;
                            # global do_Function = do_Response;
                        end

                        # print("interface Function: ", interface_Function_name_str, "\n");
                        # print("do Function: ", do_Function_name_str_Request, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "is_monitor"
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global is_monitor = Base.parse(Bool, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 "true / false";
                        # print("is monitor: ", is_monitor, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "monitor_file"
                        global monitor_file = ARGSValue;  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
                        # print("monitor file: ", monitor_file, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "monitor_dir"
                        global monitor_dir = ARGSValue;  # 用於輸入傳值的媒介目錄 "../temp/"，當前路徑 Base.@__DIR__;
                        # print("monitor dir: ", monitor_dir, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "output_dir"
                        global output_dir = ARGSValue;  # 用於輸出傳值的媒介目錄 "../temp/"，當前路徑 Base.@__DIR__;
                        # print("output dir: ", output_dir, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "output_file"
                        global output_file = ARGSValue;  # 用於輸出傳值的媒介文檔 "../temp/intermediary_write_Julia.txt";
                        # print("output file: ", output_file, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "temp_cache_IO_data_dir"
                        global temp_cache_IO_data_dir = ARGSValue;  # 一個唯一的用於暫存傳入傳出數據的臨時媒介文件夾 "C:\Users\china\AppData\Local\Temp\temp_NodeJS_cache_IO_data\"，當前路徑 Base.@__DIR__;
                        # print("Temporary cache IO data directory: ", temp_cache_IO_data_dir, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "to_executable"
                        global to_executable = ARGSValue;  # 用於對返回數據執行功能的解釋器可執行文件 "C:\\NodeJS\\nodejs\\node.exe";
                        # print("to executable: ", to_executable, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "to_script"
                        global to_script = ARGSValue;  # 用於對返回數據執行功能的被調用的脚本文檔 "../js/test.js";
                        # print("to script: ", to_script, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "time_sleep"
                        # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global time_sleep = Base.parse(Core.Float64, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的長整型(Core.UInt64)類型的變量，監聽文檔輪詢延遲時長，單位毫秒 id = setInterval(function, delay);
                        # print("time sleep: ", time_sleep, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "number_Worker_threads"
                        # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global number_Worker_threads = Base.parse(UInt8, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(UInt8)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                        # print("number Worker threads: ", number_Worker_threads, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "isMonitorThreadsOrProcesses"
                        global isMonitorThreadsOrProcesses = ARGSValue;  # 0 || "0" || "Multi-Threading" || "Multi-Processes"; # 選擇監聽動作的函數的并發層級（多協程、多綫程、多進程）;
                        # print("isMonitorThreadsOrProcesses: ", isMonitorThreadsOrProcesses, "\n");
                        # 當 isMonitorThreadsOrProcesses = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
                        # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
                        # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
                        # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
                        # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
                        continue;
                    end

                    if ARGSIArray[1] === "isDoTasksOrThreads"
                        global isDoTasksOrThreads = ARGSValue;  # "Tasks" || "Multi-Threading"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
                        # print("isDoTasksOrThreads: ", isDoTasksOrThreads, "\n");
                        # 當 isDoTasksOrThreads = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
                        # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
                        # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
                        continue;
                    end

                    if ARGSIArray[1] === "do_Function"

                        if ARGSValue === "do_data"

                            # 使用函數 Base.@isdefined(do_data) 判斷 do_data 變量是否已經被聲明過;
                            if Base.@isdefined(do_data)
                                # 使用 Core.isa(do_data, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_data) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_data) <: Function 方法判別 do_data 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
                                # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
                                # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
                                if Base.typeof(do_data) <: Function
                                    global do_Function = do_data;
                                else
                                    println("傳入的參數，指定的變量「" * ARGSValue * "」不是一個函數類型的變量.");
                                    # global do_Function = Core.nothing;  # 置空;
                                    global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                end
                            else
                                println("傳入的參數，指定的變量「" * ARGSValue * "」未定義.");
                                # global do_Function = Core.nothing;  # 置空;
                                global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            end

                            # try
                            #     if length(methods(do_data)) > 0
                            #         global do_Function = do_data;
                            #     else
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     end
                            # catch err
                            #     # println(err);
                            #     # println(Base.typeof(err));
                            #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
                            #     if Core.isa(err, Core.UndefVarError)
                            #         println(err.var, " not defined.");
                            #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     else
                            #         println(err);
                            #     end
                            # finally
                            #     # global do_Function = Core.nothing;  # 置空;
                            #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            # end
                        end

                        if ARGSValue === "do_Request"

                            # 使用函數 Base.@isdefined(do_Request) 判斷 do_Request 變量是否已經被聲明過;
                            if Base.@isdefined(do_Request)
                                # 使用 Core.isa(do_Request, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_Request) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_Request) <: Function 方法判別 do_Request 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
                                # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
                                # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
                                if Base.typeof(do_Request) <: Function
                                    global do_Function = do_Request;
                                else
                                    println("傳入的參數，指定的變量「" * ARGSValue * "」不是一個函數類型的變量.");
                                    # global do_Function = Core.nothing;  # 置空;
                                    global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                end
                            else
                                println("傳入的參數，指定的變量「" * ARGSValue * "」未定義.");
                                # global do_Function = Core.nothing;  # 置空;
                                global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            end

                            # try
                            #     if length(methods(do_Request)) > 0
                            #         global do_Function = do_Request;
                            #     else
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     end
                            # catch err
                            #     # println(err);
                            #     # println(Base.typeof(err));
                            #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
                            #     if Core.isa(err, Core.UndefVarError)
                            #         println(err.var, " not defined.");
                            #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     else
                            #         println(err);
                            #     end
                            # finally
                            #     # global do_Function = Core.nothing;  # 置空;
                            #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            # end
                        end

                        if ARGSValue === "do_Response"

                            # 使用函數 Base.@isdefined(do_Response) 判斷 do_Response 變量是否已經被聲明過;
                            if Base.@isdefined(do_Response)
                                # 使用 Core.isa(do_Response, Function) 函數判斷「元素(變量實例)」是否屬於「集合(變量類型集)」之間的關係，使用 Base.typeof(do_Response) <: Function 方法判斷「集合」是否包含於「集合」之間的關係，使用 Base.typeof(do_Response) <: Function 方法判別 do_Response 變量的類型是否包含於函數Function類型，符號 <: 表示集合之間的包含於的意思，比如 Int64 <: Real === true，函數 Base.typeof(a) 返回的是變量 a 的直接類型值;
                                # 函數實例（變量）的直接變量類型(集合)名為 Base.typeof(Fun_Name)，所有函數的直接類型集又都包含於總的函數Function類型集:
                                # 即：sum ∈ Base.typeof(sum) ⊆ Function 和 "abc" ∈ Core.String ⊆ AbstraclString 和 2 ∈ Int64 ⊆ Real 等;
                                if Base.typeof(do_Response) <: Function
                                    global do_Function = do_Response;
                                else
                                    println("傳入的參數，指定的變量「" * ARGSValue * "」不是一個函數類型的變量.");
                                    # global do_Function = Core.nothing;  # 置空;
                                    global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                                end
                            else
                                println("傳入的參數，指定的變量「" * ARGSValue * "」未定義.");
                                # global do_Function = Core.nothing;  # 置空;
                                global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            end

                            # try
                            #     if length(methods(do_Response)) > 0
                            #         global do_Function = do_Response;
                            #     else
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     end
                            # catch err
                            #     # println(err);
                            #     # println(Base.typeof(err));
                            #     # 使用 Core.isa(err, Core.UndefVarError) 函數判斷 err 的類型是否爲 Core.UndefVarError;
                            #     if Core.isa(err, Core.UndefVarError)
                            #         println(err.var, " not defined.");
                            #         println("傳入的參數，指定的函數「" * Base.string(err.var) * "」未定義.");
                            #         # global do_Function = Core.nothing;  # 置空;
                            #         global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            #     else
                            #         println(err);
                            #     end
                            # finally
                            #     # global do_Function = Core.nothing;  # 置空;
                            #     # global do_Function = (argument) -> begin argument; end;  # 匿名函數，直接返回傳入參數做返回值;
                            # end
                        end

                        # if ARGSValue !== "do_data" && ARGSValue !== "do_data"
                        #     # global do_Function = Core.nothing;  # 置空;
                        #     global do_Function = (argument) -> argument;  # 匿名函數，直接返回傳入參數做返回值;
                        # end

                        # print("do Function: ", do_Function, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "host"
                        global host = ARGSValue;  # 用於輸出傳值的媒介目錄 "../temp/";
                        if Base.string(host) === "::0" || Base.string(host) === "::1" || Base.string(host) === "::" || Base.string(host) === "0" || Base.string(host) === "1"
                            # || CheckIP(Base.string(host)) === "IPv6"
                            global host = Sockets.IPv6(host);  # Sockets.IPv6(0);  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv6(0);  # "::0" or "::1" or "localhost"; 監聽主機域名 Host domain name;
                        elseif Base.string(host) === "0.0.0.0" || Base.string(host) === "127.0.0.1"
                            # || CheckIP(Base.string(host)) === "IPv4"
                            global host = Sockets.IPv4(host);  # Sockets.IPv4("0.0.0.0");  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv4("0.0.0.0");  # "0.0.0.0" or "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
                        elseif Base.string(host) === "localhost"
                            global host = Sockets.IPv6(0);  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = Sockets.IPv4("0.0.0.0");  # "::1";  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
                        else
                            println("Error: host IP [ " * Base.string(host) * " ] unrecognized.");
                            # return false
                        end
                        # print("host: ", Base.string(host), "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "IPVersion"
                        global IPVersion = ARGSValue;  # "IPv6"、"IPv4";
                        # print("IP Version: ", IPVersion, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "port"
                        global port = ARGSValue;  # Core.UInt8(5000),  # 0 ~ 65535， 監聽埠號（端口）;
                        global port = Base.parse(Core.UInt64, port);
                        # print("port: ", Base.string(port), "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "key"
                        if Base.string(ARGSValue) === "nothing" || Base.string(ARGSValue) === ""
                            global key = "";
                            # global key = Core.nothing;
                        else
                            global key = Base.string(ARGSValue);  # 用於接收傳值的媒介文檔 "../temp/intermediary_write_Node.txt";
                        end
                        # print("key: ", key, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "session"
                        # global session = ARGSValue;  # 用於輸入傳值的媒介目錄 "../temp/";
                        # g = Base.Meta.parse(Base.string(ARGSIArray[1]) * Base.string(ARGSValue));
                        g = Base.Meta.parse("session=" * Base.string(ARGSValue));
                        Base.MainInclude.eval(g);
                        # print("session: ", session, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "isConcurrencyHierarchy"
                        global isConcurrencyHierarchy = ARGSValue;  # "Tasks" || "Multi-Threading" || "Multi-Processes"; # 選擇具體執行功能的函數的并發層級（多協程、多綫程、多進程）;
                        # print("isConcurrencyHierarchy: ", isConcurrencyHierarchy, "\n");
                        # 當 isConcurrencyHierarchy = "Multi-Threading" 時，必須在啓動之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程;
                        # 即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl
                        # 即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl
                        # println(Base.Threads.nthreads()); # 查看當前可用的綫程數目;
                        # println(Base.Threads.threadid()); # 查看當前綫程 ID 號;
                        continue;
                    end

                    if ARGSIArray[1] === "Authorization"
                        global Authorization = ARGSValue;  # 客戶端發送的請求頭中的 Authorizater 參數值;
                        # print("Authorization: ", Authorization, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "Cookie"
                        global Cookie = ARGSValue;  # 客戶端發送的請求頭中的 Cookie 參數值;
                        # print("Cookie: ", Cookie, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "URL"
                        global URL = ARGSValue;
                        # print("URL: ", URL, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "proxy"
                        global proxy = ARGSValue;
                        # print("Proxy: ", proxy, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "Referrer"
                        global Referrer = ARGSValue;
                        # print("Referrer: ", Referrer, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "query"
                        # https://github.com/JuliaIO/JSON.jl
                        # 導入第三方擴展包「JSON」，用於轉換JSON字符串為字典 Base.Dict 對象，需要在控制臺先安裝第三方擴展包「JSON」：julia> using Pkg; Pkg.add("JSON") 成功之後才能使用;
                        # s = "{\"a_number\" : 5.0, \"an_array\" : [\"string\", 9]}"
                        # j = JSONparse(s)  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
                        # # j = JSON.parse(s)  # 第三方 JSON 庫中的 JSON.parse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
                        # Dict{AbstractString,Any} with 2 entries:
                        #     "an_array" => {"string",9}
                        #     "a_number" => 5.0
                        global query = JSONparse(ARGSValue);  # 自定義的 JSONparse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
                        # global query = JSON.parse(ARGSValue);  # 第三方 JSON 庫中的 JSON.parse() 函數，將 JSON 字符串轉換爲 Julia 字典（Dict）;
                        # print("query: ", ARGSValue, "\n");
                        # print("query: ", "\n");
                        # print(query);
                        continue;
                    end

                    if ARGSIArray[1] === "readtimeout"
                        # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global readtimeout = Base.parse(Core.Int, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(Int)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                        # print("Read Timeout: ", readtimeout, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "connecttimeout"
                        # CheckString(ARGSValue, 'arabic_numerals');  # 自定義函數檢查輸入合規性;
                        # global is_monitor = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global connect_timeout = Base.parse(Core.Int, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換無符號的短整型(Int)類型的變量，os.cpus().length 創建子進程 worker 數目等於物理 CPU 數目，使用"os"庫的方法獲取本機 CPU 數目;
                        # print("Connect Timeout: ", connect_timeout, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "verbose"
                        # global verbose = Base.Meta.parse(ARGSValue);  # 使用 Base.Meta.parse() 將字符串類型(Core.String)變量解析為可執行的代碼語句;
                        global verbose = Base.parse(Core.Bool, ARGSValue);  # 使用 Base.parse() 將字符串類型(Core.String)變量轉換為布爾型(Bool)的變量，用於判別執行一次還是持續監聽的開關 "true / false";
                        # print("verbose: ", verbose, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "requestFrom"
                        global requestFrom = ARGSValue;  # 客戶端發送的請求頭中的 From 參數值;
                        # print("requestFrom: ", requestFrom, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "requestPath"
                        global requestPath = ARGSValue;
                        # print("requestPath: ", requestPath, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "requestMethod"
                        global requestMethod = ARGSValue;
                        # print("requestMethod: ", requestMethod, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "requestProtocol"
                        global requestProtocol = ARGSValue;
                        # print("requestProtocol: ", requestProtocol, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "postData"
                        # global postData = ARGSValue;  # 用於輸入傳值的媒介目錄 "../temp/";
                        # g = Base.Meta.parse(Base.string(ARGSIArray[1]) * Base.string(ARGSValue));
                        g = Base.Meta.parse("postData=" * Base.string(ARGSValue));
                        Base.MainInclude.eval(g);
                        # print("postData: ", postData, "\n");
                        continue;
                    end

                    if ARGSIArray[1] === "webPath"
                        global webPath = ARGSValue;  # 用於輸入服務器的根目錄 "../";
                        # print("webPath: ", webPath, "\n");
                        continue;
                    end
                end
            end
        end
    end
end

result_Array = Core.nothing;
# result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
if interface_Function_name_str === "interface_File_Monitor"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = interface_Function(
        is_monitor = is_monitor,  # 用於判別是執行一次，還是啓動監聽服務，持續監聽目標文檔，false 值表示只執行一次，true 值表示啓動監聽服務器看守進程持續監聽;
        monitor_file = monitor_file,  # 用於接收傳值的媒介文檔;
        monitor_dir = monitor_dir,  # 用於輸入傳值的媒介目錄;
        do_Function = do_Function_data,  # do_Function,  # 用於接收執行數據處理功能的函數;
        output_dir = output_dir,  # 用於輸出傳值的媒介目錄;
        output_file = output_file,  # 用於輸出傳值的媒介文檔;
        to_executable = to_executable,  # 用於對返回數據執行功能的解釋器二進制可執行檔;
        to_script = to_script,  # 用於對返回數據執行功能的被調用的脚本文檔;
        temp_cache_IO_data_dir = temp_cache_IO_data_dir,  # 用於暫存傳入傳出數據的臨時媒介文件夾;
        number_Worker_threads = number_Worker_threads,  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目;
        time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        read_file_do_Function = read_file_do_Function,  # 從指定的硬盤文檔讀取數據字符串，並調用相應的數據處理函數處理數據，然後將處理得到的結果再寫入指定的硬盤文檔;
        monitor_file_do_Function = monitor_file_do_Function,  # 自動監聽指定的硬盤文檔，當硬盤指定目錄出現指定監聽的文檔時，就調用讀文檔處理數據函數;
        isMonitorThreadsOrProcesses = isMonitorThreadsOrProcesses,  # 0 || "0" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        isDoTasksOrThreads = isDoTasksOrThreads # "Tasks" || "Multi-Threading"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
elseif interface_Function_name_str === "interface_TCP_Server"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = interface_Function(
        host = host,  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
        port = port,  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
        do_Function = do_Function_Request,  # do_Function,  # do_Request,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request_root_directory";
        key = key,  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
        session = session,  # ::Base.Dict{Core.String, Core.Any}("request_Key->username:password" => Key),  # 保存網站的 Session 數據;
        number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
        time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        # total_worker_called_number = total_worker_called_number,  # Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
        TCP_Server = TCP_Server
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
elseif interface_Function_name_str === "interface_http_Server"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = interface_Function(
        host = host,  # ::Core.Union{Core.String, Sockets.IPv6, Sockets.IPv4} = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
        port = port,  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
        do_Function = do_Function_Request,  # do_Function,  # do_Request,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Request_root_directory";
        key = key,  # ::Core.String = "username:password",  # "username:password" 自定義的訪問網站簡單驗證用戶名和密碼;
        session = session,  # ::Base.Dict{Core.String, Core.Any}("request_Key->username:password" => Key),  # 保存網站的 Session 數據;
        number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Base.Sys.CPU_THREADS,  # Core.UInt8(0)，創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
        time_sleep = time_sleep,  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        readtimeout = readtimeout,  # 客戶端請求數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
        verbose = verbose,  # 將連接資訊記錄到輸出到顯示器 Base.stdout 標準輸出流，log connection information to stdout;
        isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        # total_worker_called_number = total_worker_called_number,  # Base.Dict{Core.String, Core.UInt64}();  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
        http_Server = http_Server
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
elseif interface_Function_name_str === "interface_TCP_Client"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = TCP_Client(
        host,  # ::Core.String = "127.0.0.1",  # "0.0.0.0" or "localhost"; 監聽主機域名 Host domain name;
        port;  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String} = 8000, # 0 ~ 65535， 監聽埠號（端口）;
        IPVersion=IPVersion,  # "IPv6"、"IPv4";
        postData=postData,  # ::Core.Union{Core.String, Base.Dict} = "";  # Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
        URL=URL,  # ::Core.String = "",
        requestPath=requestPath,  # ::Core.String = "/",
        requestMethod=requestMethod,  # ::Core.String = "GET",  # "POST",  # "GET"; # 請求方法;
        requestProtocol=requestProtocol,  # ::Core.String = "HTTP",
        # time_out=time_out,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        Authorization=Authorization,  # ::Core.String = ":",  # "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
        Cookie=Cookie,  # ::Core.String = "",  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
        requestFrom=requestFrom,  # ::Core.String = "user@email.com",
        # do_Function=do_Function,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
        # session=session,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => TCP_Server.key),  # 保存網站的 Session 數據;
        # number_Worker_threads=number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.UInt8(0),  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
        # time_sleep=time_sleep,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        # isConcurrencyHierarchy=isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        # worker_queues_Dict=worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        # total_worker_called_number=total_worker_called_number,  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}()  # 記錄每個綫程纍加的被調用運算的總次數;
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
elseif interface_Function_name_str === "interface_http_Client"
    # result_Array = Array{Union{Core.Bool, Core.Float64, Core.Int64, Core.String},1}(Core.nothing, 3);
    result_Array = http_Client(
        host,  # ::Core.String,  # "127.0.0.1" or "localhost"; 監聽主機域名 Host domain name;
        port;  # ::Core.Union{Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8, Core.String};  # 0 ~ 65535，監聽埠號（端口）;
        IPVersion = IPVersion,  # "IPv6"、"IPv4";
        postData = postData,  # ::Core.Union{Core.String, Base.Dict} = "",  # Base.Dict{Core.String, Core.Any}("Client_say" => "Julia-1.6.2 Sockets.connect."),  # postData::Core.Union{Core.String, Base.Dict{Core.Any, Core.Any}}，"{\"Client_say\":\"" * "No request Headers Authorization and Cookie received." * "\",\"time\":\"" * Base.string(now_date) * "\"}";
        proxy = proxy,  # ::Core.String = Core.nothing,  # 當需要通過代理服務器僞裝發送請求時，代理服務器的網址 URL 值字符串，pass request through a proxy given as a url; alternatively, the , , , , and environment variables are also detected/used; if set, they will be used automatically when making requests.http_proxyHTTP_PROXYhttps_proxyHTTPS_PROXYno_proxy;
        requestPath = requestPath,  # ::Core.String = "/",
        requestProtocol = requestProtocol,  # ::Core.String = "HTTP",
        query = query,  # ::Base.Dict{Core.String, Core.String} = Core.nothing,  # Base.Dict{Core.String, Core.String}(),  # Base.Dict{Core.String, Core.String}("ID" => "23"),  # 請求查詢 key => value 字典，a or of key => values to be included in the urlPairDict;
        URL = URL,  # ::Core.String = "",  # Base.string(http_Client.requestProtocol) * "://" * Base.convert(Core.String, Base.strip((Base.split(Base.string(http_Client.Authorization), ' ')[2]))) * "@" * Base.string(http_Client.host) * ":" * Base.string(http_Client.port) * Base.string(http_Client.requestPath),  # 請求網址 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
        requestMethod = requestMethod,  # ::Core.String = "GET",  # "POST",  # "GET"; # 請求方法;
        # time_out = time_out,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        readtimeout = readtimeout,  # ::Core.Int = Core.Int(0),  # 服務器響應數據讀取超時，單位：（秒），close the connection if no data is received for this many seconds. Use readtimeout = 0 to disable;
        connect_timeout = connect_timeout,  # ::Core.Int = Core.Int(30),  # 服務器鏈接超時，單位：（秒），close the connection after this many seconds if it is still attempting to connect. Use to disable.connect_timeout = 0;
        Authorization = Authorization,  # ::Core.String = ":",  # "Basic username:password" -> "Basic dXNlcm5hbWU6cGFzc3dvcmQ=";
        Basicbasicauth = Basicbasicauth,  # ::Core.Bool = true,  # 設置從請求網址 URL 中解析截取請求的賬號和密碼，Basic authentication is detected automatically from the provided url's (in the form userinfoscheme://user:password@host) and adds the 「Authorization:」 header; this can be disabled by passing Basicbasicauth = false;
        Cookie = Cookie,  # ::Core.String = "",  # "Session_ID=request_Key->username:password" -> "Session_ID=cmVxdWVzdF9LZXktPnVzZXJuYW1lOnBhc3N3b3Jk";
        Referrer = Referrer,  # ::Core.String = http_Client.URL,  # 請求的來源網頁 URL "http://username:password@127.0.0.1:8081/index?a=1&b=2&c=3#a1";
        requestFrom = requestFrom,  # ::Core.String = "user@email.com",
        # do_Function = do_Function,  # (argument) -> begin argument; end,  # 匿名函數對象，用於接收執行對根目錄(/)的 GET 請求處理功能的函數 "do_Response";
        # session = session,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}("request_Key->username:password" => http_Server.key),  # 保存網站的 Session 數據;
        # number_Worker_threads = number_Worker_threads,  # ::Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.UInt8(0),  # 創建子進程 worker 數目等於物理 CPU 數目，使用 Base.Sys.CPU_THREADS 常量獲取本機 CPU 數目，自定義函數檢查輸入合規性 CheckString(number_Worker_threads, 'arabic_numerals');
        # time_sleep = time_sleep,  # ::Core.Union{Core.Float64, Core.Float32, Core.Float16, Core.Int, Core.Int128, Core.Int64, Core.Int32, Core.Int16, Core.Int8, Core.UInt, Core.UInt128, Core.UInt64, Core.UInt32, Core.UInt16, Core.UInt8} = Core.Float16(0),  # 監聽文檔輪詢時使用 sleep(time_sleep) 函數延遲時長，單位秒;
        # isConcurrencyHierarchy = isConcurrencyHierarchy,  # ::Core.String = "Tasks",  # "Tasks" || "Multi-Threading" || "Multi-Processes"，當值為 "Multi-Threading" 時，必須在啓動 Julia 解釋器之前，在控制臺命令行修改環境變量：export JULIA_NUM_THREADS=4(Linux OSX) 或 set JULIA_NUM_THREADS=4(Windows) 來設置啓動 4 個綫程，即 Windows 系統啓動方式：C:\> set JULIA_NUM_THREADS=4 C:/Julia/bin/julia.exe ./Interface.jl，即 Linux 系統啓動方式：root@localhost:~# export JULIA_NUM_THREADS=4 /usr/Julia/bin/julia ./Interface.jl;
        # worker_queues_Dict = worker_queues_Dict,  # ::Base.Dict{Core.String, Core.Any} = Base.Dict{Core.String, Core.Any}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        # total_worker_called_number = total_worker_called_number,  # ::Base.Dict{Core.String, Core.UInt64} = Base.Dict{Core.String, Core.UInt64}(),  # 記錄每個綫程纍加的被調用運算的總次數;
        response_stream = response_stream,  # Core.nothing,  # Base.IOBuffer(),  # 設置接收到的響應值類型爲二進制字節流 IO 對象，a writeable stream or any -like type for which is defined. The response body will be written to this stream instead of returned as a .IOIOTwrite(T, AbstractVector{UInt8})Base.Vector{UInt8};
        cookiejar = cookiejar  # ::HTTP.CookieJar = HTTP.CookieJar()  # Cookie Persistence; # HTTP.Cookies.setcookies!(mycookiejar, http_response.message.url, http_response.message.headers);  # HTTP.Cookies.setcookies!(jar::CookieJar, url::URI, headers::Headers);  # HTTP.Cookies.getcookies!(mycookiejar, http_response.message.url);  # HTTP.Cookies.getcookies!(jar::CookieJar, url::URI);
    );
    # println(typeof(result_Array));
    # println(result_Array[1]);
    # println(result_Array[2]);
    # println(result_Array[3]);
else
end
# # result_Array = interface_Function();
# println(typeof(result_Array));
# println(result_Array[1]);
# println(result_Array[2]);
# println(result_Array[3]);

# 需要先加載 Julia 原生的 Dates 模組：using Dates;
# 函數 Dates.now() 返回當前日期時間對象 2021-06-28T12:12:50.544，使用 Base.string(Dates.now()) 方法，可以返回當前日期時間字符串 2021-06-28T12:12:50.544。
# 函數 Dates.time() 當前日期時間的 Unix 值 1.652232489777e9，UNIX 時間，或稱爲 POSIX 時間，是 UNIX 或類 UNIX 系統使用的時間表示方式：從 UTC 1970 年 1 月 1 日 0 時 0 分 0 秒起至現在的縂秒數，不考慮閏秒。
# 函數 Dates.unix2datetime(Dates.time()) 將 Unix 時間轉化爲日期（時間）對象，使用 Base.string(Dates.unix2datetime(Dates.time())) 方法，可以返回當前日期時間字符串 2021-06-28T12:12:50。
return_file_creat_time = Dates.now();  # Base.string(Dates.now()) 返回當前日期時間字符串 2021-06-28T12:12:50.544，需要先加載原生 Dates 包 using Dates;
# println(Base.string(Dates.now()))

result_text = "";
if interface_Function_name_str === "Interface_File_Monitor"

    if is_monitor === true
        result_text = "code:0";
    end

    if is_monitor === false
        if Base.typeof(result_Array) <: Core.Array && Base.length(result_Array) >= 3 && Core.isa(result_Array[2], Core.String) && Core.isa(result_Array[3], Core.String) && Core.isa(do_Function_name_str_data, Core.String) && do_Function_name_str_data !== ""
            return_info_JSON = Base.Dict{Core.String, Core.Any}(
                "Server_say" => Base.Dict{Core.String, Core.Any}(
                    "output_file" => Base.string(result_Array[2]),
                    "monitor_file" => Base.string(result_Array[3]),
                    "do_Function" => Base.string(do_Function_name_str_data)
                ),
                "time" => Base.string(return_file_creat_time)
            );
            result_text = join(Base.string(["code:0", JSONstring(return_info_JSON)]), "\n");
            # result_text = '{"Server_say":{"output_file":"' * Base.string(result_Array[2]) * '","monitor_file":"' * Base.string(result_Array[3]) * '","do_Function":"' * Base.string(do_Function_name_str_data) * '"},"time":"' * Base.string(return_file_creat_time) * '"}'
        elseif Base.typeof(result_Array) <: Core.Array && Base.length(result_Array) >= 3 && Core.isa(result_Array[2], Core.String) && Core.isa(result_Array[3], Core.String)
            return_info_JSON = Base.Dict{Core.String, Core.Any}(
                "Server_say" => Base.Dict{Core.String, Core.Any}(
                    "output_file" => Base.string(result_Array[2]),
                    "monitor_file" => Base.string(result_Array[3]),
                    "do_Function" => ""
                ),
                "time" => Base.string(return_file_creat_time)
            );
            result_text = join(Base.string(["code:0", JSONstring(return_info_JSON)]), "\n");
            # result_text = '{"Server_say":{"output_file":"' * Base.string(result_Array[2]) * '","monitor_file":"' * Base.string(result_Array[3]) * '","do_Function":""},"time":"' * Base.string(return_file_creat_time) * '"}'
        else
            result_text = "code:-1";
        end
    end

elseif interface_Function_name_str === "interface_TCP_Server"
    result_text = "code:0";
elseif interface_Function_name_str === "Interface_http_Server"
    result_text = "code:0";
elseif interface_Function_name_str === "interface_TCP_Client"
    # println(JSONparse(result_Array[3]));
    println(result_Array[1]);
    println(result_Array[2]);
    println(result_Array[3]);
    # result_text = join(Base.string(["code:0", JSONstring(result_Array)]), "\n");
    # result_text = JSONstring(result_Array);
    result_text = "code:0";
elseif interface_Function_name_str === "interface_http_Client"
    # println(JSONparse(result_Array[3]));
    println(result_Array[1]);
    println(result_Array[2]);
    println(result_Array[3]);
    # result_text = join(Base.string(["code:0", JSONstring(result_Array)]), "\n");
    # result_text = JSONstring(result_Array);
    result_text = "code:0";
else
end
# 將運算結果保存的目標文檔的信息，寫入控制臺標準輸出（顯示器），便於使主調程序獲取完成信號;
println(result_text);  # 將運算結果寫到操作系統控制臺;
