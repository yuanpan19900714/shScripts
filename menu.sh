#!/bin/bash

localIP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`

#proportconfig变量的值为proportconfig.properties实际放的位置
proportconfig=/home/esb/esbUpdateVersion/proportconfig.properties
while read line2;
do 
eval "$line2";
done < ${proportconfig}

#echo ${localIP}
#echo ${esbpath}
#echo ${smartesbpath}
#echo ${esblogpath}
#echo ${smartmompath}
#echo ${rsmpath}
#echo ${tuxedopath}
#echo ${tuxedouserpath}




#调用startOrStopF5函数需要带F5状态的参数
startOrStopF5(){
	>${esbtoolspath}respF5.log
		#用直接传参的方式，不使用export
		#export localIP

	#需要将F5调成的状态
		#echo "本函数接收的参数为： $1"
		#localF5state=running
		#localF5state=stop
	localF5state=$1
		#echo "localF5state=$localF5state"
		#export localF5state

	#需要两个参数： 参数1：请求的IP地址；参数2：stop/running 
	#或者三个参数： 参数1：请求的IP地址；参数2：结果文件目录;参数3：stop/running
	sh ${esbtoolspath}reqF5.sh ${localIP} ${localF5state}
	#${esbtoolspath}respF5.log
	if grep "success" ${esbtoolspath}respF5.log -q
	then
		echo "成功将${localIP}的F5状态改为${localF5state}"
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】成功将${localIP}的F5状态改为${localF5state}" >> ${esblogpath}menu.log &
	else
		echo "将${localIP}的F5状态改为${localF5state}失败..."
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】将${localIP}的F5状态改为${localF5state}失败，请核对配置" >> ${esblogpath}menu.log &
		exit
	fi
}

#检查进程状态函数
checkProcess(){
	if ps -ef|grep java|grep SmartMOM -q
	then
		echo "MOM进程已启动..."
	else
		#echo "MOM进程已停止..."
		echo -e "\033[43;31mMOM进程已停止... \033[0m"
	fi

	if ps -ef|grep java|grep CONSOLE -q
	then
		echo "CONSOLE进程已启动..."
	else
		#echo "CONSOLE进程已停止..."
		echo -e "\033[43;31mCONSOLE进程已停止... \033[0m"
	fi

	if ps -ef|grep java|grep IN -q
	then
		echo "Smart进程已启动..."
	else
		#echo "Smart进程已停止..."
		echo -e "\033[43;31mSmart进程已停止... \033[0m"
	fi

	if ps -ef|grep java|grep JOURNAL -q
	then
		echo "JOURNAL进程已启动..."
	else
		#echo "JOURNAL进程已停止..."
		echo -e "\033[43;31mJOURNAL进程已停止... \033[0m"
	fi

	if ps -ef|grep java|grep FLOW|grep 22225 -q
	then
		echo "FLOW进程已启动..."
	else
		#echo "FLOW进程已停止..."
		echo -e "\033[43;31mFLOW进程已停止... \033[0m"
	fi

	if ps -ef|grep java|grep SUBFLOW -q
	then
		echo "SUBFLOW进程已启动..."
	else
		#echo "SUBFLOW进程已停止..."
		echo -e "\033[43;31mSUBFLOW进程已停止... \033[0m"
	fi

	if ps -ef |grep sh |grep runesbmon -q
	then
		echo "rsm进程已启动..."
	else
		#echo "rsm进程已停止..."
		echo -e "\033[43;31mrsm进程已停止... \033[0m"
	fi

	if ps -ef|grep ULOG|grep -v grep -q
	then
		echo "tuxedo进程已启动..."
	else
		#echo "tuxedo进程已停止..."
		echo -e "\033[43;31mtuxedo进程已停止... \033[0m"
	fi
	echo ""

}

key1(){
	echo "检查MOM进程:"
	if ps -ef|grep java|grep SmartMOM -q
	then
		echo "MOM进程已启动..."
		#echo "start kill -9 `ps -ef|grep java|grep SmartMOM|cut -b10-15`"
		#kill -9 `ps -ef|grep java|grep SmartMOM|cut -b10-15`
		#sleep 2
		#cd ${smartmompath}
		#echo "start execute startMom.sh"
		#sh ./startMom.sh
		#echo "end execute startMom.sh"
	else
		echo "MOM进程已停止..."
		cd ${smartmompath}
		echo "start execute startMom.sh"
		sh ./startMom.sh
		echo "end execute startMom.sh"
	fi
	echo ""
}

key2(){
	cd ${smartesbpath}bin
	echo "检查CONSOLE进程:"
	if ps -ef|grep java|grep CONSOLE -q
	then
		echo "CONSOLE进程已启动..."
	else
		echo "CONSOLE进程已停止..."
		#echo "start kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`"
		#kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`
		#echo "end kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`"
		#sleep 2
		echo "start execute 1-startConsole.sh"
		sh ./1-startConsole.sh
	fi
	echo ""
}

key3(){
	cd ${smartesbpath}bin
	echo "检查Smart进程:"
	if ps -ef|grep java|grep IN -q
	then
		echo "Smart进程已启动..."
	else
		echo "Smart进程已停止..."
		#sleep 1
		#echo "start execute stopSmart.sh"
		#sh ./stopSmart.sh
		#echo "end execute stopSmart.sh"
		#echo ""
		#sleep 3
		echo "start execute 2-startSmart.sh"
		sh ./2-startSmart.sh
	fi
	echo ""
}

key4(){
	echo "检查JOURNAL进程:"
	if ps -ef|grep java|grep JOURNAL -q
	then
		echo "JOURNAL进程已启动..."
	else
		echo "JOURNAL进程已停止..."
		#echo "start kill -9 `ps -ef|grep java|grep JOURNAL|cut -b10-15`"
		#kill -9 `ps -ef|grep java|grep JOURNAL|cut -b10-15`
		#sleep 2
		cd ${smartesbpath}bin
		echo "start execute 3-startJournal.sh"
		sh ./3-startJournal.sh
	fi
	echo ""
}

key5(){
	echo "检查FLOW进程:"
	if ps -ef|grep java|grep FLOW|grep 22225 -q
	then
		echo "FLOW进程已启动..."
	else
		echo "FLOW进程已停止..."
		#echo "start kill -9 `ps -ef|grep java|grep FLOW|grep 22225|cut -b10-15`"
		#kill -9 `ps -ef|grep java|grep FLOW|grep 22225|cut -b10-15`
		#sleep 2
		cd ${smartesbpath}bin
		echo "start execute 4-startFlow.sh"
		sh ./4-startFlow.sh
	fi
	echo ""
}

key6(){
	echo "检查SUBFLOW进程:"
	if ps -ef|grep java|grep SUBFLOW -q
	then
		echo "SUBFLOW进程已启动..."
	else
		echo "SUBFLOW进程已停止..."
		#echo "start kill -9 `ps -ef|grep java|grep SUBFLOW|cut -b10-15`"
		#kill -9 `ps -ef|grep java|grep SUBFLOW|cut -b10-15`
		#sleep 2
		cd ${smartesbpath}bin
		echo "start execute 5-startSubFlow.sh"
		sh ./5-startSubFlow.sh
	fi
	echo ""
}

