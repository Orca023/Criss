#!/bin/bash
# #!/data/data/com.termux/files/usr/bin/bash
# #!C:/Git/bin/bash.exe

# 使用説明：

# Title: Startup Julia or Python or Nodejs statistical server
# Author: 趙健
# E-mail: 283640621@qq.com
# Telephont number: +86 18604537694
# E-mail: chinaorcaz@gmail.com
# Date: 歲在丙申
# Operating system: Linux5.13.0-Android11-Termux0.118-Ubuntu22.04 arm64-aarch64
# Operating system: Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30

# 需要在：Android11-Termux0.118 系統的控制臺命令列使用下面的指令，將 shell 的脚本文檔權限修改爲：可執行權限，然後才能被啓動運行;
# ~ $ chmod a+x /data/data/com.termux/files/home/Criss/startServer.sh
# 然後在控制臺命令列，再使用如下指令，啓動執行;
# ~ $ /data/data/com.termux/files/usr/bin/bash /data/data/com.termux/files/home/Criss/startServer.sh configFile=/data/data/com.termux/files/home/Criss/config.txt executableFile=/data/data/com.termux/files/usr/julia/julia-1.10.3/bin/julia interpreterFile=-p,4,--project=/data/data/com.termux/files/home/Criss/jl/ scriptFile=/data/data/com.termux/files/home/Criss/jl/application.jl configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/,monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/Criss/Intermediary/,output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/

# 需要在：Linux5.13.0-Android11-Termux0.118-Ubuntu22.04 系統的控制臺命令列使用下面的指令，將 shell 的脚本文檔權限修改爲：可執行權限，然後才能被啓動運行;
# root@localhost:~# chmod a+x /home/Criss/startServer.sh
# 然後在控制臺命令列，再使用如下指令，啓動執行;
# root@localhost:~# /bin/bash /home/Criss/startServer.sh configFile=/home/Criss/config.txt executableFile=/bin/julia interpreterFile=-p,4,--project=/home/Criss/jl/ scriptFile=/home/Criss/jl/application.jl configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/Criss/temp/

# 需要在 Windows 系統 cmd 控制臺命令列使用下面的指令，將 shell 的脚本文檔權限修改爲：可執行權限，然後才能被啓動運行；並且需要事先已經在 Windows 系統安裝配置成功：C:/Git/bin/bash.exe 軟體;
# C:\Criss> chmod a+x C:/Criss/startServer.sh
# 然後在控制臺命令列，再使用如下指令，啓動執行;
# C:\Criss> C:/Git/bin/bash.exe C:/Criss/startServer.sh configFile=C:/Criss/config.txt executableFile=C:/Criss/Julia/Julia-1.9.3/bin/julia.exe interpreterFile=-p,4,--project=C:/Criss/jl/ scriptFile=C:/Criss/jl/application.jl configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=C:/Criss/Intermediary/,monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt,output_dir=C:/Criss/Intermediary/,output_file=C:/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=C:/Criss/temp/

clear

NoteVersion_1="Startup Julia or Python or Nodejs server v20161211"
NoteVersion_2="Android11-Termux0.118 arm64 aarch64"
# NoteVersion_2="Linux5.13.0-Android11-Termux0.118-Ubuntu22.04 arm64 aarch64"
# NoteVersion_2="Windows10 x86_64 Inter(R)-Core(TM)-m3-6Y30"
NoteVersion_3="283640621@qq.com"
NoteVersion_4="+8618604537694"
NoteVersion_5="弘毅"
NoteVersion_6="歲在丙申"

