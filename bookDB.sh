#!/bin/bash

clear

function write
{
	#iteration 1 code:
	#I=0
	#while test ${#text[*]} != 0
	#do
	#	if test "${text[$I]}" != ""
	#	then
	#		echo ${text[$I]}
	#		unset text[$I]
	#	fi
	#	let I=I+1
	#done>BookDB.txt
	
	#final code:
	local IFS=$'\n'
	echo "${text[*]}">BookDB.txt
}

function press_enter
{
    echo ""
    echo -n "<Display main menu again ...>"
    read
    clear
}

function add_new_book
{
    #echo "1) add_new_book"
	local temp
	printf "\nTitle : "
	read temp[0]
	printf "\nAuthor : "
	read temp[1]
	local IFS=:

	#precision search: title and autor must match exactly, search term begin with ^ and end with $. ignore case
	if (printf "%s\n" ${text[*]}|tr [:lower:] [:upper:]|grep "`echo ^${temp[0]}$|tr [:lower:] [:upper:]`">/dev/null) && (printf "%s\n" ${text[*]}|tr [:lower:] [:upper:]|grep "`echo ^${temp[1]}$|tr [:lower:] [:upper:]`">/dev/null)
	then
		printf "\nError! Book already exists!"
	else
		printf "\nPrice : "
		read temp[2]
		printf "\nQty Available : "
		read temp[3]
		printf "\nQty Sold : "
		read temp[4]
		text+=("`printf "%s:%s:%s:%s:%s" "${temp[0]}" "${temp[1]}" "${temp[2]}" "${temp[3]}" "${temp[4]}"`")
		printf "\nNew book title \'%s\' added successfully!" "${temp[0]}"
	fi
}

