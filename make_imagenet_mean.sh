#!/usr/bin/env sh
# Compute the mean image from the imagenet training lmdb
# N.B. this is available in data/ilsvrc12

EXAMPLE=/home/chris/caffe-master/chm_new/v45
DATA=/home/chris/caffe-master/chm_new/v45
TOOLS=/home/chris/caffe-master/build/tools

$TOOLS/compute_image_mean $EXAMPLE/ilsvrc12_train_lmdb \
  $DATA/imagenet_mean.binaryproto

echo "Done."