NoteHelp_1="--help -h --version -v"
NoteHelp_2="configFile=/data/data/com.termux/files/home/Criss/config.txt"
# NoteHelp_2="configFile=/home/Criss/config.txt"
# NoteHelp_2="configFile=C:/Criss/config.txt"
NoteHelp_3="executableFile=/data/data/com.termux/files/usr/bin/julia"
# NoteHelp_3="executableFile=/bin/julia"
# NoteHelp_3="executableFile=C:/Criss/Julia/Julia-1.9.3/bin/julia.exe"
NoteHelp_4="interpreterFile=-p,4,--project=/data/data/com.termux/files/home/Criss/jl/"
# NoteHelp_4="interpreterFile=-p,4,--project=/home/Criss/jl/"
# NoteHelp_4="interpreterFile=-p,4,--project=C:/Criss/jl/"
NoteHelp_5="scriptFile=/data/data/com.termux/files/home/Criss/jl/application.jl"
# NoteHelp_5="scriptFile=/home/Criss/jl/application.jl"
# NoteHelp_5="scriptFile=C:/Criss/jl/application.jl"
NoteHelp_6="configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/,monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/Criss/Intermediary/,output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/,isMonitorThreadsOrProcesses=0,isDoTasksOrThreads=Tasks,to_executable=/data/data/com.termux/files/home/Criss/c2exe.exe,to_script=configFile=/data/data/com.termux/files/home/Criss/config.txt"
# NoteHelp_6="configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/Criss/temp/,isMonitorThreadsOrProcesses=0,isDoTasksOrThreads=Tasks,to_executable=/home/Criss/c2exe.exe,to_script=configFile=/home/Criss/config.txt"
# NoteHelp_6="configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=C:/Criss/Intermediary/,monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt,output_dir=C:/Criss/Intermediary/,output_file=C:/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=C:/Criss/temp/,isMonitorThreadsOrProcesses=0,isDoTasksOrThreads=Tasks,to_executable=C:/Criss/c2exe.exe,to_script=configFile=C:/Criss/config.txt"
NoteHelp_7="isBlock=true"
NoteHelp_8="executableFile=/data/data/com.termux/files/home/Criss/py/Scripts/python"
# NoteHelp_8="executableFile=/home/Criss/py/Scripts/python"
# NoteHelp_8="executableFile=C:/Criss/py/Scripts/python.exe"
NoteHelp_9="executableFile=/data/data/com.termux/files/usr/bin/python"
# NoteHelp_9="executableFile=/bin/python3"
# NoteHelp_9="executableFile=C:/Criss/Python/Python311/python.exe"
NoteHelp_10="scriptFile=/data/data/com.termux/files/home/Criss/py/application.py"
# NoteHelp_10="scriptFile=/home/Criss/py/application.py"
# NoteHelp_10="scriptFile=C:/Criss/py/application.py"
NoteHelp_11="configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=False,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/,monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/Criss/Intermediary/,output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/,is_Monitor_Concurrent=Multi-Threading,to_executable=/data/data/com.termux/files/home/Criss/c2exe.exe,to_script=configFile=/data/data/com.termux/files/home/Criss/config.txt"
# NoteHelp_11="configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=False,time_sleep=0.02,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=/home/Criss/temp/,is_Monitor_Concurrent=Multi-Threading,to_executable=/home/Criss/c2exe.exe,to_script=configFile=/home/Criss/config.txt"
# NoteHelp_11="configInstructions=host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=False,time_sleep=0.02,monitor_dir=C:/Criss/Intermediary/,monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt,output_dir=C:/Criss/Intermediary/,output_file=C:/Criss/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=C:/Criss/temp/,is_Monitor_Concurrent=Multi-Threading,to_executable=C:/Criss/c2exe.exe,to_script=configFile=C:/Criss/config.txt"
NoteHelp_12="executableFile=/data/data/com.termux/files/usr/bin/node"
# NoteHelp_12="executableFile=/bin/node"
# NoteHelp_12="executableFile=C:/Criss/Nodejs/node.exe"
NoteHelp_13="scriptFile=/data/data/com.termux/files/home/Criss/js/application.js"
# NoteHelp_13="scriptFile=/home/Criss/js/application.js"
# NoteHelp_13="scriptFile=C:/Criss/js/application.js"
NoteHelp_14="configInstructions=host=::0,port=10001,Key=username:password,number_cluster_Workers=0,is_monitor=false,delay=20,monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/,monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/Criss/Intermediary/,output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Nodejs.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/,number_Worker_process=0,to_executable=/data/data/com.termux/files/home/Criss/c2exe.exe,to_script=configFile=/data/data/com.termux/files/home/Criss/config.txt"
# NoteHelp_14="configInstructions=host=::0,port=10001,Key=username:password,number_cluster_Workers=0,is_monitor=false,delay=20,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Nodejs.txt,temp_cache_IO_data_dir=/home/Criss/temp/,number_Worker_process=0,to_executable=/home/Criss/c2exe.exe,to_script=configFile=/home/Criss/config.txt"
# NoteHelp_14="configInstructions=host=::0,port=10001,Key=username:password,number_cluster_Workers=0,is_monitor=false,delay=20,monitor_dir=C:/Criss/Intermediary/,monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt,output_dir=C:/Criss/Intermediary/,output_file=C:/Criss/Intermediary/intermediary_write_Nodejs.txt,temp_cache_IO_data_dir=C:/Criss/temp/,number_Worker_process=0,to_executable=C:/Criss/c2exe.exe,to_script=configFile=C:/Criss/config.txt"

