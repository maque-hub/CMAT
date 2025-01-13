# Overview

This is the official code for **CMAT: A Cross-Model Adversarial Texture for Scanned Document Privacy Protection**.

# Install 

- step 1. please follow the installation instructions to create a conda environment

  ```bash
  conda create -n text-attack python=3.7
  conda activate text-attack
  pip install -r requirements.txt
  ```

  If your CUDA version is 11 or higher, you may encounter CUDA-related errors. It is recommended to install PyTorch using Conda and remove `pytorch` from the `requirements.txt` file.

  ```bash
  conda install pytorch==1.9.0 torchvision==0.10.0 torchaudio==0.9.0 cudatoolkit=11.3
  ```

- Step 2. please follow the build-from-source instructions to install mmocr

  ```bash
  pip install -U openmim
  mim install mmcv-full
  pip install mmdet
  cd detlib/mmocr
  pip install -r requirements.txt
  pip install -v -e .
  ```

  Then, replace the provided `./base.py` file into the `lib/python3.7/site-packages/mmdet/models/detectors/` directory of your Conda environment.

- Step 3. please install the following packets

```python
 pip install Image
 pip install jupyter

#  if error about PIL exist, please uninstall pillow and re-install it with lower version
pip uninstall pillow
pip install "pillow<7"
```

## Attack

First, download the FUNSD dataset and save it to the `data` folder. Then, update the training data path specified in `config/parallel.yaml`:

```yaml
TRAIN:
  IMG_DIR: 'data/training_data'
  LAB_DIR: 'data/FUNSD/training_data/annotations'
```

Then, modify lines 15 and 16 in `config/parallel.yaml` by specifying the desired detectors in `name` and their corresponding weights in `weight` (default is 1). 

```yaml
DETECTOR: # Specify the target detectors here
  NAME: ["PS_IC15", "DB_r50", "DBPP_r50"] 
  WEIGHT: [1.0, 1.0, 1.0]
```

There are also optimized weight provided in  `config/parallel.yaml`，uncomment to train the texture with optimized weight.

#### Training

Run `train_weighted.sh` to start training. Check the results in TensorBoard and the `results/weighted.log` file. The trained perturbations will be saved in the `/results/weighted` directory.

```bash
CUDA_VISIBLE_DEVICES=0 nohup python train_weighted_text.py \
-cfg=parallel.yaml -s=./results/weighted \
>./results/weighted.log 2>&1 &
```

#### Weight optimization

To search for model weights, configure `nni_search.yaml` and `search_space.json`, then run the following command:

```bash
nnictl create --config nni_search.yaml
```

For detailed usage, please refer to the official NNI documentation: https://nni.readthedocs.io/en/v2.0/.

## Evaluation

We present a comprehensive dataset for evaluating text detection in financial documents, you can download it via:

Link: https://pan.baidu.com/s/1tJgQFfMJR9kKgfXemialXw?pwd=hgbi Extraction code: hgbi 

First, modify the `data_root` in `detlib\mmocr\configs\_base_\det_datasets\icdar2015.py` to point to the dataset directory. Update the `pipeline` in the `test` section as follows:

```python
test = dict(
    type=dataset_type,
    ann_file=f'{data_root}/[json_file_name]',
    img_prefix=f'{data_root}/[image_directory_name]',
    pipeline=None)
```

Next, run `test.sh` in the project's root directory to get the testing results on Psenet-IC15:

```bash
CUDA_VISIBLE_DEVICES=0 python detlib/mmocr/tools/test_attack.py \
detlib/mmocr/configs/textdet/psenet/psenet_r50_fpnf_600e_icdar2015_adv.py \
https://download.openmmlab.com/mmocr/textdet/psenet/psenet_r50_fpnf_600e_icdar2015_pretrain-eefd8fe6.pth \
--eval hmean-iou --perturbation [absolute_path_to_perturbation] \
--show --show-dir [output_directory]
```

Replace `perturbation` with the **absolute path to the perturbation file**. After the script completes, you can find the detection results of the test set images in the specified `show-dir`.