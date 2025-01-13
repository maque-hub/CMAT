CUDA_VISIBLE_DEVICES=0 nohup python train_weighted_text.py \
-cfg=parallel.yaml -s=./results/weighted \
>./results/weighted.log 2>&1 &