key7(){
	echo "检查rsm进程:"
	if ps -ef |grep sh |grep runesbmon -q
	then
		echo "rsm进程已启动..."
	else
		echo "rsm进程已停止..."
		cd ${rsmpath}
		echo "start execute start_m"
		sh ./start_m
		tail -f nohup.out
		echo "end execute start_m"
	fi
	echo ""
}

key8(){
	echo "检查CONSOLE进程:"
	if ps -ef|grep java|grep CONSOLE -q
	then
		echo "CONSOLE进程已启动..."
		cd ${smartesbpath}bin
		echo "start execute stopConsole.sh"
		sh ./stopConsole.sh
		echo "end execute stopConsole.sh"
	else
		echo "CONSOLE进程已停止..."
	fi
	echo ""
}

key9(){
	echo "检查Smart进程:"
	if ps -ef|grep java|grep IN -q
	then
		echo "Smart进程已启动..."
		cd ${smartesbpath}bin
		echo "start execute stopSmart.sh"
		sh ./stopSmart.sh
		echo "end execute stopSmart.sh"
	else
		echo "Smart进程已停止..."
	fi
	echo ""
}

key10(){
	echo "检查JOURNAL进程:"
	if ps -ef|grep java|grep JOURNAL -q
	then
		echo "JOURNAL进程已启动..."
		cd ${smartesbpath}bin
		echo "start execute stopJournal.sh"
		sh ./stopJournal.sh
		echo "end execute stopJournal.sh"
	else
		echo "JOURNAL进程已停止..."
	fi
	echo ""	
}

key11(){
	echo "检查FLOW进程:"
	if ps -ef|grep java|grep FLOW|grep 22225 -q
	then
		echo "FLOW进程已启动..."
		cd ${smartesbpath}bin
		echo "start execute stopFlow.sh"
		sh ./stopFlow.sh
		echo "end execute stopFlow.sh"
	else
		echo "FLOW进程已停止..."
	fi
	echo ""
}

key12(){
	echo "检查SubFLOW进程:"
	if ps -ef|grep java|grep SUBFLOW -q
	then
		echo "SUBFLOW进程已启动..."
		cd ${smartesbpath}bin
		echo "start execute stopSubFlow.sh"
		sh ./stopSubFlow.sh
		echo "end execute stopSubFlow.sh"
	else
		echo "SUBFLOW进程已停止..."
	fi
	echo ""
}

key13(){
	echo "检查SmartMOM进程:"
	if ps -ef|grep java|grep SmartMOM -q
	then
		echo "MOM进程已启动..."
		cd ${smartmompath}
		#sleep 1
		echo "start execute stopMom.sh"
		sh ./stopMom.sh
		echo "end execute stopMom.sh"
	else
		echo "MOM进程已停止..."
	fi
	echo ""
}

key14(){
	cd ${rsmpath}
	echo "检查rsm进程:"
	if ps -ef |grep sh |grep runesbmon -q
	then
		echo "rsm进程已启动..."
		#sleep 1
		echo "start execute stop_m"
		sh ./stop_m
		echo "end execute stop_m"
	else
		echo "rsm进程已停止..."
	fi
	
	echo ""
}

key15(){
	echo "检查tuxedo进程:"
	if ps -ef|grep ULOG|grep -v grep -q
	then
		echo "tuxedo进程已启动..."
	else
		echo "tuxedo进程已停止..."
		echo "cd ${tuxedopath}"
		cd ${tuxedopath}
		#sleep 1
		#echo "start execute stop.sh"
		#sh ./stop.sh
		#echo "end execute stop.sh"
		#sleep 2
		echo "start execute startAll.sh"
		sh ./startAll.sh
		echo "end execute startAll.sh"
	fi
	echo ""
}

key16(){
	echo "检查tuxedo进程:"
	if ps -ef|grep ULOG|grep -v grep -q
	then
		echo "tuxedo进程已启动..."
		echo "cd ${tuxedopath}"
		cd ${tuxedopath}
		#sleep 1
		echo "start execute stop.sh"
		sh ./stop.sh
		echo "end execute stop.sh"
	else
		echo "tuxedo进程已停止..."
	fi
	echo ""
}


stopESB(){
		cd ${smartesbpath}bin
		sleep 1
		echo "start execute stopSubFlow.sh    (开始停止SubFlow进程)"
		sh ./stopSubFlow.sh
		echo "end execute stopSubFlow.sh    (停止SubFlow进程完成)"
		echo ""

		cd ${smartesbpath}bin
		sleep 1
		echo "start execute stopFlow.sh   (开始停止Flow进程) "
		sh ./stopFlow.sh
		echo "end execute stopFlow.sh    (停止Flow进程完成)"
		echo ""
		
		cd ${smartesbpath}bin
		sleep 1
		echo "start execute stopJournal.sh   (开始停止Journal进程)"
		sh ./stopJournal.sh
		echo "end execute stopJournal.sh    (停止Journal进程完成)"
		echo ""

		cd ${smartesbpath}bin
		echo ""
		echo "开始停止Smart进程（start execute ${smartesbpath}bin/stopSmart.sh）:"
		echo ""
		sleep 1
		sh ./stopSmart.sh
		echo "end execute stopSmart.sh"

		#echo "smart进程状态自检，如果使用关闭脚本不能正常停止，则强制杀死进程"
		sleep 2
		if ps -ef|grep java|grep IN -q
		then
			echo "Smart进程未正常停止..."
			echo "start kill -9 `ps -ef|grep java|grep IN|cut -b10-15`"
			kill -9 `ps -ef|grep java|grep IN|cut -b10-15`
			sleep 1
			echo "end kill"
			#sleep 1
			echo "检查smart进程状态:"	
			if ps -ef|grep java|grep IN -q
			then
				echo "Smart进程已启动..."
			else
				echo "Smart进程已停止..."
			fi
		else
			:
		fi

		echo ""
		echo "等待1分钟，再停止console进程...(因为停止了smart后立即停止console,ESB启动时有较低概率可能会出现异常)"
		sleep 60

		echo "停止console进程（start execute ${smartesbpath}bin/stopConsole.sh）:"
		sh ./stopConsole.sh
		echo "end execute stopConsole.sh"
		echo ""

		#echo "console进程状态自检，如果使用关闭脚本不能正常停止，则强制杀死进程"
		sleep 2
		if ps -ef|grep java|grep CONSOLE -q
		then
			echo "CONSOLE进程未正常停止..."
			echo "start kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`"
			kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`
			sleep 1
			echo "end kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`"
			#sleep 1
			if ps -ef|grep java|grep CONSOLE -q
			then
				echo "CONSOLE进程已启动..."
			else
				echo "CONSOLE进程已停止..."
			fi
		else
			:
		fi
}
startESB(){
	cd ${smartesbpath}bin
	echo "2启动Console进程（start execute ${smartesbpath}bin/startConsole.sh）:"
	echo "正在后台启动Console进程，请稍等..."
	#echo "提示：如果超过2分钟还没启动完成console进程，请强制退出手动重启或者使用菜单的选项 2>启动Console 重启"	
	nohup ./startConsole.sh > console.log &
	#tail -f console.log
	while : ; do
		sleep 5
		if grep "Server startup in [0-9]* ms" console.log;then
			echo "2启动Console进程完成"
			echo "启动console和smart的时候，中间间隔30秒，如果console启动完之后直接启动smart，可能会有少许配置未加载的情况"
			sleep 30
			echo ""
			echo "3启动Smart进程（start execute ${smartesbpath}bin/2-startSmart.sh）:"
			#echo "start execute 2-startSmart.sh"
			#sh ./2-startSmart.sh
			current_time=`date '+%Y%m%d%H%M%S'`
			echo "execute mv out.smart ./log/out.smart.${current_time}"
			mv out.smart ./log/out.smart.$current_time
			>out.smart
			sleep 1 
			echo "正在后台启动smart进程，请稍等..."
			echo "提示：您可以另外打开一个窗口进入${smartesbpath}bin路径,使用tail -f out.smart实时查看smart日志..."	
			nohup ./startSmart.sh>out.smart&
			#tail -f out.smart
			while : ; do
				sleep 5
				#echo `date '+%Y%m%d%H%M%S'`
				aa=`grep "ESB application <IN> startup in [0-9]* ms" out.smart`
				bb=`grep "ESB application <ROUTER> startup in [0-9]* ms" out.smart`
				cc=`grep "ESB application <OUT> startup in [0-9]* ms" out.smart`
				if [ ! -z "$aa" ] && [ ! -z "$bb" ] && [ ! -z "$cc" ] ;then
					echo "<IN>,<ROUTER>,<OUT>容器已经启动完毕，启动smart进程完成"
					echo ""
					echo "4启动Journal进程（start execute ${smartesbpath}bin/3-startJournal.sh）:"
					#sh ./3-startJournal.sh
					nohup ./startJournal.sh > journal.log &
					while : ; do
						sleep 5
						if grep "ESB application <JOURNAL> startup in [0-9]* ms" journal.log;then
							echo "4启动JOURNAL进程完成"	
							echo ""
							echo "5启动Flow(start execute 4-startFlow.sh)"
							#sh ./4-startFlow.sh
							nohup ./startFlow.sh > flow.log &
							while : ; do
								sleep 3
								if grep "流控服务器开始启动完成!" flow.log;then
									echo "5启动流控服务器完成"
									echo ""
									echo "6启动SubFlow(start execute 5-startSubFlow.sh)"
									#sh ./5-startSubFlow.sh			
									nohup ./startSubFlow.sh > subFlow.log &
									while : ; do
										sleep 3
										if grep "流控服务器开始启动完成!" subFlow.log;then
											echo "6启动备流控服务器完成"
											echo ""
											break	
										fi
									done
									break	
								fi
							done
							break	
						fi
					done
					break	
				fi
			done
			break
		fi
	done 
	echo ""
	echo "一键启动ESB完成，查看进程状态："
	checkProcess
}

