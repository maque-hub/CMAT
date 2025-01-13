CUDA_VISIBLE_DEVICES=6 python -W ignore detlib/mmocr/tools/test_attack.py \
detlib/mmocr/configs/textdet/dbnetpp/dbnetpp_r50dcnv2_fpnc_1200e_icdar2015_adv.py \
https://download.openmmlab.com/mmocr/textdet/dbnet/dbnetpp_r50dcnv2_fpnc_1200e_icdar2015-20220502-d7a76fff.pth \
--eval hmean-iou --perturbation results/parallel_custom/parallel.pth \
#>eval_dbpp_no_weight.log 2>&1 &