configFileName="config.txt"
configFile=""
# configFile="/data/data/com.termux/files/home/Criss/config.txt"
# configFile="/home/Criss/config.txt"
# configFile="C:/Criss/config.txt"

CalculationTool="Julia"

# 設置將傳入參數中的逗號字符(,)替換爲空格字符( );
search_string=','
replace_string=' '

executableFileName="py/Scripts/python"
# executableFileName="py/Scripts/python.exe"
# executableFileName="Julia/Julia-1.10.3/bin/julia"
# executableFileName="Julia/Julia-1.10.3/bin/julia.exe"
executableFile=""
# executableFile="/data/data/com.termux/files/usr/bin/python"
# executableFile="/data/data/com.termux/files/home/Criss/py/Scripts/python"
# executableFile="/bin/python3"
# executableFile="/home/Criss/py/Scripts/python"
# executableFile="C:/Criss/Python/Python311/python.exe"
# executableFile="C:/Criss/py/Scripts/python.exe"
# executableFile="/usr/julia/julia-1.10.3/bin/julia"
# executableFile="C:/Criss/Julia/Julia-1.9.3/bin/julia.exe"

interpreterFileName="py/"
# interpreterFileName="jl/"
interpreterFile=""
# interpreterFile="--project=/data/data/com.termux/files/home/Criss/py/"
# interpreterFile="--project=/home/Criss/py/"
# interpreterFile="--project=C:/Criss/py/"
# interpreterFile="-p,4,--project=/data/data/com.termux/files/home/Criss/jl/"
# interpreterFile="-p,4,--project=home/Criss/jl/"
# interpreterFile="-p,4,--project=C:/Criss/jl/"

scriptFileName="py/application.py"
# scriptFileName="jl/application.jl"
scriptFile=""
# scriptFile="/data/data/com.termux/files/home/Criss/py/application.py"
# scriptFile="/home/Criss/py/application.py"
# scriptFile="C:/Criss/py/application.py"
# scriptFile="/data/data/com.termux/files/home/Criss/jl/application.jl"
# scriptFile="/home/Criss/jl/application.jl"
# scriptFile="C:/Criss/jl/application.jl"

configInstructions=""
# configInstructions="host=::0,port=10001,Key=username:password,Is_multi_thread=False,number_Worker_process=0,is_Monitor_Concurrent=0,is_monitor=False,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/,monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/Criss/Intermediary/,output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/"
# configInstructions="host=::0,port=10001,Key=username:password,Is_multi_thread=False,number_Worker_process=0,is_Monitor_Concurrent=0,is_monitor=False,time_sleep=0.02,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Python.txt,temp_cache_IO_data_dir=/home/Criss/temp/"
# configInstructions="host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/,monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/data/data/com.termux/files/home/Criss/Intermediary/,output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/"
# configInstructions="host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=/home/Criss/Intermediary/,monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt,output_dir=/home/Criss/Intermediary/,output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=/home/Criss/temp/"
# configInstructions="host=::0,port=10001,key=username:password,number_Worker_threads=1,isConcurrencyHierarchy=Tasks,is_monitor=false,time_sleep=0.02,monitor_dir=C:/Criss/Intermediary/,monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt,output_dir=C:/Criss/Intermediary/,output_file=C:/Criss/Intermediary/intermediary_write_Julia.txt,temp_cache_IO_data_dir=C:/Criss/temp/"

