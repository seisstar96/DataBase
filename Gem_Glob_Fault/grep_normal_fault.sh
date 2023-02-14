#!bin/bash
# 
rm *.dat
grep -n "|Reverse|" gem_active_faults.gmt.txt > normal_no.dat
grep -n ">" gem_active_faults.gmt.txt> all_lat_lon.dat
awk -F':' '{print $1}' all_lat_lon.dat > all_lat_lon1.dat
sed 's/^/2 /g' all_lat_lon1.dat > all_lat_lon2.dat
sed 's/$/ x/g' all_lat_lon2.dat > all_lat_lon3.dat
awk -F':' '{print $1}' normal_no.dat > normal_num.dat

    for event in $(cat normal_num.dat | awk '{print NR}')
       do 
          event_num=`cat normal_num.dat | awk 'NR=="'"$event"'"{print $1}'`
          event_1=$(($event_num-1))
          ev1=`grep -n "2 $event_1 x"  all_lat_lon3.dat  | awk -F':' '{print $1}'`
          ev2=$(($ev1+1)) 
          ev2=`head -n$(($ev1+1))  all_lat_lon1.dat  | tail -1`
          echo $event_1 $ev2 >> new_lat_lon.dat 
          
       done
       
      for event in $(cat new_lat_lon.dat | awk '{print NR}')
       do
          event1=`cat new_lat_lon.dat | awk 'NR=="'"$event"'"{print $1}'`
          event2=`cat new_lat_lon.dat | awk 'NR=="'"$event"'"{print $2}'`
       #   echo $event1 $event2
          event11=$(($event1-1))
          event22=$(($event2))
          awk "NR>$event11 && NR<$event22 " gem_active_faults.gmt.txt  >> final_fault.dat    
      done