#一键停止ESB
endAll(){
		echo "停止顺序：1停止rsm——>2停止Mom——>3停止SubFlow——>4停止Flow——>5停止Journal——>6停止Smart——>7停止Console"
		cd ${rsmpath}
		sleep 1
		echo "start execute stop_m    (开始停止rsm)"
		sh ./stop_m
		echo "end execute stop_m    (停止rsm完成)"
		echo ""

		cd ${smartmompath}
		sleep 1
		echo "start execute stopMom.sh    (开始停止SmartMOM)"
		sh ./stopMom.sh
		echo "end execute stopMom.sh   (停止SmartMOM完成)"
		echo ""

		stopESB
		
		echo ""
		echo "一键停止ESB完成，查看进程状态："
		checkProcess
}

#一键启动ESB
startAll(){
	echo "启动顺序：1启动Mom——>2启动Console——>3启动Smart——>4启动Journal——>5启动Flow——>6启动SubFlow——>7启动rsm"
	cd ${smartmompath}
	echo "1启动Mom(start execute startMom.sh)"
	sh ./startMom.sh
	echo "1启动Mom成功(end execute startMom.sh)"
	echo ""
	cd ${smartesbpath}bin
	echo "2启动Console进程（start execute ${smartesbpath}startConsole.sh）:"
	echo "正在后台启动Console进程，请稍等..."
	#echo "提示：如果超过2分钟还没启动完成console进程，请强制退出手动重启或者使用菜单的选项 2>启动Console 重启"	
	nohup ./startConsole.sh > console.log &
	#tail -f console.log
	while : ; do
		sleep 5
		if grep "Server startup in [0-9]* ms" console.log;then
			echo "2启动Console进程完成"
			echo ""
			echo "启动console和smart的时候，中间间隔30秒，如果console启动完之后直接启动smart，可能会有少许配置未加载的情况"
			sleep 30
			echo "3启动Smart进程（start execute ${smartesbpath}2-startSmart.sh）:"
			#echo "start execute 2-startSmart.sh"
			#sh ./2-startSmart.sh
			current_time=`date '+%Y%m%d%H%M%S'`
			echo "execute mv out.smart ./log/out.smart.${current_time}"
			mv out.smart ./log/out.smart.$current_time
			>out.smart
			sleep 1 
			echo "正在后台启动smart进程，请稍等..."
			echo "提示：您可以另外打开一个窗口进入${smartesbpath}bin路径,使用tail -f out.smart实时查看smart日志..."	
			nohup ./startSmart.sh>out.smart&
			#tail -f out.smart
			while : ; do
				sleep 5
				#echo `date '+%Y%m%d%H%M%S'`
				aa=`grep "ESB application <IN> startup in [0-9]* ms" out.smart`
				bb=`grep "ESB application <ROUTER> startup in [0-9]* ms" out.smart`
				cc=`grep "ESB application <OUT> startup in [0-9]* ms" out.smart`
				if [ ! -z "$aa" ] && [ ! -z "$bb" ] && [ ! -z "$cc" ] ;then
					echo "<IN>,<ROUTER>,<OUT>容器已经启动完毕，启动smart进程完成"
					echo ""
					echo "4启动Journal进程（start execute ${smartesbpath}bin/3-startJournal.sh）:"
					#sh ./3-startJournal.sh
					nohup ./startJournal.sh > journal.log &
					while : ; do
						sleep 5
						if grep "ESB application <JOURNAL> startup in [0-9]* ms" journal.log;then
							echo "4启动JOURNAL进程完成"	
							echo ""
							echo "5启动Flow(start execute 4-startFlow.sh)"
							#sh ./4-startFlow.sh
							nohup ./startFlow.sh > flow.log &
							while : ; do
								sleep 3
								if grep "流控服务器开始启动完成!" flow.log;then
									echo "5启动流控服务器完成"
									echo ""
									echo "6启动SubFlow(start execute 5-startSubFlow.sh)"
									#sh ./5-startSubFlow.sh			
									nohup ./startSubFlow.sh > subFlow.log &
									while : ; do
										sleep 3
										if grep "流控服务器开始启动完成!" subFlow.log;then
											echo "6启动备流控服务器完成"
											echo ""
											cd ${rsmpath}
											echo "7启动rsm"
											#start_m需要将tail -f nohup.out注释，不然会占用进程
											sh ./start_m
											while : ; do
												sleep 3
												#finish mon:20161024 11:00:09
												#if grep "finish mon:[0-9]* [0-9]*:[0-9]*:[0-9]*" nohup.out;then
												#	echo "启动rsm成功"
												#	break	
												#fi
												if ps -ef |grep sh |grep runesbmon -q
												then
													echo "7rsm进程已启动..."
													break
												else
													#echo "rsm进程还未启动完成"
													:
												fi
											done
											break	
										fi
									done
									break	
								fi
							done
							break	
						fi
					done
					break	
				fi
			done
			break
		fi
	done 
	echo ""
	echo "一键启动ESB完成，查看进程状态："
	checkProcess
}