shellCodeScript=""
# shellCodeScript="/data/data/com.termux/files/usr/bin/python /data/data/com.termux/files/home/Criss/py/application.py host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=False time_sleep=0.02 monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/ monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/data/data/com.termux/files/home/Criss/Intermediary/ output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/ is_Monitor_Concurrent=Multi-Threading to_executable=/data/data/com.termux/files/home/Criss/c2exe.exe to_script=configFile=/data/data/com.termux/files/home/Criss/config.txt"
# shellCodeScript="/data/data/com.termux/files/home/Criss/py/Scripts/python /data/data/com.termux/files/home/Criss/py/application.py host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=False time_sleep=0.02 monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/ monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/data/data/com.termux/files/home/Criss/Intermediary/ output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/ is_Monitor_Concurrent=Multi-Threading to_executable=/data/data/com.termux/files/home/Criss/c2exe.exe to_script=configFile=/data/data/com.termux/files/home/Criss/config.txt"
# shellCodeScript="/bin/python3 /home/Criss/py/application.py host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=False time_sleep=0.02 monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/home/Criss/temp/ is_Monitor_Concurrent=Multi-Threading to_executable=/home/Criss/c2exe.exe to_script=configFile=/home/Criss/config.txt"
# shellCodeScript="/home/Criss/py/Scripts/python /home/Criss/py/application.py host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=False time_sleep=0.02 monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Python.txt temp_cache_IO_data_dir=/home/Criss/temp/ is_Monitor_Concurrent=Multi-Threading to_executable=/home/Criss/c2exe.exe to_script=configFile=/home/Criss/config.txt"
# shellCodeScript="/data/data/com.termux/files/usr/bin/julia --project=/data/data/com.termux/files/home/Criss/jl/ /data/data/com.termux/files/home/Criss/jl/application.jl host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/ monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/data/data/com.termux/files/home/Criss/Intermediary/ output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/"
# shellCodeScript="/data/data/com.termux/files/usr/bin/julia -p 4 --project=/data/data/com.termux/files/home/Criss/jl/ /data/data/com.termux/files/home/Criss/jl/application.jl host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/data/data/com.termux/files/home/Criss/Intermediary/ monitor_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/data/data/com.termux/files/home/Criss/Intermediary/ output_file=/data/data/com.termux/files/home/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/data/data/com.termux/files/home/Criss/temp/"
# shellCodeScript="/bin/julia --project=/home/Criss/jl/ /home/Criss/jl/application.jl host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/home/Criss/temp/"
# shellCodeScript="/bin/julia -p 4 --project=/home/Criss/jl/ /home/Criss/jl/application.jl host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=/home/Criss/Intermediary/ monitor_file=/home/Criss/Intermediary/intermediary_write_C.txt output_dir=/home/Criss/Intermediary/ output_file=/home/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=/home/Criss/temp/"
# shellCodeScript="C:/Criss/Julia/Julia-1.9.3/bin/julia.exe --project=C:/Criss/jl/ C:/Criss/jl/application.jl host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=C:/Criss/temp/"
# shellCodeScript="C:/Criss/Julia/Julia-1.9.3/bin/julia.exe -p 4 --project=C:/Criss/jl/ C:/Criss/jl/application.jl host=::0 port=10001 key=username:password number_Worker_threads=1 isConcurrencyHierarchy=Tasks is_monitor=false time_sleep=0.02 monitor_dir=C:/Criss/Intermediary/ monitor_file=C:/Criss/Intermediary/intermediary_write_C.txt output_dir=C:/Criss/Intermediary/ output_file=C:/Criss/Intermediary/intermediary_write_Julia.txt temp_cache_IO_data_dir=C:/Criss/temp/"


# 獲取當前工作空間;
work_directory="$(pwd)"
work_directory="$work_directory/"
# echo "Worker directory = $work_directory"
shell_directory="$(cd "$(dirname "$0")" && pwd)"
shell_directory="$shell_directory/"
# echo "Directory(.sh) = $shell_directory"
shell_file="$shell_directory$(basename "$0")"
# echo "File(.sh) = $shell_file"


# 變量賦預設值;
configFile="$shell_directory$configFileName"
# echo "configFile = $configFile"

# executableFile="$shell_directory$executableFileName"
# # echo "executableFile = $executableFile"

# scriptFile="$shell_directory$scriptFileName"
# # echo "scriptFile = $scriptFile"

# interpreterFile="--project=$shell_directory$interpreterFileName"
# # echo "interpreterFile = $interpreterFile"


# # 讀取控制臺命令列傳入的參數;
# echo $#
# echo "$@"
# echo "$0"
# echo "$1"
# Argument="$@"
# echo "$Argument"

