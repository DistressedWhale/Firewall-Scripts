choice=" "
re='^[1-3]$'

echo -en "\nWould you like to: \n1. Add subnets\n2. Add Ranges\n3. Rename Objects\n> " ; read choice
    
while [[ !($choice =~ $re) ]] ; do
    echo -en "Invalid choice, please enter a number from 1 to 3\n> " ; read choice
done

echo -en "Enter the filename to use as input\n> " ; read filename

case $choice in 
    1) 
        while read n || [ -n "$n" ] ; do
            first=$(echo $n | cut -d "," -f 1);
            second=$(echo $n | cut -d "," -f 2);
            echo config firewall address
            echo  edit '"'$first'"';
            echo set subnet $second;
            echo end
        done < $filename
    ;;

    2) 
        max_range=256
        while read n || [ -n "$n" ] ; do
            first=$(echo "$n" | cut -d "," -f 1);
            second=$(echo $n | cut -d "," -f 2);
            third=$(echo $n | cut -d"," -f 3);
            
            #Calculate ip range
            IFS=. read a b c d <<< $second
            IFS=. read e f g h <<< $third

            range=$(( $h - $d + ($g - $c) * 256 + ($f - $b) * 65536 + ($e - $a) * 16777216 ))
            if (( $range > $max_range )) ; then
                echo "--IP range of $range between $second and $third too high, skipping--"
            else 
                echo config firewall address
                echo edit edit '"'$first'"';
                echo set type iprange   
                echo set start-ip $second
                echo set end-ip $third
                echo end
            fi

        done < $filename
    ;;

    3) 
        echo "config firewall address"
        while read n || [ -n "$n" ]; do
            first=$(echo $n | cut -d "," -f 1);
            second=$(echo $n | cut -d "," -f 2);
            echo rename $first to $second;
            done < $filename
        echo "end"
    ;;
esac