#解压补丁包
unzipfile(){
	while : ; do
		echo "请输入版本文件名字（zip类型）:"
		read KEY2
		echo "确认安装包名称：${KEY2}，是则输入Y|y，不是则输入N|n"
		read KEY3
		if [ $KEY3 = Y ] || [ $KEY3 = y ];then
			echo "【`date '+%Y-%m-%d %H:%M:%S'`】unzip ${KEY2}" >> ${esblogpath}menu.log &
			unzip ${KEY2}  > ${esblogpath}unzip.log
			#echo "cat ${esbpath}esblog/unzip.log"
			cat ${esblogpath}unzip.log
			cat ${esblogpath}unzip.log >> ${esblogpath}menu.log
			rm -rf ${esblogpath}unzip.log
			break
		elif [ $KEY3 = N ] || [ $KEY3 = n ];then
			echo "该安装包名称有误，请重新输入"
		else
			echo "your choose not in [Y|y] and [N|n]，请重新输入："
		fi
	done
}
unzipfile2(){
	cd ${esbpath}esbUpdateVersion/${updateFileName}
	echo "【`date '+%Y-%m-%d %H:%M:%S'`】当前路径：`pwd`,将${file}复制到${esbpath}:" >> ${esblogpath}menu.log &
	cp ${file} ${esbpath}${file}
	cd ${esbpath}
	echo "【`date '+%Y-%m-%d %H:%M:%S'`】当前路径：`pwd`,解压${file}：" >> ${esbpath}esblog/menu.log &
	#echo "【`date '+%Y-%m-%d %H:%M:%S'`】unzip ${file}" >> ${esbpath}esblog/menu.log &
	#unzip ${file}  > ${esbpath}esblog/unzip.log
	unzip -o ${file}  > ${esbpath}esblog/unzip.log
	echo "查看解压日志：" >> ${esbpath}esblog/menu.log &
	echo "cat ${esbpath}esblog/unzip.log"
	cat ${esbpath}esblog/unzip.log
	cat ${esbpath}esblog/unzip.log >> ${esbpath}esblog/menu.log
	rm -rf ${esbpath}esblog/unzip.log
	
	echo "【`date '+%Y-%m-%d %H:%M:%S'`】当前路径：`pwd`,删除${file}" >> ${esbpath}esblog/menu.log &
	rm -rf ${file}
}
#解压tuxedo补丁包
unzipfile3(){
	while : ; do
		echo "请输入tuxedo版本文件名字（zip类型）:"
		read KEY10
		echo "确认安装包名称：${KEY10}，是则输入Y|y，不是则输入N|n"
		read KEY11
		if [ $KEY11 = Y ] || [ $KEY11 = y ];then
			#echo "【`date '+%Y-%m-%d %H:%M:%S'`】unzip ${KEY10}" >> ${esblogpath}menu.log &
			#unzip ${KEY10}  > ${esblogpath}unzip.log
			
			unzip ${KEY10}

			#echo "cat ${esbpath}esblog/unzip.log"
			#cat ${esblogpath}unzip.log
			#cat ${esblogpath}unzip.log >> ${esblogpath}menu.log
			#rm -rf ${esblogpath}unzip.log

			break
		elif [ $KEY11 = N ] || [ $KEY11 = n ];then
			echo "该安装包名称有误，请重新输入"
		else
			echo "your choose not in [Y|y] and [N|n]，请重新输入："
		fi
	done
}