# 讀取控制臺命令列傳入的參數：配置文檔（configFile）保存路徑值;
index=0
for indexArgument in "$@"
do
    index=$(expr $index + 1)
    # echo "Argument-$index: $indexArgument"

    # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若否（!）含有等號字符（'='），則如下;
    if ! [[ "$indexArgument" == *"="* ]]; then
        # echo "Unable to find equal sign(=) separator in the $index$: $indexArgument"
        # echo "控制臺命令列傳入的參數中不含等號字符（=）."
        # exit 0

        if [ "$indexArgument" = "--version" ]; then
            echo "$NoteVersion_1"
            echo "$NoteVersion_2"
            echo "$NoteVersion_3"
            echo "$NoteVersion_4"
            echo "$NoteVersion_5"
            echo "$NoteVersion_6"
            exit 0
        elif [ "$indexArgument" = "-v" ]; then
            echo "$NoteVersion_1"
            echo "$NoteVersion_2"
            echo "$NoteVersion_3"
            echo "$NoteVersion_4"
            echo "$NoteVersion_5"
            echo "$NoteVersion_6"
            exit 0
        elif [ "$indexArgument" = "--help" ]; then
            echo "$NoteVersion_1"
            echo "$NoteVersion_2"
            echo "$NoteVersion_3"
            echo "$NoteVersion_4"
            echo "$NoteVersion_5"
            echo "$NoteVersion_6"
            echo -e "\n"
            echo "$NoteHelp_1"
            echo "$NoteHelp_2"
            echo "$NoteHelp_3"
            echo "$NoteHelp_4"
            echo "$NoteHelp_5"
            echo "$NoteHelp_6"
            echo "$NoteHelp_7"
            echo "$NoteHelp_8"
            echo "$NoteHelp_9"
            echo "$NoteHelp_10"
            echo "$NoteHelp_11"
            echo "$NoteHelp_12"
            echo "$NoteHelp_13"
            echo "$NoteHelp_14"
            exit 0
        elif [ "$indexArgument" = "-h" ]; then
            echo "$NoteVersion_1"
            echo "$NoteVersion_2"
            echo "$NoteVersion_3"
            echo "$NoteVersion_4"
            echo "$NoteVersion_5"
            echo "$NoteVersion_6"
            echo -e "\n"
            echo "$NoteHelp_1"
            echo "$NoteHelp_2"
            echo "$NoteHelp_3"
            echo "$NoteHelp_4"
            echo "$NoteHelp_5"
            echo "$NoteHelp_6"
            echo "$NoteHelp_7"
            echo "$NoteHelp_8"
            echo "$NoteHelp_9"
            echo "$NoteHelp_10"
            echo "$NoteHelp_11"
            echo "$NoteHelp_12"
            echo "$NoteHelp_13"
            echo "$NoteHelp_14"
            exit 0
        elif [ "$indexArgument" = "isJulia" ]; then
            CalculationTool="Julia"
            # echo "CalculationTool = $CalculationTool"
            # exit 0
        elif [ "$indexArgument" = "isPython" ]; then
            CalculationTool="Python"
            # echo "CalculationTool = $CalculationTool"
            # exit 0
        else
            configFile="$indexArgument"
            # echo "configFile = $configFile"
            # exit 0
        fi
    fi

    # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若含有等號字符（'='），則如下;
    if [[ "$indexArgument" == *"="* ]]; then

        # Argument_Key="$(echo $indexArgument | cut -f1 -d=)"
        Argument_Key="${indexArgument%%=*}"
        # echo "$Argument_Key"

        # Argument_Value="$(echo $indexArgument | cut -f2 -d=)"
        Argument_Value="${indexArgument#*=}"
        # echo "$Argument_Value"
        # 將傳入參數值字符串中的逗號字符（','）替換爲空格字符（' '）;
        Argument_Value="$(echo "$Argument_Value" | tr ',' ' ')"
        # echo "$Argument_Value"

        # if [ "$Argument_Key" = "configFile" ]; then
        #     configFile="$Argument_Value"
        # fi

        # # if [ "$Argument_Key" = "executableFile" ]; then
        # #     executableFile="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "interpreterFile" ]; then
        # #     interpreterFile="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "scriptFile" ]; then
        # #     scriptFile="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "configInstructions" ]; then
        # #     configInstructions="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "CalculationTool" ]; then
        # #     CalculationTool="$Argument_Value"
        # # fi

        # # if [ "$Argument_Key" = "shellCodeScript" ]; then
        # #     shellCodeScript="$Argument_Value"
        # # fi

        case $Argument_Key in
            configFile) configFile="$Argument_Value";;
            # executableFile) executableFile="$Argument_Value";;
            # interpreterFile) interpreterFile="$Argument_Value";;
            # scriptFile) scriptFile="$Argument_Value";;
            # configInstructions) configInstructions="$Argument_Value";;
            # CalculationTool) CalculationTool="$Argument_Value";;
            # shellCodeScript) shellCodeScript="$Argument_Value";;
            *) # echo "Argument Key: [ $Argument_Key ] unrecognized.";;
        esac

    fi