remove_existing_book()
{
    #echo "2) remove_existing_book"
	local temp
	printf "\nTitle : "
	read temp[0]
	printf "\nAuthor : "
	read temp[1]
	local IFS=:
	I=0
	NUM=${#text[*]}
	while test $I -lt ${#text[*]}
	do
		if (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ^${temp[0]}$|tr [:lower:] [:upper:]`">/dev/null) && (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ^${temp[1]}$|tr [:lower:] [:upper:]`">/dev/null)
		then
			unset text[$I]
			printf "\nBook Title \'${temp[0]}\' removed successfully!"
			break 1
		fi
		let I=I+1
	done
	if test $NUM -eq ${#text[*]}
	then
		printf "\nError! Book does not exists!"
	fi
	#reconstrcut array to reset index:
	IFS=$'\n'
	text=(`echo "${text[*]}"`)
}

update_book_info()
{
    #echo "3) update_book_info"
	local temp
	printf "\nTitle : "
	read temp[0]
	printf "\nAuthor : "
	read temp[1]
	local IFS=:
	I=0
	while test $I -lt ${#text[*]}
	do
		if (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ^${temp[0]}$|tr [:lower:] [:upper:]`">/dev/null) && (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ^${temp[1]}$|tr [:lower:] [:upper:]`">/dev/null)
		then
			printf "\nBook found!\n"
			temp=(${text[$I]})
			IFS=$'\n'
			local arr=(`echo "${text[*]}"`)
			unset arr[$I]
			local buffer=`echo "${arr[*]}"`
			local titles=`echo "$buffer"|cut -f1 -d:`
			local authors=`echo "$buffer"|cut -f2 -d:`
			J=0
			while test $J != f
			do
				printf "\n\ta) Update Title\n\tb) Update Author\n\tc) Update Price\n\td) Update Qty Available\n\te) Update Qty sold\n\tf) Back to main menu\n\nPlease enter your choice : "
				read J
				if test $J = a
				then
					printf "\nNew Title : "
					read temp[0]
					if (echo "$titles"|tr [:lower:] [:upper:]|grep "`echo ^${temp[0]}$|tr [:lower:] [:upper:]`">/dev/null) && (echo "$authors"|tr [:lower:] [:upper:]|grep "`echo ^${temp[1]}$|tr [:lower:] [:upper:]`">/dev/null)
					then
						printf "\nBook's Title and Author already exist!"
						temp[0]=`echo ${text[$I]}|cut -f1 -d:`
					else
						printf "\nBook's Title has been updated successfully!"
					fi
				elif test $J = b
				then
					printf "\nNew Author : "
					read temp[1]
					if (echo "$titles"|tr [:lower:] [:upper:]|grep "`echo ^${temp[0]}$|tr [:lower:] [:upper:]`">/dev/null) && (echo "$authors"|tr [:lower:] [:upper:]|grep "`echo ^${temp[1]}$|tr [:lower:] [:upper:]`">/dev/null)
					then
						printf "\nBook's Title and Author already exist!"
						temp[1]=`echo ${text[$I]}|cut -f2 -d:`
					else
						printf "\nBook's Author has been updated successfully!"
					fi
				elif test $J = c
				then
					printf "\nNew Price : "
					read temp[2]
					printf "\nBook's Price has been updated successfully!"
				elif test $J = d
				then
					printf "\nNew Qty Available : "
					read temp[3]
					printf "\nBook's Qty Available has been updated successfully!"
				elif test $J = e
				then
					printf "\nNew Qty Sold : "
					read temp[4]
					printf "\nBook's Qty Sold has been updated successfully!"
				elif test $J = f
				then
					echo ""
				else
					printf "\ninvalid option!please try again!\n"
				fi
			done
			text[$I]=`printf "%s:%s:%s:%s:%s" "${temp[0]}" "${temp[1]}" "${temp[2]}" "${temp[3]}" "${temp[4]}"`
			break 1
		fi
	let I=I+1
	done
	if test $I -eq ${#text[*]}
	then
	printf "\nError! Book does not exists!"
	fi
}

search_book()
{
    #echo "4) search_book"
	local temp
	printf "\nTitle : "
	read temp[0]
	printf "\nAuthor : "
	read temp[1]
	I=0
	local found
	local IFS=:
	local tab
	if (test "${temp[0]}" = "")&&(test "${temp[1]}" != "")
	then
		#echo 0
		while test $I -lt ${#text[*]}
		do
			if (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ${temp[1]}|tr [:lower:] [:upper:]`">/dev/null)
			then 
				tab=(${text[$I]})
				found+=("`printf "%s, %s, $%s, %s, %s" ${tab[0]} ${tab[1]} ${tab[2]} ${tab[3]} ${tab[4]}`")
			fi
			let I=I+1
		done
	elif (test "${temp[1]}" = "")&&(test "${temp[0]}" != "")
	then
		#echo 1
		while test $I -lt ${#text[*]}
		do
			if (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ${temp[0]}|tr [:lower:] [:upper:]`">/dev/null)
			then 
				tab=(${text[$I]})
				found+=("`printf "%s, %s, $%s, %s, %s" ${tab[0]} ${tab[1]} ${tab[2]} ${tab[3]} ${tab[4]}`")
			fi
			let I=I+1
		done
	else 
		#echo 3
		while test $I -lt ${#text[*]}
		do
			if (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ${temp[0]}|tr [:lower:] [:upper:]`">/dev/null) || (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ${temp[1]}|tr [:lower:] [:upper:]`">/dev/null)
			then 
				tab=(${text[$I]})
				found+=("`printf "%s, %s, $%s, %s, %s" ${tab[0]} ${tab[1]} ${tab[2]} ${tab[3]} ${tab[4]}`")
			fi
			let I=I+1
		done
	fi
	if test ${#found[*]} -eq 0
	then
		printf "\nBook not found!"
	else
		I=0
		printf "\nFound ${#found[*]} records :\n"
		while test $I -lt ${#found[*]}
		do
			echo ${found[$I]}
			let I=I+1
		done
	fi
}

process_book_sold()
{
    #echo "5) process_book_sold"
	local temp
	printf "\nTitle : "
	read temp[0]
	printf "\nAuthor : "
	read temp[1]
	local IFS=:
	I=0
	local sold
	while test $I -lt ${#text[*]}
	do
		if (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ^${temp[0]}$|tr [:lower:] [:upper:]`">/dev/null) && (printf "%s\n" ${text[$I]}|tr [:lower:] [:upper:]|grep "`echo ^${temp[1]}$|tr [:lower:] [:upper:]`">/dev/null)
		then
			temp=(${text[$I]})
			printf "\nNo of copies sold : "
			read sold
			printf "\nCurrent book info :\n%s, %s, $%s, %s, %s\n" ${temp[0]} ${temp[1]} ${temp[2]} ${temp[3]} ${temp[4]}
			let temp[3]=temp[3]-sold
			let temp[4]=temp[4]+sold
			printf "\nNew book info :\n%s, %s, $%s, %s, %s\n" ${temp[0]} ${temp[1]} ${temp[2]} ${temp[3]} ${temp[4]}
			if test ${temp[3]} -ge 0
			then
				text[$I]=`printf "%s:%s:%s:%s:%s" "${temp[0]}" "${temp[1]}" "${temp[2]}" "${temp[3]}" "${temp[4]}"`
			else
				printf "\nError! No. of copies sold more than Qty Available!\n"
			fi
			break
		fi
	let I=I+1
	done
	if test $I -eq ${#text[*]}
	then
	printf "\nError! Book does not exists!"
	fi
}

inventory_summary_report()
{
    #echo "6) inventory_summary_report"
	
	printf "%-50s%-20s%-15s%-15s%-15s%-15s\n" "Title" "Author" "Price" "Qty Avail." "Qty Sold" "Total Sales"
	printf "%140c\n"|tr \  -
	I=0
	local IFS=:
	local tab
	while test $I -lt ${#text[*]}
	do
		#if test "${text[$I]}" != ""
		#then
			j=0
				for t in ${text[$I]}
				do
					tab[$j]=$t
					let j=j+1
				done
			printf "%-50s%-20s$%-15.2f%-15d%-15d%-15.2f\n" ${tab[0]} ${tab[1]} ${tab[2]} ${tab[3]} ${tab[4]} `echo ${tab[2]} \* ${tab[4]}|bc -l`
		#fi
		let I=I+1
	done
}

load()
{
	#it is interesting that all three methods below produce the same result.
	
	#iteration 1 code:
	#I=0
	#while read
	#do
	#	text[$I]=$REPLY
	#	let I=I+1
	#done < BookDB.txt
	
	#iteration 2 code:
	#buffer=`cat BookDB.txt`
	#local IFS=$'\n'
	#text=(`echo "$buffer"`)
	
	#final code:
	local IFS=$'\n'
	text=(`cat BookDB.txt`)
}

#enhancement sub function:
display_sort()
{
	printf "%-50s%-20s%-15s%-15s%-15s%-15s\n" "Title" "Author" "Price" "Qty Avail." "Qty Sold" "Total Sales"
	printf "%140c\n"|tr \  -
	I=0
	local IFS=:
	local tab
	while test $I -lt ${#data[*]}
	do
		tab=(${data[$I]})
		printf "%-50s%-20s$%-15.2f%-15d%-15d%-15.2f\n" ${tab[0]} ${tab[1]} ${tab[2]} ${tab[3]} ${tab[4]} ${tab[5]}
		let I=I+1
	done
}

#extra enhancement feature, sorted inventory report.
sorted_report()
{
	local IFS=$'\n'
	local buffer=`echo "${text[*]}"`
	local data=(`echo "$buffer"`)
	local var1=(`echo "$buffer"|cut -f3 -d:`)
	local var2=(`echo "$buffer"|cut -f5 -d:`)
	I=0
	while test $I -lt ${#data[*]}
	do
		data[$I]+=:`echo ${var1[$I]} \* ${var2[$I]}|bc -l`
		let I=I+1
	done
	buffer=`echo "${data[*]}"`
	local op=0
	while test $op != q
	do
		printf "\n\ta) sort by Title(asc)\n\tb) sort by Title(dsc)\n\tc) sort by Author(asc)\n\td) sort by Author(dsc)\n\te) sort by Price(asc)\n\tf) sort by Price(dsc)\n\tg) sort by Qty Available(asc)\n\th) sort by Qty Available(dsc)\n\ti) sort by Qty Sold(asc)\n\tj) sort by Qty Sold(dsc)\n\tk) sort by Total Sales(asc)\n\tl) sort by Total Sales(dsc)\n\tq) return to main menu\n\n\tselect view : "
		read op
		if test $op = a
		then
			data=(`echo "$buffer" | sort -t':' -k1`)
			display_sort|less
		elif test $op = b
		then
			data=(`echo "$buffer" | sort -t':' -r -k1`)
			display_sort|less
		elif test $op = c
		then
			data=(`echo "$buffer" | sort -t':' -k2`)
			display_sort|less
		elif test $op = d
		then 
			data=(`echo "$buffer" | sort -t':' -r -k2`)
			display_sort|less
		elif test $op = e
		then
			data=(`echo "$buffer" | sort -t':' -n -k3`)
			display_sort|less
		elif test $op = f
		then
			data=(`echo "$buffer" | sort -t':' -r -n -k3`)
			display_sort|less
		elif test $op = g
		then
			data=(`echo "$buffer" | sort -t':' -n -k4`)
			display_sort|less
		elif test $op = h
		then
			data=(`echo "$buffer" | sort -t':' -r -n -k4`)
			display_sort|less
		elif test $op = i
		then
			data=(`echo "$buffer" | sort -t':' -n -k5`)
			display_sort|less
		elif test $op = j
		then
			data=(`echo "$buffer" | sort -t':' -r -n -k5`)
			display_sort|less
		elif test $op = k
		then
			data=(`echo "$buffer" | sort -t':' -n -k6`)
			display_sort|less
		elif test $op = l
		then
			data=(`echo "$buffer" | sort -t':' -r -n -k6`)
			display_sort|less
		elif test $op = q
		then
			echo ""
		else
			printf "\ninvalid option!please try again!\n"			
		fi
	done
}

#This is the main menu code

if ! [ -f BookDB.txt ] ; then #check existance of bookdb file, create the file if not exist else continue
touch BookDB.txt
fi

load

#Display menu options and wait for selection
selection=0
until [ "$selection" = "8" ]; do
    echo ""
    echo ""
    echo "Advanced Book Inventory System"
    echo ""
    echo ""
    echo "	1.) Add new book"
    echo "	2.) Remove existing book info"
    echo "	3.) Update book info and quantity"
    echo "	4.) Search for book by title/author"
    echo "	5.) Process a book sold"
    echo "	6.) Inventory summary report"
	echo "	7.) sorted Inventory summary report"
    echo "	8.) Quit"
	echo ""

    echo -n "Please enter your option: "
    read selection
    echo ""
    case $selection in
		1 ) add_new_book ; press_enter; write;;
		2 ) remove_existing_book ; press_enter; write;;
		3 ) update_book_info ; press_enter; write;;
		4 ) search_book ; press_enter;;
		5 ) process_book_sold;press_enter; write;;
		6 ) inventory_summary_report|less;;
		7 )	sorted_report;;
		8 ) break ;;
		* ) tput setf 4;echo "Please enter 1, 2, 3, 4, 5, 6, 7 or 8";tput setf 3; press_enter
    esac
done

