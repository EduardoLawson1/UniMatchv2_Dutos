#!/bin/bash

# modify these augments if you want to try other datasets, splits or methods
# dataset: ['levir', 'whu']
# method: ['unimatch_v2', 'supervised']
# exp: just for specifying the 'save_path'
# split: ['5%', '10%', '20%', '40%']. Please check directory './splits/$dataset' for concrete splits
dataset='levir'
method='unimatch_v2'
exp='dinov2_base'
split='40%'

config=configs/${dataset}.yaml
labeled_id_path=splits/$dataset/$split/labeled.txt
unlabeled_id_path=splits/$dataset/$split/unlabeled.txt
save_path=exp/$dataset/$method/$exp/$split

mkdir -p $save_path

python -m torch.distributed.launch \
    --nproc_per_node=$1 \
    --master_addr=localhost \
    --master_port=$2 \
    $method.py \
    --config=$config --labeled-id-path $labeled_id_path --unlabeled-id-path $unlabeled_id_path \
    --save-path $save_path --port $2 2>&1 | tee $save_path/out.log