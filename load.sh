httperf --server="www.localsmokehk.com" --uri="/helloweb.jsp" --rate="4" --num-con="2515" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res1;
httperf --server="www.localsmokehk.com" --uri="/hello.jsp" --rate="4" --num-con="2015" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res2;
httperf --server="www.localsmokehk.com" --uri="/favicon.ico" --rate="4" --num-con="93" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res3;
httperf --server="www.localsmokehk.com" --uri="/" --rate="4" --num-con="66" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res4;
httperf --server="www.localsmokehk.com" --uri="/api/cart/summary" --rate="4" --num-con="53" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res5;
httperf --server="www.localsmokehk.com" --uri="/?sid=s1" --rate="4" --num-con="41" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res6;
httperf --server="www.localsmokehk.com" --uri="/rest/api/cartResource/otherApplicableOffers" --rate="4" --num-con="11" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res7;
httperf --server="www.localsmokehk.com" --uri="/store/durex/playRange.jsp" --rate="4" --num-con="9" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res8;
httperf --server="www.localsmokehk.com" --uri="/api/cart/productVariant/add" --rate="4" --num-con="7" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res9;
httperf --server="www.localsmokehk.com" --uri="/rest/api/cartResource/roles" --rate="4" --num-con="6" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res10;
httperf --server="www.localsmokehk.com" --uri="/robots.txt" --rate="4" --num-con="5" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res11;
httperf --server="www.localsmokehk.com" --uri="/personal-care/sexual-care/condoms-for-men?navKey=SCT-pc-cd" --rate="4" --num-con="5" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res12;
httperf --server="www.localsmokehk.com" --uri="/beta/cart/Cart.action" --rate="4" --num-con="5" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res13;
httperf --server="www.localsmokehk.com" --uri="/sv/ultimate-nutrition-prostar-100-whey-protein/SP-9929?navKey=VRNT-45204" --rate="4" --num-con="4" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res14;
httperf --server="www.localsmokehk.com" --uri="/sv/sklz-launch-pad/SP-12804?productReferrerId=3&productPosition=12/7" --rate="4" --num-con="4" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res15;
httperf --server="www.localsmokehk.com" --uri="/sports-nutrition/protein/whey-protein?navKey=CL-276&pageNo=1&perPage=24" --rate="4" --num-con="4" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res16;
httperf --server="www.localsmokehk.com" --uri="/sports-nutrition?navKey=CP-nt-sn" --rate="4" --num-con="4" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res17;
httperf --server="www.localsmokehk.com" --uri="/product/sklz-launch-pad/SPT1449?productReferrerId=3&productPosition=12/7" --rate="4" --num-con="4" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res18;
httperf --server="www.localsmokehk.com" --uri="/sv/vector-x-pro-speed-cricket-shoes/SP-12462?navKey=VRNT-20288" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res19;
httperf --server="www.localsmokehk.com" --uri="/sv/matrix-whey-protein/SP-10160?navKey=VRNT-48874" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res20;
httperf --server="www.localsmokehk.com" --uri="/sv/matrix-whey-protein/SP-10160?navKey=VRNT-15805" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res21;
httperf --server="www.localsmokehk.com" --uri="/sv/cosco-chevron-ring-bat-grip/SP-12611?productReferrerId=3&productPosition=51/2" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res22;
httperf --server="www.localsmokehk.com" --uri="/sports-nutrition?navKey=CP-nt-sn&itracker=w:emenu|;p:1|;c:sports-nutrition|;" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res23;
httperf --server="www.localsmokehk.com" --uri="/sports-n-fitness/fitness-equipment/cardio-vascular-equipments/treadmills?navKey=SCT-SPT-CVE-TM" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res24;
httperf --server="www.localsmokehk.com" --uri="/home.action" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res25;
httperf --server="www.localsmokehk.com" --uri="/core/cart/Cart.action" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res26;
httperf --server="www.localsmokehk.com" --uri="/api/ac/results?q=gn&noRs=10" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res27;
httperf --server="www.localsmokehk.com" --uri="/api/ac/results?q=gnc&noRs=10" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res28;
httperf --server="www.localsmokehk.com" --uri="/api/ac/results?q=gnc%20&noRs=10" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res29;
httperf --server="www.localsmokehk.com" --uri="/api/ac/results?q=BaByliss%20p&noRs=10" --rate="4" --num-con="3" --num-call="1" >> result &
pid=$!;
wait $pid;
cp result /sync_folder/res30;