done
# echo "configFile = $configFile"
# # echo "executableFile = $executableFile"
# # echo "interpreterFile = $interpreterFile"
# # echo "scriptFile = $scriptFile"
# # echo "configInstructions = $configInstructions"
# # echo "CalculationTool = $CalculationTool"
# # echo "shellCodeScript = $shellCodeScript"
Argument_Key=""
Argument_Value=""
index=0


# 讀取控制文檔（config.txt）傳入的參數;
# echo "configFile = $configFile"
if [ -z "$configFile" ]; then
    echo 'Error ( configFile = "" )'
elif ! [ -f "$configFile" ]; then
    echo "Config file ( $configFile ) unrecognized."
else
    echo "configFile = $configFile"
    index=0
    while read line; do
        index=$(expr $index + 1)
        # echo "$index: $line"

        # 判斷是否爲空列;
        if ! [ -z "$line" ]; then

            # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若含有等號字符（'='），則如下;
            if [[ "$line" == *"="* ]]; then

                # Argument_Key="$(echo $line | cut -f1 -d=)"
                Argument_Key="${line%%=*}"
                # echo "$Argument_Key"

                # Argument_Value="$(echo $line | cut -f2 -d=)"
                Argument_Value="${line#*=}"
                # echo "$Argument_Value"
                # 將傳入參數值字符串中的逗號字符（','）替換爲空格字符（' '）;
                Argument_Value="$(echo "$Argument_Value" | tr ',' ' ')"
                # echo "$Argument_Value"

                # # if [ "$Argument_Key" = "configFile" ]; then
                # #     configFile="$Argument_Value"
                # # fi

                # if [ "$Argument_Key" = "executableFile" ]; then
                #     executableFile="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "interpreterFile" ]; then
                #     interpreterFile="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "scriptFile" ]; then
                #     scriptFile="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "configInstructions" ]; then
                #     configInstructions="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "CalculationTool" ]; then
                #     CalculationTool="$Argument_Value"
                # fi

                # if [ "$Argument_Key" = "shellCodeScript" ]; then
                #     shellCodeScript="$Argument_Value"
                # fi

                case $Argument_Key in
                    # configFile) configFile="$Argument_Value";;
                    executableFile) executableFile="$Argument_Value";;
                    interpreterFile) interpreterFile="$Argument_Value";;
                    scriptFile) scriptFile="$Argument_Value";;
                    configInstructions) configInstructions="$Argument_Value";;
                    CalculationTool) CalculationTool="$Argument_Value";;
                    shellCodeScript) shellCodeScript="$Argument_Value";;
                    *) # echo "Argument Key: [ $Argument_Key ] unrecognized.";;
                esac

            fi
        fi
    done < $configFile
    # # echo "configFile = $configFile"
    # echo "executableFile = $executableFile"
    # echo "interpreterFile = $interpreterFile"
    # echo "scriptFile = $scriptFile"
    # echo "configInstructions = $configInstructions"
    # echo "CalculationTool = $CalculationTool"
    # echo "shellCodeScript = $shellCodeScript"
    Argument_Key=""
    Argument_Value=""
    index=0
fi


# # 讀取控制臺命令列傳入的參數;
# echo $#
# echo "$@"
# echo "$0"
# echo "$1"
# Argument="$@"
# echo "$Argument"

