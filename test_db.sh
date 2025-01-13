
CUDA_VISIBLE_DEVICES=5 python -W ignore detlib/mmocr/tools/test_attack.py \
detlib/mmocr/configs/textdet/dbnet/dbnet_r50dcnv2_fpnc_1200e_icdar2015_adv.py \
https://download.openmmlab.com/mmocr/textdet/dbnet/dbnet_r50dcnv2_fpnc_sbn_1200e_icdar2015_20211025-9fe3b590.pth \
--eval hmean-iou --perturbation results/parallel_compare/parallel.pth \