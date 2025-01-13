dataset_type = 'IcdarDataset'
data_root = '/home/yexiaoyu/mmocr_attack/data/AdvDocument_12-06/word'

train = dict(
    type=dataset_type,
    ann_file=f'{data_root}/instances_training.json',
    img_prefix=f'{data_root}/imgs',
    pipeline=None)

test = dict(
    type=dataset_type,
    ann_file=f'{data_root}/AdvDocument_12-06.json',
    img_prefix=f'{data_root}/Images',
    pipeline=None)

train_list = [train]

test_list = [test]