# 讀取控制臺命令列傳入的參數：executableFile、interpreterFile、scriptFile、configInstructions、CalculationTool、shellCodeScript
index=0
for indexArgument in "$@"
do
    index=$(expr $index + 1)
    # echo "Argument-$index: $indexArgument"

    # # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若否（!）含有等號字符（'='），則如下;
    # if ! [[ "$indexArgument" == *"="* ]]; then
    #     # echo "Unable to find equal sign(=) separator in the $index$: $indexArgument"
    #     # echo "控制臺命令列傳入的參數中不含等號字符（=）."
    #     # exit 0
    #     if [ "$indexArgument" = "isJulia" ]; then
    #         CalculationTool="Julia"
    #         # echo "CalculationTool = $CalculationTool"
    #         # exit 0
    #     elif [ "$indexArgument" = "isPython" ]; then
    #         CalculationTool="Python"
    #         # echo "CalculationTool = $CalculationTool"
    #         # exit 0
    #     elif [ "$indexArgument" = "--version" ]; then
    #         echo "$NoteVersion_1"
    #         echo "$NoteVersion_2"
    #         echo "$NoteVersion_3"
    #         echo "$NoteVersion_4"
    #         echo "$NoteVersion_5"
    #         echo "$NoteVersion_6"
    #         exit 0
    #     elif [ "$indexArgument" = "-v" ]; then
    #         echo "$NoteVersion_1"
    #         echo "$NoteVersion_2"
    #         echo "$NoteVersion_3"
    #         echo "$NoteVersion_4"
    #         echo "$NoteVersion_5"
    #         echo "$NoteVersion_6"
    #         exit 0
    #     elif [ "$indexArgument" = "--help" ]; then
    #         echo "$NoteVersion_1"
    #         echo "$NoteVersion_2"
    #         echo "$NoteVersion_3"
    #         echo "$NoteVersion_4"
    #         echo "$NoteVersion_5"
    #         echo "$NoteVersion_6"
    #         echo -e "\n"
    #         echo "$NoteHelp_1"
    #         echo "$NoteHelp_2"
    #         echo "$NoteHelp_3"
    #         echo "$NoteHelp_4"
    #         echo "$NoteHelp_5"
    #         echo "$NoteHelp_6"
    #         echo "$NoteHelp_7"
    #         echo "$NoteHelp_8"
    #         echo "$NoteHelp_9"
    #         echo "$NoteHelp_10"
    #         echo "$NoteHelp_11"
    #         echo "$NoteHelp_12"
    #         echo "$NoteHelp_13"
    #         echo "$NoteHelp_14"
    #         exit 0
    #     elif [ "$indexArgument" = "-h" ]; then
    #         echo "$NoteVersion_1"
    #         echo "$NoteVersion_2"
    #         echo "$NoteVersion_3"
    #         echo "$NoteVersion_4"
    #         echo "$NoteVersion_5"
    #         echo "$NoteVersion_6"
    #         echo -e "\n"
    #         echo "$NoteHelp_1"
    #         echo "$NoteHelp_2"
    #         echo "$NoteHelp_3"
    #         echo "$NoteHelp_4"
    #         echo "$NoteHelp_5"
    #         echo "$NoteHelp_6"
    #         echo "$NoteHelp_7"
    #         echo "$NoteHelp_8"
    #         echo "$NoteHelp_9"
    #         echo "$NoteHelp_10"
    #         echo "$NoteHelp_11"
    #         echo "$NoteHelp_12"
    #         echo "$NoteHelp_13"
    #         echo "$NoteHelp_14"
    #         exit 0
    #     else
    #         configFile="$indexArgument"
    #         # echo "configFile = $configFile"
    #         # exit 0
    #     fi
    # fi

    # 判斷控制臺命令列傳入的參數中是否含有等號字符（'='），若含有等號字符（'='），則如下;
    if [[ "$indexArgument" == *"="* ]]; then

        # Argument_Key="$(echo $indexArgument | cut -f1 -d=)"
        Argument_Key="${indexArgument%%=*}"
        # echo "$Argument_Key"

        # Argument_Value="$(echo $indexArgument | cut -f2 -d=)"
        Argument_Value="${indexArgument#*=}"
        # echo "$Argument_Value"
        # 將傳入參數值字符串中的逗號字符（','）替換爲空格字符（' '）;
        Argument_Value="$(echo "$Argument_Value" | tr ',' ' ')"
        # echo "$Argument_Value"

        # # if [ "$Argument_Key" = "configFile" ]; then
        # #     configFile="$Argument_Value"
        # # fi

        # if [ "$Argument_Key" = "executableFile" ]; then
        #     executableFile="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "interpreterFile" ]; then
        #     interpreterFile="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "scriptFile" ]; then
        #     scriptFile="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "configInstructions" ]; then
        #     configInstructions="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "CalculationTool" ]; then
        #     CalculationTool="$Argument_Value"
        # fi

        # if [ "$Argument_Key" = "shellCodeScript" ]; then
        #     shellCodeScript="$Argument_Value"
        # fi

        case $Argument_Key in
            # configFile) configFile="$Argument_Value";;
            executableFile) executableFile="$Argument_Value";;
            interpreterFile) interpreterFile="$Argument_Value";;
            scriptFile) scriptFile="$Argument_Value";;
            configInstructions) configInstructions="$Argument_Value";;
            CalculationTool) CalculationTool="$Argument_Value";;
            shellCodeScript) shellCodeScript="$Argument_Value";;
            *) # echo "Argument Key: [ $Argument_Key ] unrecognized.";;
        esac

    fi

