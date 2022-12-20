EE 368 Project README file
Shiwen Zhang

To run the program, 

1) open ‘project.m’

2) Line 31: change the value of k to run different image. k = 17 is used in the project report. 

3) To see intermediate results, uncomment Line 78-79 (bounding box), 81-82 (region image), 90-91 (edge image), 95-99 (Hough transform), 107 (peaks).  


Number		image file 			   	sign		  detection result
1	'stopAhead_1324866399.avi_image4.png'		stop ahead		correct
2	'laneEnds_1324867138.avi_image3.png'		land ends		correct
3	'merge_1324867161.avi_image1.png'		merge			correct
4	'speedLimit_1323896613.avi_image27.png'		right curve		correct
5	'signalAhead_1323896726.avi_image26.png'	signal ahead		correct
6	'dip_1323804622.avi_image0.png'			dip			correct
7	'intersection_1324866305.avi_image1.png'	intersection		incorrect
8	'pedestrian_1323896918.avi_image17.png'		pedestrian 		incorrect
9	'addedLane_1323820177.avi_image1.png'		added lane		incorrect
10	'yieldAhead_1323821551.avi_image17.png'		yield ahead		incorrect
11	'stop_1323812975.avi_image21.png'		stop 			correct
12	'stop_1323896588.avi_image26.png'		stop			correct
13	'stop_1324866406.avi_image13.png'		stop			correct
14	'stop_1324866481.avi_image20.png'		stop			correct
15	'stop_1323896696.avi_image7.png'		stop			incorrect
16	'stop_1323821112.avi_image27.png'		stop			correct
17	'stop_1323821086.avi_image14.png'		stop			correct
18	'stop_1323812975.avi_image18.png'		stop			correct
19	'stop_1323823007.avi_image19.png'		stop			correct
20	'stop_1323824828.avi_image20.png'		stop			incorrect