#版本更新函数
update(){	
		echo "" > ${esblogpath}menu.log &
		#echo "" >> ${esblogpath}menu.log &
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】开始更新版本:" >> ${esblogpath}menu.log &
		echo "" >> ${esblogpath}menu.log &
		echo "  版本更新前，请将本次所有需要更新的版本文件放在同个文件夹，"
		echo "  并将此文件夹放在${esbpath}esbUpdateVersion文件夹中(如果没有该文件夹，则新建)，"
		echo "  后边需要输入该文件夹的名字，脚本会自动遍历里边的补丁包"
		echo "  其他：需要新建${esbpath}esb_bak文件夹，备份的ESB放在这个路径下"

		
		echo ""
		echo "开始更新；"
		#echo "1.请进入console控制台，进入多路管理-F5控制，停止需要更新版本的机器"
		#echo "【`date '+%Y-%m-%d %H:%M:%S'`】1.请进入console控制台，进入多路管理-F5控制，停止需要更新版本的机器" >> ${esblogpath}menu.log &
		echo "1.关闭本机F5："
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】1.关闭本机F5：" >> ${esblogpath}menu.log &
		while : ; do
			echo "确认是否关闭本机F5,以及版本文件夹已经放置在${esbpath}esbUpdateVersion路径下,是则输入Y|y:"
			echo "【`date '+%Y-%m-%d %H:%M:%S'`】确认是否关闭本机F5,以及版本文件夹已经放置在${esbpath}esbUpdateVersion路径下,都是则输入Y|y:" >> ${esblogpath}menu.log &
			read KEY4
			if [ $KEY4 = Y ] || [ $KEY4 = y ]
			then
				startOrStopF5 stop
				break
			fi
		done


		echo ""
		echo " " >> ${esblogpath}menu.log &
		echo "2.请稍等1分钟，确保F5不再分流到已停止机器；(等待是为了已经进入ESB的交易都能做完)"
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】2.请稍等1-2分钟，确保F5不再分流到已停止机器；" >> ${esblogpath}menu.log &
		sleep 60


		cd ${smartesbpath}bin
		echo ""
		echo "3.1.停止Smart进程（start execute ${smartesbpath}bin/stopSmart.sh）:"
		echo "" >> ${esblogpath}menu.log &
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】3.1.停止Smart进程" >> ${esblogpath}menu.log &
		echo ""
		sh ./stopSmart.sh
		echo "end execute stopSmart.sh"
		sleep 2
		if ps -ef|grep java|grep IN -q
		then
			echo "Smart进程已启动..."
			echo "start kill -9 `ps -ef|grep java|grep IN|cut -b10-15`"
			kill -9 `ps -ef|grep java|grep IN|cut -b10-15`
			#sleep 1
			echo "end kill -9 `ps -ef|grep java|grep IN|cut -b10-15`"
			echo "检查smart进程状态:"	
			if ps -ef|grep java|grep IN -q
			then
				echo "Smart进程已启动..."
			else
				echo "【`date '+%Y-%m-%d %H:%M:%S'`】Smart进程已停止..." >> ${esblogpath}menu.log &
			fi
		else
			echo "Smart进程已停止..."
			echo "【`date '+%Y-%m-%d %H:%M:%S'`】Smart进程已停止..." >> ${esblogpath}menu.log &
		fi
		echo ""
		echo "等待1分钟，再停止console进程...(因为停止了smart后立即停止console,ESB启动时有较低概率可能会出现异常)"
		sleep 60

		echo "3.2.停止console进程（start execute ${smartesbpath}bin/stopConsole.sh）:"
		echo "" >> ${esblogpath}menu.log &
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】3.2.停止console进程" >> ${esblogpath}menu.log &
		sh ./stopConsole.sh
		echo "end execute stopConsole.sh"
		echo ""
		sleep 1 

		#echo "3.3.检查console&smart进程状态:"
		echo "" >> ${esblogpath}menu.log &
		#echo "【`date '+%Y-%m-%d %H:%M:%S'`】3.3.检查console&smart进程状态:" >> ${esblogpath}menu.log &
		if ps -ef|grep java|grep CONSOLE -q
		then
			echo "CONSOLE进程已启动..."
			echo "start kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`"
			kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`
			sleep 1
			echo "end kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`"
			if ps -ef|grep java|grep CONSOLE -q
			then
				echo "CONSOLE进程已启动..."
			else
				echo "【`date '+%Y-%m-%d %H:%M:%S'`】CONSOLE进程已停止..." >> ${esblogpath}menu.log &
			fi
		else
			echo "CONSOLE进程已停止..."
			echo "【`date '+%Y-%m-%d %H:%M:%S'`】CONSOLE进程已停止..." >> ${esblogpath}menu.log &
		fi
		
		sleep 1

		echo ""
		#echo "3.4.确认console&smart进程状态:"
		#while : ; do
			#echo "提示：如果不是确认停止，会执行kill -9 +smart进程id"
			#echo "确认Smart进程已经停止，是则输入Y|y:"
			#read KEY5
			#if [ $KEY5 = Y ] || [ $KEY5 = y ]
			#then
				#break
			#else
				#echo "start kill -9 `ps -ef|grep java|grep IN|cut -b10-15`"
				#kill -9 `ps -ef|grep java|grep IN|cut -b10-15`
				#sleep 2
				#echo "end kill -9 `ps -ef|grep java|grep IN|cut -b10-15`"
				#echo "检查smart进程状态:"	
				#if ps -ef|grep java|grep IN -q
				#then
					#echo "Smart进程已启动..."
				#else
					#echo "Smart进程已停止..."
				#fi
			#fi
		#done
		#echo ""
		#while : ; do
			#echo "提示：如果不是确认停止，会执行kill -9 +console进程id"
			#echo "确认CONSOLE进程已经停止，是则输入Y|y"
			#read KEY6
			#if [ $KEY6 = Y ] || [ $KEY6 = y ]
			#then
				#break
			#else
				#echo "start kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`"
				#kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`
				#sleep 2
				#echo "end kill -9 `ps -ef|grep java|grep CONSOLE|cut -b10-15`"	
				#echo "检查console进程状态:"
				#if ps -ef|grep java|grep CONSOLE -q
				#then
					#echo "CONSOLE进程已启动..."
				#else
					#echo "CONSOLE进程已停止..."
				#fi
			#fi
		#done

		echo ""
		echo ""
		cd ${esbpath}
		echo "4.备份当前ESB，并删除2个月之前的备份包:"
		echo "" >> ${esblogpath}menu.log &
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】4.备份当前ESB，并删除2个月之前的备份包:" >> ${esblogpath}menu.log &
		mydate=`date +%Y%m%d`
		echo "将SmartESB备份至SmartESB${mydate}.tar"
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】将SmartESB备份至${esbpath}esb_bak/SmartESB${mydate}.tar" >> ${esblogpath}menu.log &
		sleep 2
		#tar -cvf SmartESB${mydate}.tar SmartESB
		tar -cvf ${esbpath}esb_bak/SmartESB${mydate}.tar SmartESB
		echo "将SmartESB备份至${esbpath}esb_bak/SmartESB${mydate}.tar完成！"
		echo ""	
		echo "查找2个月之前的备份文件..."
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】查找2个月之前的备份文件..." >> ${esblogpath}menu.log &
		#下面这个/home/esb和${esbpath}esb_bak的备份文件都清理，一个是以前的备份路径，一个是现在规范后的路径
		cd ${esbpath}
		for file in `ls SmartESB[0-9]*.tar`
		do
			datebackup=`date -d "${file:8:8}" +%s`
			datetwomonthsago=`date -d "2 months ago" +%s`
			datetwomonthsago2=`date -d "2 months ago" +%Y%m%d`
			if [ $datebackup -gt $datetwomonthsago ];then
				#echo "$file 日期为： ${file:8:8} > $datetwomonthsago2"
				:
			elif [  $datebackup -eq $datetwomonthsago ]; then
				#echo "$file 日期为： ${file:8:8} = $datetwomonthsago2"
				:
			else
				#echo "$file 日期为： ${file:8:8} < $datetwomonthsago2"
				echo "$file 为2个月前的备份文件，执行命令  rm -rf $file  删除该文件..."
				echo "【`date '+%Y-%m-%d %H:%M:%S'`】$file 为2个月前的备份文件，执行命令  rm -rf $file  删除该文件..." >> ${esblogpath}menu.log &
				rm -rf $file
			fi
		done
		cd ${esbpath}esb_bak
		for file in `ls SmartESB[0-9]*.tar`
		do
			datebackup=`date -d "${file:8:8}" +%s`
			datetwomonthsago=`date -d "2 months ago" +%s`
			datetwomonthsago2=`date -d "2 months ago" +%Y%m%d`
			if [ $datebackup -gt $datetwomonthsago ];then
				#echo "$file 日期为： ${file:8:8} > $datetwomonthsago2"
				:
			elif [  $datebackup -eq $datetwomonthsago ]; then
				#echo "$file 日期为： ${file:8:8} = $datetwomonthsago2"
				:
			else
				#echo "$file 日期为： ${file:8:8} < $datetwomonthsago2"
				echo "$file 为2个月前的备份文件，执行命令  rm -rf $file  删除该文件..."
				echo "【`date '+%Y-%m-%d %H:%M:%S'`】$file 为2个月前的备份文件，执行命令  rm -rf $file  删除该文件..." >> ${esblogpath}menu.log &
				rm -rf $file
			fi
		done

		echo ""
		echo ""
		echo "5.解压版本文件："
		echo "" >> ${esblogpath}menu.log &
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】5.解压版本文件：" >> ${esblogpath}menu.log &
		#unzipfile
		#echo ""
		#while : ; do
		#	echo "是否还有其他版本文件，是则输入Y|y，不是则输入N|n："
		#	read KEY7
		#	if [ $KEY7 = Y ] || [ $KEY7 = y ];then
		#		echo "还有其他版本文件"
		#		unzipfile
		#	elif [ $KEY7 = N ] || [ $KEY7 = n ];then
		#		echo "没有其他版本文件，继续下一步"
		#		break
		#	else
		#		echo "your choose not in [Y|y] and [N|n]，请重新输入："
		#	fi
		#done

		
		while : ; do
			echo "请输入${esbpath}esbUpdateVersion/中版本文件放置的文件夹名字："
			read updateFileName
			echo "确认版本文件放置的文件夹名字：${updateFileName}，是则输入Y|y，不是则输入N|n"
			read KEY9
			if [ $KEY9 = Y ] || [ $KEY9 = y ];then
				cd ${esbpath}esbUpdateVersion/${updateFileName}
				for file in `ls`
				do
					echo "$file"
					unzipfile2
					sleep 1
				done
				break
			elif [ $KEY9 = N ] || [ $KEY9 = n ];then
				echo "版本文件放置的文件夹名字有误，请重新输入"
			else
				echo "your choose not in [Y|y] and [N|n]，请重新输入："
			fi

		done


		echo ""
		echo ""
		echo "6.授权："	
		cd ${esbpath}
		echo "execute chmod -R 754 SmartESB"	
		echo "" >> ${esblogpath}menu.log &
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】6.授权：chmod -R 754 SmartESB" >> ${esblogpath}menu.log &
		sleep 1
		chmod -R 754 SmartESB
		echo "授权成功！"	

		echo ""
		echo ""
		cd ${smartesbpath}bin
		echo "7.1.启动Console进程（start execute ${smartesbpath}bin/startConsole.sh）:"
		echo "" >> ${esblogpath}menu.log &
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】7.1.启动Console进程" >> ${esblogpath}menu.log &
		echo "正在后台启动Console进程，请稍等..."
		echo "提示：如果超过2分钟还没启动完成console进程，请强制退出手动重启或者使用菜单的选项 2>启动Console 重启"	
		nohup ./startConsole.sh > console.log &
		#tail -f console.log
		while : ; do
			sleep 5
			if grep "Server startup in [0-9]* ms" console.log;then
				echo "启动Console进程完成"
				echo ""
				echo "启动console和smart的时候，中间间隔30秒，如果console启动完之后直接启动smart，可能会有少许配置未加载的情况"
				sleep 30
				echo "7.2.启动Smart进程（start execute ${smartesbpath}bin/2-startSmart.sh）:"
				echo "" >> ${esblogpath}menu.log &
				echo "【`date '+%Y-%m-%d %H:%M:%S'`】7.2.启动Smart进程" >> ${esblogpath}menu.log &
				#echo "start execute 2-startSmart.sh"
				#sh ./2-startSmart.sh
				current_time=`date '+%Y%m%d%H%M%S'`
				echo "execute mv out.smart ./log/out.smart.${current_time}"
				mv out.smart ./log/out.smart.$current_time
				>out.smart
				sleep 1 
				echo "正在后台启动smart进程，请稍等..."
				echo "提示：您可以另外打开一个窗口进入${smartesbpath}bin路径,使用tail -f out.smart实时查看smart日志..."	
				#echo "      长时间没有提示启动成功，就需要看smart日志，有时可能会出现端口被占用的情况，导致无法启动成功"
				nohup ./startSmart.sh>out.smart&
				#tail -f out.smart
				while : ; do
					sleep 5
					#echo `date '+%Y%m%d%H%M%S'`
					aa=`grep "ESB application <IN> startup in [0-9]* ms" out.smart`
					bb=`grep "ESB application <ROUTER> startup in [0-9]* ms" out.smart`
					cc=`grep "ESB application <OUT> startup in [0-9]* ms" out.smart`
					if [ ! -z "$aa" ] && [ ! -z "$bb" ] && [ ! -z "$cc" ] ;then
						echo "<IN>,<ROUTER>,<OUT>容器已经启动完毕，启动smart进程完成"
						break	
					fi
				done
				break
			fi
		done

		echo ""
		echo "7.3.检查console&smart进程状态:"
		echo "" >> ${esblogpath}menu.log &
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】7.3.检查console&smart进程状态:" >> ${esblogpath}menu.log &

		if ps -ef|grep java|grep CONSOLE -q
		then
			echo "CONSOLE进程已启动..."
			echo "【`date '+%Y-%m-%d %H:%M:%S'`】CONSOLE进程已启动..." >> ${esblogpath}menu.log &
		else
			echo "CONSOLE进程已停止..."
			echo "【`date '+%Y-%m-%d %H:%M:%S'`】CONSOLE进程已停止..." >> ${esblogpath}menu.log &
		fi
		if ps -ef|grep java|grep IN -q
		then
			echo "Smart进程已启动..."
			echo "【`date '+%Y-%m-%d %H:%M:%S'`】Smart进程已启动..." >> ${esblogpath}menu.log &
		else
			echo "Smart进程已停止..."
			echo "【`date '+%Y-%m-%d %H:%M:%S'`】Smart进程已停止..." >> ${esblogpath}menu.log &
		fi
		
		echo ""
		echo "7.4确认console&smart进程状态已经启动"
		echo ""
		echo "" >> ${esblogpath}menu.log &
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】7.4请确认console&smart进程状态已经启动" >> ${esblogpath}menu.log &
		echo "提示：更新操作已经完成！请留意console及smart日志是否有异常信息"
		#echo "如果是停止状态，使用菜单的2>启动Console和3>启动Smart 选项重启进程"
		#echo "如果都已经启动，请进入${smartesbpath}bin路径查看console.log及out.smart；确认启动没有报错！（主要查看下ERROR和Exception）"
		#echo "所有操作完成，请打开监控查看并确认"
		cp ${smartesbpath}bin/console.log ${esblogpath}console.log
		cp ${smartesbpath}bin/out.smart ${esblogpath}smart.log
		echo "更新版本日志可见${esblogpath}menu.log"
		echo "console日志可见${esblogpath}console.log"
		echo "smart日志可见${esblogpath}smart.log"
		echo ""
		echo "" >> ${esblogpath}menu.log &
		
		echo "8.启动本机F5："
		echo "【`date '+%Y-%m-%d %H:%M:%S'`】8.启动本机F5：" >> ${esblogpath}menu.log &
		startOrStopF5 running	
}