done
# # echo "configFile = $configFile"
# echo "executableFile = $executableFile"
# echo "interpreterFile = $interpreterFile"
# echo "scriptFile = $scriptFile"
# echo "configInstructions = $configInstructions"
# echo "CalculationTool = $CalculationTool"
# echo "shellCodeScript = $shellCodeScript"
Argument_Key=""
Argument_Value=""
index=0


# 拼接參數獲取 shell 啓動脚本;
# echo "executableFile = $executableFile"
if [ -z "$executableFile" ]; then
    echo "Error, startup executable file path is empty ( executableFile = )."
    # echo "Config file ( $configFile ) import argument: [ executableFile ] is empty."
    # exit 1
else

    # 修改檔權限爲：可執行權限;
    if ! [ -x "./$executableFile" ]; then
        # echo "Error, executableFile: [ $executableFile ] does not exist or is not executable."
        chmod a+x "$executableFile"
        # exit 1
    fi

    if [ -z "$scriptFile" ]; then
        if [ -z "$interpreterFile" ]; then
            shellCodeScript="$executableFile"
        else
            shellCodeScript="$executableFile $interpreterFile"
        fi
    else
        if [ -z "$interpreterFile" ]; then
            if [ -z "$configInstructions" ]; then
                shellCodeScript="$executableFile $scriptFile"
            else
                shellCodeScript="$executableFile $scriptFile $configInstructions"
            fi
        else
            if [ -z "$configInstructions" ]; then
                shellCodeScript="$executableFile $interpreterFile $scriptFile"
            else
                shellCodeScript="$executableFile $interpreterFile $scriptFile $configInstructions"
            fi
        fi
    fi
    # echo "shellCodeScript = $shellCodeScript"
fi


# 啓動服務器二進制可執行檔（.exe）;
# echo "shellCodeScript = $shellCodeScript"
if [ -z "$shellCodeScript" ]; then
    echo "Error, startup shell scrip is emptyt ( shellCodeScript = $shellCodeScript )."
else

    # # 修改檔權限爲：可執行權限;
    # if ! [ -x "./$executableFile" ]; then
    #     echo "Error, executableFile: [ $executableFile ] does not exist or is not executable."
    #     # chmod a+x "$executableFile"
    #     exit 1
    # fi

    # # Ubuntu 系統創建新的控制臺命令列，並進入指定目錄;
    # # gnome-terminal --window --working-directory="$work_directory"
    # gnome-terminal --window --working-directory="$shell_directory"
    # # Ubuntu 系統創建新的控制臺命令列窗口，並在當前目錄下，啓動二進制可執行檔（.exe）;
    # gnome-terminal --window --"$shellCodeScript"

    # 當前控制臺命令列，啓動二進制可執行檔（.exe）;
    # cd "$work_directory"
    # cd "$shell_directory"
    # clear
    $shellCodeScript

fi


# 設定運行完畢窗口不要自動關閉;
# # Read-Host -Prompt "按任意鍵關閉 PowerShell 窗口 ..."
# # echo "按任意鍵繼續 ..."
# echo "Enter any key to continue ..."
# read -n 1
# echo "exit window."

# 關閉控制臺命令列窗口;
exit 0
