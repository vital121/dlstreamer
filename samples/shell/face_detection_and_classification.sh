#!/bin/bash
# ==============================================================================
# Copyright (C) 2018-2019 Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

set -e

BASEDIR=$(dirname "$0")/../..
if [ -n ${GST_SAMPLES_DIR} ]
then
    source $BASEDIR/scripts/setup_env.sh
fi
source $BASEDIR/scripts/setlocale.sh

#import GET_MODEL_PATH
source $BASEDIR/scripts/path_extractor.sh

INPUT=${1:-$VIDEO_EXAMPLES_DIR/Fun_at_a_Fair.mp4}

MODEL1=face-detection-adas-0001
MODEL2=age-gender-recognition-retail-0013
MODEL3=emotions-recognition-retail-0003

MODEL2_PROC=age-gender-recognition-retail-0013
MODEL3_PROC=emotions-recognition-retail-0003

DEVICE=CPU

DETECT_MODEL_PATH=$(GET_MODEL_PATH $MODEL1)
CLASS_MODEL_PATH=$(GET_MODEL_PATH $MODEL2)
CLASS_MODEL_PATH1=$(GET_MODEL_PATH $MODEL3)

echo Running sample with the following parameters:
echo GST_PLUGIN_PATH=${GST_PLUGIN_PATH}
echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

gst-launch-1.0 --gst-plugin-path ${GST_PLUGIN_PATH} \
    filesrc location=${INPUT} ! decodebin ! video/x-raw ! videoconvert ! \
    gvadetect model=$DETECT_MODEL_PATH device=$DEVICE ! queue ! \
    gvaclassify model=$CLASS_MODEL_PATH model-proc=$(PROC_PATH $MODEL2_PROC) device=$DEVICE ! queue ! \
    gvaclassify model=$CLASS_MODEL_PATH1 model-proc=$(PROC_PATH $MODEL3_PROC) device=$DEVICE ! queue ! \
    gvawatermark ! videoconvert ! fpsdisplaysink video-sink=ximagesink sync=false