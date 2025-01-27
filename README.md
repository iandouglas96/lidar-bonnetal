
# Specific instructions for our use:


## Important notes:
Make sure you read all the yaml files that you're using during training. For example, for pennovation and forest dataset, you can check train-script-\*.sh files in [this folder](https://github.com/XuRobotics/lidar-bonnetal/tree/master/train/tasks/semantic) for the yaml files that you're using. 

The neural network yaml files in [this folder](https://github.com/XuRobotics/lidar-bonnetal/tree/master/train/tasks/semantic/config/arch) specify important (hyper)parameters such as the input size, whehter or not to train the backbone, learning rate, etc. 

The label yaml files in [this folder](https://github.com/XuRobotics/lidar-bonnetal/tree/master/train/tasks/semantic/config/labels) specify important dataset parameters such as the semantic classes and their labels, etc.



## Some helpful additional utils:

1. **Convert the original labeled tree-only .pcd files into .npy label files**: 

see convert_pcds.py

2. **Split training and test data**: 

see train_test_split.py

_Example usage:_

Step 1: Make sure all your data are in the range_images folder:

For this, you can get one example from our provided dataset (see below) and then run the following steps:

Download data from https://drive.google.com/drive/folders/16MSQf-tdD1QTYpVVtElMy1enAQv7hFAR?usp=sharing

Put data into simulated_data folder (folder structure looks like this: lidar-bonnetal->simulated_data->sequences)

Copy all pcd files to range_images directory using the following commands:
```
cd ~/lidar-bonnetal
cp -r simulated_data/sequences/*/*.pcd range_images/
```

Copy all label files to range_images directory using the following commands:
```
mkdir range_images/labels
cp -r simulated_data/sequences/*/labels/*.npy range_images/labels
```

Step 2: Training and validation splitting set by running the following commands:
```
cd ~/lidar-bonnetal
python train_test_split.py
```


## Step-by-step instructions with our example data (pennovation)

### Step: preparing data
Create `pennovation_dataset` folder in the root directory (lidar-bonnetal) of this repo.

Download data from https://drive.google.com/drive/folders/1x93D_17G6UyWZoD7NvXacXGUzZZ6G2Wi?usp=sharing

Unzip file and then, copy `labels` and `scans` folders into `pennovation_dataset` folder (folder structure looks like this: lidar-bonnetal->pennovation_dataset->lables), then go to  the root directory (lidar-bonnetal), and do the following:

Open file `full_data_prepreocessor.py`, make sure that `for_jackle = False` and `for_indoor = False`. 

```python full_data_preprocessor.py```

This will automatically convert range images into `.pcd` files, and labels into `.npy` files. In addition, this will automatically create training, validation, and test set for you in `pennovation_dateset/sequences` folder, where `00` is training set, `01` is validation set, and `02` is test set.

### Step: update weights for class imbalance

This will also calculate the percentage of points belonging to each classes across all point clouds, and save it in `pennovation_dataset/class_points_divided_by_total_points.txt`, copy the numbers inside, and updated the corresponding YAML data config file with them:

```
cd lidar-bonnetal/train/tasks/semantic/config/labels
```

Open `pennovation.yaml` file, go to content section, and update the numbers of class 0-9. For example, in your `pennovation_dataset/class_points_divided_by_total_points.txt` file, the result is 
```
0.6750436
0.2980813
0.0000000
0.0000000
0.0000000
0.0234012
0.0000000
0.0000000
0.0018808
0.0015931
```
Then in your `lidar-bonnetal/train/tasks/semantic/config/labels/pennovation.yaml`, it should have the following:
```
content:
  0: 0.6750436 #  0 : "unlabelled"
  1: 0.2980813 #  1 : "road"
  2: 0.0 #  2: "vegetation"
  3: 0.0 #  3: "building"
  4: 0.0  #  4: "grass-sidewalk
  5: 0.0234012 #   #  5: "vehicle"
  6: 0.0  #  6: "human"
  7: 0.0  #  7: "gravel"
  8: 0.0018808 # 8: "tree_trunk"
  9: 0.0015931 # #  9: "light_pole"
```


### Step: Installing dependencies
Using pip:
```
cd train
```
check what is in requirements.txt and install these pkgs

Troubleshooting:

1. if you run into pypcd issues, this might be helpful: https://github.com/dimatura/pypcd/issues/28

2. if you run into issues related to "libcudart.so.11.0 cannot found", first and install cuda toolkit from (here)[https://developer.nvidia.com/cuda-11.0-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=2004&target_type=runfilelocal] 
then, execute the following command:
```
cd /usr/local/lib
sudo ln -s /usr/local/cuda-11.0/lib64/libcudart.so.11.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
```

### Optional step: download pretrained model:
*(this step is optional, if not, it will train from scratch)*

Create a folder called `pennovation-darknet53` in the root directory of this repo.

Download pre-trained model from [this link](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/models/darknet53-1024.tar.gz), extract all files,  Then copy all files into `pennovation-darknet53` folder.


### Step: start training:
Go to `lidar-bonnetal/train/tasks/semantic`, modify the directory and yaml flags in train.py to make sure that it points to the correct folder and correct model type (smallest, darknet-21, or darknet-53), then start training:
```
python train.py
```


## Step-by-step instructions with our example data (forest)

### Step: preparing data
Create folders named range_images and simulated_data in the root directory of this repo.

Download data from https://drive.google.com/drive/folders/16MSQf-tdD1QTYpVVtElMy1enAQv7hFAR?usp=sharing

Put data into simulated_data folder (folder structure looks like this: lidar-bonnetal->simulated_data->sequences)

### Step: Installing dependencies
Option 1. Using pip:
```
cd train
pip install -r requirements.txt
cd ..
pip freeze > pip_requirements.txt
pip install -r pip_requirements.txt 
```
Note: this will take a while (> 1 hour for me)

Option 2. Using conda: see conda_requirements.txt


### Step: start training:
```
cd ./train/tasks/semantic
./train-full-script-forest.sh
```




**-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

**-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

**-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**


# Official instructions for LiDAR-Bonnetal

Semantic Segmentation of point clouds using range images.

Developed by [Andres Milioto](http://www.ipb.uni-bonn.de/people/andres-milioto/), [Jens Behley](http://www.ipb.uni-bonn.de/people/jens-behley/), [Ignacio Vizzo](http://www.ipb.uni-bonn.de/people/ignacio-vizzo/), and [Cyrill Stachniss](http://www.ipb.uni-bonn.de/people/cyrill-stachniss/)

_Examples of segmentation results from [SemanticKITTI](http://semantic-kitti.org) dataset:_
![ptcl](pics/semantic-ptcl.gif)
![ptcl](pics/semantic-proj.gif)

## Description

This code provides code to train and deploy Semantic Segmentation of LiDAR scans, using range images as intermediate representation. The training pipeline can be found in [/train](train/). We will open-source the deployment pipeline soon.

## Pre-trained Models

### [SemanticKITTI](http://semantic-kitti.org)

- [squeezeseg](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/models/squeezeseg.tar.gz)
- [squeezeseg + crf](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/models/squeezeseg-crf.tar.gz)
- [squeezesegV2](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/models/squeezesegV2.tar.gz)
- [squeezesegV2 + crf](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/models/squeezesegV2-crf.tar.gz)
- [darknet21](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/models/darknet21.tar.gz)
- [darknet53](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/models/darknet53.tar.gz)
- [darknet53-1024](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/models/darknet53-1024.tar.gz)
- [darknet53-512](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/models/darknet53-512.tar.gz)

To enable kNN post-processing, just change the boolean value to `True` in the `arch_cfg.yaml` file parameter, inside the model directory.
  
## Predictions from Models

### [SemanticKITTI](http://semantic-kitti.org)

These are the predictions for the train, validation, and test sets. The performance can be evaluated for the training and validation set, but for test set evaluation a submission to the benchmark needs to be made (labels are not public).

No post-processing:
- [squeezeseg](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/squeezeseg.tar.gz)
- [squeezeseg + crf](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/squeezeseg-crf.tar.gz)
- [squeezesegV2](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/squeezesegV2.tar.gz)
- [squeezesegV2 + crf](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/squeezesegV2-crf.tar.gz)
- [darknet21](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/darknet21.tar.gz)
- [darknet53](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/darknet53.tar.gz)
- [darknet53-1024](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/darknet53-1024.tar.gz)
- [darknet53-512](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/darknet53-512.tar.gz)

With k-NN processing:
- [squeezeseg](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/squeezeseg-knn.tar.gz)
- [squeezesegV2](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/squeezesegV2-knn.tar.gz)
- [darknet53](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/darknet53-knn.tar.gz)
- [darknet21](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/darknet21-knn.tar.gz)
- [darknet53-1024](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/darknet53-1024-knn.tar.gz)
- [darknet53-512](http://www.ipb.uni-bonn.de/html/projects/bonnetal/lidar/semantic/predictions/darknet53-512-knn.tar.gz)

## License

### LiDAR-Bonnetal: MIT

Copyright 2019, Andres Milioto, Jens Behley, Cyrill Stachniss. University of Bonn.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Pretrained models: Model and Dataset Dependent

The pretrained models with a specific dataset maintain the copyright of such dataset.

## Citations

If you use our framework, model, or predictions for any academic work, please cite the original [paper](http://www.ipb.uni-bonn.de/wp-content/papercite-data/pdf/milioto2019iros.pdf), and the [dataset](http://semantic-kitti.org).

```
@inproceedings{milioto2019iros,
  author    = {A. Milioto and I. Vizzo and J. Behley and C. Stachniss},
  title     = {{RangeNet++: Fast and Accurate LiDAR Semantic Segmentation}},
  booktitle = {IEEE/RSJ Intl.~Conf.~on Intelligent Robots and Systems (IROS)},
  year      = 2019,
  codeurl   = {https://github.com/PRBonn/lidar-bonnetal},
  videourl  = {https://youtu.be/wuokg7MFZyU},
}
```

```
@inproceedings{behley2019iccv,
  author    = {J. Behley and M. Garbade and A. Milioto and J. Quenzel and S. Behnke and C. Stachniss and J. Gall},
  title     = {{SemanticKITTI: A Dataset for Semantic Scene Understanding of LiDAR Sequences}},
  booktitle = {Proc. of the IEEE/CVF International Conf.~on Computer Vision (ICCV)},
  year      = {2019}
}
```
