# this code is used to clean "weird" data from the test results. This includes wrong answers with response times
# that indicate a mistake was made, and also wrong answers where the majority of participants misclassified 
# the image, indicating that our initial classification was incorrect

import pandas as pd
import numpy as np
import os

df = pd.read_csv('results_All.csv')
# set the target category based on filename
df['target'] = np.where(df['file_name'].str.contains(r'HAS'), 'Happy', 'Sad')

# label incorrect guesses
df['wrong'] = df['guess']!=df['target']

# get response time means, standard deviations, and set lower speed threshold
df['mean'] = df.groupby(['test_id'])['time'].transform('mean')
df['standard'] = df.groupby(['test_id'])['time'].transform('std')
df['speed_threshold'] = df['mean']-(0.5*df['standard'])

# identify and remove data with wrong guess and response time below lower speed threshold
df['mistake'] = np.where(((df['time'] < df['speed_threshold']) & (df['wrong'])), 'Yes', '')
mistake_idx = df[df['mistake']=='Yes'].index
df.drop(mistake_idx, inplace=True)

# find and remove images that were misclassified by majority of users
df['misclass'] = df.groupby(['file_name'])['wrong'].transform('sum')
misclass_idx = df[df['misclass']>2].index
df.drop(misclass_idx, inplace=True)

# remove extra columns and save to .txt
df.drop(['target','mean','standard','speed_threshold','wrong','misclass','mistake'], axis=1, inplace=True)
df.to_csv('cleaned_data.txt', index=False, header=None)