#版本回退函数
rollbackVersion(){
	#echo "" > ${esbpath}esblog/menu.log &
	#echo "【`date '+%Y-%m-%d %H:%M:%S'`】开始版本回退:" >> ${esbpath}esblog/menu.log &
	echo "开始版本回退:1.停止ESB进程———>2.删除SmartESB目录———>3.解压备份包并启动"
	echo "注意：版本回退操作会删除ESB目录！！！请确认确实需要回退版本才进行操作！！！"
	while : ; do
		echo ""
		echo "步骤1.是否同意开始停止ESB进程，是则输入Y|N:"
		read KEY88
		if [ $KEY88 = Y ] || [ $KEY88 = y ];then
			#停止ESB进程
			stopESB
			echo ""
			echo "查看进程状态："
			checkProcess
			while : ; do
				echo ""
				echo "步骤2.是否同意开始删除SmartESB目录，是则输入Y|N:"
				read KEY888
				if [ $KEY888 = Y ] || [ $KEY888 = y ];then
					echo "删除${smartesbpath}目录"
					echo "rm -rf ${smartesbpath}"
					rm -rf ${smartesbpath}
					echo "删除${smartesbpath}成功"
					while : ; do
						echo ""
						echo "步骤3.是否同意开始解压备份包并启动，是则输入Y|N:"
						read KEY8888
						if [ $KEY8888 = Y ] || [ $KEY8888 = y ];then
							echo "请输入${esbpath}esb_bak中备份的tar包名字："
							while : ; do
								read BAKTAR
								echo "确认备份版本文件名字：${BAKTAR}，是则输入Y|y，不是则输入N|n"
								read KEY88888
								if [ $KEY88888 = Y ] || [ $KEY88888 = y ];then
									echo "cp ${esbpath}esb_bak/${BAKTAR} ${esbpath}"
									cp ${esbpath}esb_bak/${BAKTAR} ${esbpath}
									cd ${esbpath}
									echo "当前路径："
									pwd
									echo "tar -xvf ${BAKTAR}"
									tar -xvf ${BAKTAR}
									echo "解压完成，授权并启动ESB："
									chmod -R 754 SmartESB
									startESB	
									break
								elif [ $KEY88888 = N ] || [ $KEY88888 = n ];then
									echo "备份版本文件名字有误，请重新输入"
								else
									echo "your choose not in [Y|y] and [N|n]，请重新输入："
								fi
							done
							break
						elif [ $KEY8888 = N ] || [ $KEY8888 = n ]; then
							echo "不进行解压备份包,退出版本回退"
							echo "当前已经删除ESB！！！请尽快回退"
							break
						else
							#重新输入
							echo "重新输入"
						fi
					done
					break
				elif [ $KEY888 = N ] || [ $KEY888 = n ]; then
					echo "不进行删除SmartESB,退出版本回退"
					break
				else
					#重新输入
					echo "重新输入"
				fi
			done
			break
		elif [ $KEY88 = N ] || [ $KEY88 = n ]; then
			echo "不进行停止ESB进程,退出版本回退"
			break
		else
			#重新输入
			echo "重新输入"
		fi
	done
}

