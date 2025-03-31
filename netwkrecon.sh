#!/bin/bash
#3-06-2025
#CI 201 01PC
#Aden Hilderbrand
#
#This program recons ip addresses and ports
#enjoy

# Network Reconnaissance Functions #

pingSweep(){
# start the Ping Sweep Menu
    echo "----------- Ping Sweep -----------"
echo "Please enter the first number sequence of the IP address to be scanned."
read firstSection

echo "Now the second."
read -p "${firstSection}." secondSection

echo "Now the third."
read -p "${firstSection}.${secondSection}." thirdSection

address="${firstSection}.${secondSection}.${thirdSection}"
echo -e "I am going to search ${address}.xxx\n"

read -p "Proceed? (Y/n)" YorN

# if YorN is empty or 'N/n', go back to selection
if [[ -z "$YorN" || "$YorN" == 'n' || "$YorN" == 'N' ]]; then
    echo "Back to selection"
else

# re-direct date to pingresults.txt. Not initializing!!
# add a little whitespace between dates
    echo >> ${pingfile}
    date >> ${pingfile}

# for loop for starts pinging here
    for target in {1..255}; do
        echo "Pinging ${address}.${target} . . ."

# if statement both checks if the ping comes back with an error or success AND sends output to /dev/null
        if ping -c 1 ${address}.${target} &> /dev/null; then
            # added some color codes for readability. up is green down is red
            echo -e "${address}.${target} \e[32mis up\e[0m" >> ${pingfile}
        else
            echo -e "${address}.${target} \e[31mis down\e[0m" >> ${pingfile}
        fi
    done
    echo "Ping Sweep Complete. Results logged in ${pingfile}"
fi

}

portScan(){
echo "----------- Port Scan -----------"
# NEED TO USE BASH TO USE /dev/tcp FUNCTIONALITY. DOES NOT WORK WITH ZSH
echo PLEASE MAKE SURE YOURE USING BASH or else this will not work
echo "Please enter the host you would like to scan (format: xxx.xxx.xxx.xxx)"
read IP

#add date to portfile
echo >> ${portfile}
date >> ${portfile}
for port in {1..1023}; do # port scan loop begin
    echo "Scanning ${IP}:${port} . . ."

    if (echo > /dev/tcp/${IP}/${port}) &> /dev/null; then
        echo -e "Port ${port} on ${IP} \e[32mis up\e[0m" >> ${portfile}
    else
        echo -e "Port ${port} on ${IP} \e[31mis down\e[0m" >> ${portfile}
   fi
done # end port scan loop
echo "Port Scan Complete. Results logged in ${portfile}"
}

printScanResults(){
echo "----------- Print Scan Results -----------"

select choice in "Display Ping Sweep Results" "Display Port Scan Results" "Remove Ping Sweep Results File" "Remove Port Scan Results File" "Main Menu"; do
    case $choice in
        "Display Ping Sweep Results")
            if less ${pingfile} &> /dev/null; then
                #display file normally
                less ${pingfile}
            else
                echo "Ping Sweep Results File Not Found"
            fi
            printScanResults
            ;;
        "Display Port Scan Results")
            if less ${portfile} &> /dev/null; then
                #display file normally
                less ${portfile}
            else
                echo "Port Scan Results File Not Found"
            fi
            printScanResults
            ;;
        "Remove Ping Sweep Results File")
            if rm ${pingfile} &> /dev/null; then
                echo -e "\nPing Sweep Results File Removed"
            else
                echo -e "\nError: Ping Sweep Results File Not Found"
            fi
            printScanResults
            ;;
        "Remove Port Scan Results File")
            if rm ${portfile} &> /dev/null; then
                echo -e "\nPort Scan Results File Removed"
            else
                echo -e "\nError: Port Scan Results File Not Found"
            fi
            printScanResults
            ;;
        "Main Menu")
            echo "Returning to Main Menu . . ." 
            mainMenu
            ;;
        *)
            echo "Invalid option"
            printScanResults
            ;;
            
    esac
done

}

# Main Menu Function #
mainMenu(){
echo "----------- Main Menu -----------"
select choice in "Ping Sweep" "Port Scan" "Print Scan Results" "Exit"; do
    case $choice in 
        "Ping Sweep") 
            pingSweep 
            # when complete, return to mainMenu
            mainMenu
            ;;
        "Port Scan") 
            portScan 
            # when complete, return to mainMenu
            mainMenu
            ;;
        "Print Scan Results") 
            printScanResults 
            # when complete, return to mainMenu
            mainMenu
            ;;
        "Exit") 
            echo "Exiting the program!!"
            exit 0 
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
}

# this is where the script actually begins
# initialize variables for logfiles
portfile=portresults.txt
pingfile=pingresults.txt

# start main menu
mainMenu
