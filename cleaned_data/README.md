# Instruction of preparing training, validation and testing data sets

## Sample method 1: sampling from blocks

1. Import raw data from the folder *raw_data* folder and name them *m1*, *m2*, and *m3*
2. Open *sample_from_blocks.R* in Rstudio. Note: *sample_from_blocks.R* generates training, validation and testing data for one image. 
3.  To generate splitting data for image *m1*, find and replace the current data set name in the script to *m1*. Similar for generating splitting data for *m2* and *m3*.
4. Run the whole scripts and obtain *m1_train*, *m1_val*, and *m1_test* in the environment.

Results of sampling from blocks:

![](/home/zhanyuan/uc-berkeley/courses/stat-154/stat-154-repo/images/annotated_m1.png)

![](/home/zhanyuan/uc-berkeley/courses/stat-154/stat-154-repo/images/annotated_m2.png)

![](/home/zhanyuan/uc-berkeley/courses/stat-154/stat-154-repo/images/annotated_m3.png)



## Sample method 2: sampling from blurred images

1. Import raw data from the folder *raw_data* folder and name them *m1*, *m2*, and *m3*
2. Open *sample_after_blurring.R* in Rstudio. Note: this script generates blurred version of an image
3. To get the blurred version of *m1*, find and replace the current data set name to *m1*. Similar for *m2* and *m3*.
4. Run the whole scripts and obtain *blurred_m1*.

Results of blurring images:

![](/home/zhanyuan/uc-berkeley/courses/stat-154/stat-154-repo/images/blurred_m1.png)

![](/home/zhanyuan/uc-berkeley/courses/stat-154/stat-154-repo/images/blurred_m2.png)

![](/home/zhanyuan/uc-berkeley/courses/stat-154/stat-154-repo/images/blurred_m3.png)

### To inspect the splitting data and blurred images, and further clean the data (standardization and removing unnecessary variables), open *clean_and_inspect_data.Rmd*.

#### Note: importing the *cleaned_data.RData* to Rstudio environment can get the cleaned data for this project.