#更新tuxedo
updateTuxedo(){	
	echo "启动顺序：1停止tuxedo进程——>2备份当前tuxedo——>3解压更新包——>4启动tuxedo"
	while : ; do
		echo ""
		echo "步骤1.是否同意开始更新tuxedo，是则输入Y|N:"
		read KEYtuxedo
		if [ $KEYtuxedo = Y ] || [ $KEYtuxedo = y ];then
			#开始更新
			#echo "" > ${esblogpath}menu.log &
			#echo "【`date '+%Y-%m-%d %H:%M:%S'`】开始更新tuxedo版本:" >> ${esblogpath}menu.log &
			#echo "" >> ${esblogpath}menu.log &
			echo "1.停止tuxedo进程："
			#echo "【`date '+%Y-%m-%d %H:%M:%S'`】1.停止tuxedo进程：" >> ${esblogpath}menu.log &
			echo ""
			#echo "" >> ${esblogpath}menu.log &
			key16
			sleep 5
			echo "检查tuxedo进程:"
			#echo "检查tuxedo进程:" >> ${esblogpath}menu.log &
			if ps -ef|grep ULOG|grep -v grep -q
			then
				echo "tuxedo进程已启动..."
				echo "cd ${tuxedopath}"
				cd ${tuxedopath}
				#sleep 1
				echo "start execute stop.sh"
				sh ./stop.sh
				echo "end execute stop.sh"
				#echo "end execute stop.sh" >> ${esblogpath}menu.log &
			else
				echo "tuxedo进程已停止..."
				#echo "tuxedo进程已停止..." >> ${esblogpath}menu.log &
			fi
			echo ""
			#echo "" >> ${esblogpath}menu.log &


			cd ${tuxedouserpath}
			echo "2.备份当前tuxedo，并删除2个月之前的备份包:"
			#echo "" >> ${esblogpath}menu.log &
			#echo "【`date '+%Y-%m-%d %H:%M:%S'`】2.备份当前tuxedo，并删除2个月之前的备份包:" >> ${esblogpath}menu.log &
			mydate=`date +%Y%m%d`
			echo "将tuxedo备份至tuxedo${mydate}.tar"
			#echo "【`date '+%Y-%m-%d %H:%M:%S'`】将tuxedo备份至tuxedo${mydate}.tar" >> ${esblogpath}menu.log &
			sleep 1
			#pwd
			echo "execute tar -cvf ${tuxedouserpath}esbtux${mydate}.tar esbtux"
			tar -cvf ${tuxedouserpath}esbtux${mydate}.tar esbtux
			echo "将tuxedo备份至${tuxedouserpath}esbtux${mydate}.tar完成！"
			echo ""	
			
			echo "查找2个月之前的备份文件并删除..."
			#echo "【`date '+%Y-%m-%d %H:%M:%S'`】查找2个月之前的备份文件..." >> ${esblogpath}menu.log &
			#下面这个/home/esb和${esbpath}esb_bak的备份文件都清理，一个是以前的备份路径，一个是现在规范后的路径
			cd ${tuxedouserpath}
			#esbtux20161205.tar
			for file in `ls esbtux[0-9]*.tar`
			do
				datebackup=`date -d "${file:6:8}" +%s`
				datetwomonthsago=`date -d "2 months ago" +%s`
				datetwomonthsago2=`date -d "2 months ago" +%Y%m%d`
				if [ $datebackup -gt $datetwomonthsago ];then
					#echo "$file 日期为： ${file:6:8} > $datetwomonthsago2"
					:
				elif [  $datebackup -eq $datetwomonthsago ]; then
					#echo "$file 日期为： ${file:6:8} = $datetwomonthsago2"
					:
				else
					#echo "$file 日期为： ${file:6:8} < $datetwomonthsago2"
					echo "$file 为2个月前的备份文件，执行命令  rm -rf $file  删除该文件..."
					#echo "【`date '+%Y-%m-%d %H:%M:%S'`】$file 为2个月前的备份文件，执行命令  rm -rf $file  删除该文件..." >> ${esblogpath}menu.log &
					rm -rf $file
				fi
			done

		
			echo ""
			cd ${tuxedouserpath}
			echo "3.解压tuxedo更新包(将tuxedo的zip类型更新包放${tuxedouserpath}中):"
			unzipfile3
			echo ""
			while : ; do
				echo "是否还有其他版本文件，是则输入Y|y，不是则输入N|n："
				read KEY12
				if [ $KEY12 = Y ] || [ $KEY12 = y ];then
					echo "还有其他版本文件"
					unzipfile3
				elif [ $KEY12 = N ] || [ $KEY12 = n ];then
					echo "没有其他版本文件，继续下一步"
					break
				else
					echo "your choose not in [Y|y] and [N|n]，请重新输入："
				fi
			done

			echo ""
			echo "4.启动tuxedo:"
			cd ${tuxedouserpath}
			chmod -R 754 esbtux
			key15

			echo "更新tuxedo成功,请确认tuxedo是否启动成功:"
			if ps -ef|grep ULOG|grep -v grep -q
			then
				echo "tuxedo进程已启动..."
			else
				echo "tuxedo进程已停止..."
			fi
			echo ""
			break
		elif [ $KEYtuxedo = N ] || [ $KEYtuxedo = n ]; then
			#返回菜单
			echo "返回菜单"
			break
		else
			#重新输入
			echo "重新输入"
		fi
	done
}

