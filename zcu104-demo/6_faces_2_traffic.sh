# 6_faces_2_traffic.sh
# Copyright 2023 Carnegie Mellon University.
# NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
# Released under a MIT (SEI)-style license, please see license.txt or contact permission@sei.cmu.edu for full terms.
# [DISTRIBUTION STATEMENT A] This material has been approved for public release and unlimited distribution.  Please see Copyright notice for non-US Government use and distribution.
# This Software includes and/or makes use of the following Third-Party Software subject to its own license:
# 1. 8_ch_traffic_face.sh (https://www.xilinx.com/member/forms/download/design-license-zcu104-vcu-8channel.html?filename=zcu104_vcu_ml_2019_2_demo.zip) Copyright 2018 Xilinx.
# DM23-0084
# License.txt file:
# 6_faces_2_traffic.sh
# Copyright 2023 Carnegie Mellon University.
# MIT (SEI)
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 6_faces_2_traffic.sh includes and/or can make use of certain third party software ("Third Party Software"). The Third Party Software that is used by 6_faces_2_traffic.sh is dependent upon your system configuration, but typically includes the software identified below. By using 6_faces_2_traffic.sh, You agree to comply with any and all relevant Third Party Software terms and conditions contained in any such Third Party Software or separate license file distributed with such Third Party Software. The parties who own the Third Party Software ("Third Party Licensors") are intended third party beneficiaries to this License with respect to the terms applicable to their Third Party Software. Third Party Software licenses only apply to the Third Party Software and not any other portion of 6_faces_2_traffic.sh or 6_faces_2_traffic.sh as a whole.
# This material is based upon work funded and supported by the Department of Defense under Contract No. FA8702-15-D-0002 with Carnegie Mellon University for the operation of the Software Engineering Institute, a federally funded research and development center.
# The view, opinions, and/or findings contained in this material are those of the author(s) and should not be construed as an official Government position, policy, or decision, unless designated by other documentation.
# NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
# [DISTRIBUTION STATEMENT A] This material has been approved for public release and unlimited distribution.  Please see Copyright notice for non-US Government use and distribution.
# This Software includes and/or makes use of the following Third-Party Software subject to its own license:
# 1. 8_ch_traffic_face.sh (https://www.xilinx.com/member/forms/download/design-license-zcu104-vcu-8channel.html?filename=zcu104_vcu_ml_2019_2_demo.zip) Copyright 2018 Xilinx.
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# Except as contained in this notice, the name of the Xilinx shall not be used in advertising or otherwise to promote the sale or use or other dealings in this Software without prior written authorization from Xilinx. 
# DM23-0084


killall -9 modetest > /dev/null 2>&1
sleep 1
modetest -D a2070000.v_mix -s 42:1920x1080@AR24 &

WIDTH=480
HEIGHT=360
WOFF=0
HOFF=60

gst-launch-1.0 filesrc location=face_parades/fChile_480p.mp4 ! qtdemux ! h264parse ! omxh264dec internal-entropy-buffers=3 ! xlnxvideoscale !  \
	video/x-raw, width=$WIDTH, height=$HEIGHT, format=BGR !  \
	sdxfacedetect ! queue ! \
	fpsdisplaysink video-sink="kmssink plane-id=30 bus-id="a2070000.v_mix" render-rectangle=\"<$WOFF,$HOFF,$WIDTH,$HEIGHT>\"" text-overlay=false sync=false \
	filesrc location=face_parades/fChina1_480p.mp4 ! qtdemux ! h264parse ! omxh264dec internal-entropy-buffers=3 ! xlnxvideoscale !  \
	video/x-raw, width=$WIDTH, height=$HEIGHT, format=BGR !  \
	sdxfacedetect ! queue ! \
	fpsdisplaysink video-sink="kmssink plane-id=31 bus-id="a2070000.v_mix" render-rectangle=\"<$(($WOFF + $WIDTH)),$HOFF,$WIDTH,$HEIGHT>\"" text-overlay=false sync=false	\
	filesrc location=face_parades/fFrance1_480p.mp4 ! qtdemux ! h264parse ! omxh264dec internal-entropy-buffers=3 ! xlnxvideoscale !  \
	video/x-raw, width=$WIDTH, height=$HEIGHT, format=BGR !  \
	sdxfacedetect ! queue ! \
	fpsdisplaysink video-sink="kmssink plane-id=32 bus-id="a2070000.v_mix" render-rectangle=\"<$(($WOFF + $((2*$WIDTH)))),$HOFF,$WIDTH,$HEIGHT>\"" text-overlay=false sync=false	\
	filesrc location=face_parades/fRussia1_480p.mp4  ! qtdemux ! h264parse ! omxh264dec internal-entropy-buffers=3 ! xlnxvideoscale !  \
	video/x-raw, width=$WIDTH, height=$HEIGHT, format=BGR !  \
	sdxfacedetect ! queue ! \
	fpsdisplaysink video-sink="kmssink plane-id=33 bus-id="a2070000.v_mix" render-rectangle=\"<$(($WOFF)),$(($HOFF + $HEIGHT)),$WIDTH,$HEIGHT>\"" text-overlay=false sync=false	\
	filesrc location=face_parades/fScotland_480p.mp4 ! qtdemux ! h264parse ! omxh264dec internal-entropy-buffers=3 ! xlnxvideoscale !  \
	video/x-raw, width=$WIDTH, height=$HEIGHT, format=BGR !  \
	sdxfacedetect ! queue ! \
	fpsdisplaysink video-sink="kmssink plane-id=34 bus-id="a2070000.v_mix" render-rectangle=\"<$(($WOFF + $WIDTH)),$(($HOFF + $HEIGHT)),$WIDTH,$HEIGHT>\"" text-overlay=false sync=false	\
	filesrc location=face_parades/fFrance2_480p.mp4 ! qtdemux ! h264parse ! omxh264dec internal-entropy-buffers=3 ! xlnxvideoscale !  \
	video/x-raw, width=$WIDTH, height=$HEIGHT, format=BGR !  \
	sdxfacedetect ! queue ! \
	fpsdisplaysink video-sink="kmssink plane-id=35 bus-id="a2070000.v_mix" render-rectangle=\"<$(($WOFF + $((2*$WIDTH)))),$(($HOFF + $HEIGHT)),$WIDTH,$HEIGHT>\"" text-overlay=false sync=false	\
	filesrc location=face_parades/Chile_and_France.mp4 ! qtdemux ! h264parse ! omxh264dec internal-entropy-buffers=3 ! xlnxvideoscale !  \
	video/x-raw, width=$WIDTH, height=$HEIGHT, format=BGR !  \
	sdxtrafficdetect ! queue ! \
	fpsdisplaysink video-sink="kmssink plane-id=36 bus-id="a2070000.v_mix" render-rectangle=\"<$(($WOFF + $((3*$WIDTH)))),$(($HOFF + $HEIGHT)),$WIDTH,$HEIGHT>\"" text-overlay=false sync=false	\
	multifilesrc location=demo_inputs/file_%02d.dmp loop=true ! h264parse ! omxh264dec internal-entropy-buffers=3 ! xlnxvideoscale !  \
	video/x-raw, width=$WIDTH, height=$HEIGHT, format=BGR !  \
	sdxtrafficdetect ! queue ! \
	fpsdisplaysink video-sink="kmssink plane-id=37 bus-id="a2070000.v_mix" render-rectangle=\"<$(($WOFF + $((3*$WIDTH)))),$HOFF,$WIDTH,$HEIGHT>\"" text-overlay=false sync=false -v
killall -9 modetest