checkPort(){
	#echo proport=${proport}
	arr=(${proport//,/ }) 
	for i in ${arr[@]}  
	do  
	    portandexplainArr=(${i//:/ })
	    #echo "端口=${portandexplainArr[0]},说明=${portandexplainArr[1]}"
	    cmd=`netstat -an|grep ${portandexplainArr[0]}`
	    if [ ! -n "$cmd" ] ; then
		#echo "${portandexplainArr[1]}的端口${portandexplainArr[0]}没有启动!!!!!!请检查!!!"
		echo -e "\033[43;31m${portandexplainArr[1]}的端口${portandexplainArr[0]}没有启动!!!!!!请检查，或联系ESB管理人员确认!!!!!! \033[0m"
	    else
		echo "${portandexplainArr[1]}的端口${portandexplainArr[0]}已经启动"
	    fi
	done  
}

telnetIPPort(){
	#echo telnetipport=${telnetipport}
	arr=(${telnetipport//,/ }) 
	>${esblogpath}netcat_result.txt
	for i in ${arr[@]}
	do
		ipportnodeArr=(${i//:/ })
		echo "" >>${esblogpath}netcat_result.txt
		echo "ip=${ipportnodeArr[0]},端口=${ipportnodeArr[1]},协议=${ipportnodeArr[2]}" >>${esblogpath}netcat_result.txt
		nc -v -w 1 -z ${ipportnodeArr[0]} ${ipportnodeArr[1]} >>${esblogpath}netcat_result.txt 2>&1 &
		sleep 1
	done
	echo ""
	#echo -e "\033[43;31m测试完成，查看网络连接情况(只显示失败的)： \033[0m"
	echo -e "\033[43;31m测试完成，查看网络连接情况： \033[0m"
	#cat ${esblogpath}netcat_result.txt

	#列出网络连接失败的
	grep "succeeded" ${esblogpath}netcat_result.txt -B1
	echo ""
	echo "============测试网络连接不成功的有：==============="
	echo ""
	grep "succeeded" ${esblogpath}netcat_result.txt -v|grep nc -B1
	
	#aaa="$( grep "succeeded" /home/esb/esblog/netcat_result.txt -v|grep nc -B1 )"
	#echo -e ${aaa//--/\n\n}
}


#菜单界面
ANSWER=Y
while [ $ANSWER = Y -o $ANSWER = y ]
do
	clear
	echo "             ESB运维菜单"
	echo "*********************************************"
	echo "     1>启动Mom            8>停止Console"
	echo "     2>启动Console        9>停止Smart"
	echo "     3>启动Smart          10>停止Journal"
	echo "     4>启动Journal        11>停止Flow"
	echo "     5>启动Flow           12>停止SubFlow"
	echo "     6>启动SubFlow        13>停止Mom"
	echo "     7>启动rsm            14>停止rsm"
	echo ""
	echo "     15>启动tuxedo(需要有操作tuxedo用户权限)"
	echo "     16>停止tuxedo(需要有操作tuxedo用户权限)"
	echo ""
	#echo "     S>一键启动SmartESB(StartAll)"
	echo "     R>一键重启SmartESB(RestartAll)"
	echo "     E>一键停止SmartESB(EndAll)"
	echo "     C>查看进程状态"
	echo "     P>查看端口状态"
	echo "     T>查看远程IP端口状态"
	echo "     U>更新SmartESB版本"
	echo "     H>回退SmartESB版本"
	echo "     UT>更新tuxedo版本"
	echo "     Q>退出"
	echo ""
	echo "     说明：1.MOM为消息中间件，Console为控制台进程，影响DB，Smart是ESB主进程，"
	echo "             Journal为流水，Flow为主流控，SubFlow为备流控，rsm是采集器。"
	echo "*********************************************"
	echo "     请输入选择项(1-14|15-16|R|E|C|P|U|H|T|Q|UT):  "

	read KEY
	case $KEY in
	1)
	echo "启动Mom..."
	;;
	2)
	echo "启动Console..."
	;;
	3)
	echo "启动Smart..."
	;;
	4)
	echo "启动Journal..."
	;;
	5)
	echo "启动Flow..."
	;;
	6)
	echo "启动SubFlow..."
	;;
	7)	
	echo "启动rsm..."
	;;
	8)
	echo "停止Console..."
	;;
	9)
	echo "停止Smart..."
	;;
	10)
	echo "停止Journal..."
	;;
	11)
	echo "停止Flow..."
	;;
	12)
	echo "停止SubFlow..."
	;;
	13)
	echo "停止Mom..."
	;;
	14)
	echo "停止rsm..."
	;;
	15)
	echo "启动tuxedo..."
	;;
	16)
	echo "停止停止tuxedo..."
	;;

	#S|s)
	#echo "一键启动SmartESB..."
	#;;

	E|e)
	echo "一键停止SmartESB..."
	;;
	R|r)
	echo "一键重启SmartESB..."
	;;
	C|c)
	echo "开始检查进程..."
	;;
	P|p)
	echo "开始检查端口..."
	;;
	T|t)
	echo "开始测试远程端口连通性,请稍等..."
	;;
	U|u)
	echo "开始更新ESB版本..."
	;;
	H|h)
	echo "开始回退ESB版本..."
	;;
	UT|ut|uT|Ut)
	echo "开始更新tuxedo版本..."
	;;
	Q|q)
	exit
	;;

	*)
	echo "your chose not in [1-16, E|e, R|r, Q|q, C|c, P|p, U|u, H|h ,T|t ,UT|ut]"
	esac 

	if [ $KEY = 1 ]
	then
		key1
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 2 ]
	then
		key2
		echo "按回车键继续..."
		read
	fi
	
	if [ $KEY = 3 ]
	then
		key3
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 4 ]
	then
		key4
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 5 ]
	then
		key5
		echo "按回车键继续..."
		read
	fi
	
	if [ $KEY = 6 ]
	then
		key6
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 7 ]
	then
		key7
		echo "按回车键继续..."
		read
	fi
	
	if [ $KEY = 8 ]
	then
		key8
		echo "按回车键继续..."
		read
	fi
	
	if [ $KEY = 9 ]
	then
		key9
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 10 ]
	then
		key10
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 11 ]
	then
		key11
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 12 ]
	then
		key12
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 13 ]
	then
		key13
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 14 ]
	then
		key14
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 15 ]
	then
		key15
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = 16 ]
	then
		key16
		echo "按回车键继续..."
		read
	fi

	#S>一键启动SmartESB(StartAll)
	#if [ $KEY = S ] || [ $KEY = s ]
	#then
	#	startAll
	#	echo "按回车键继续..."
	#	read
	#fi

	#E>一键停止SmartESB(EndAll)
	if [ $KEY = E ] || [ $KEY = e ]
	then
		endAll
		echo "按回车键继续..."
		read
	fi

	#R>一键重启SmartESB(RestartAll)
	if [ $KEY = R ] || [ $KEY = r ]
	then
		endAll
		sleep 3
		startAll
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = C ] || [ $KEY = c ]
	then
		checkProcess
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = P ] || [ $KEY = p ]
	then
		checkPort
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = T ] || [ $KEY = t ]
	then
		telnetIPPort
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = U ] || [ $KEY = u ]
	then
		update
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = H ] || [ $KEY = h ]
	then
		rollbackVersion
		echo "按回车键继续..."
		read
	fi

	if [ $KEY = UT ] || [ $KEY = ut ] || [ $KEY = Ut ] || [ $KEY = uT ]
	then
		updateTuxedo
		echo "按回车键继续..."
		read
	fi
done


#本机F5启停demo
#startOrStopF5 stop
#startOrStopF5 running