#!/bin/bash
number_of_overlays=6
# Preprocessing of input strings
deletion=0.06 # higher = ungenauer; 0.015 ist bei tib schon etwas straff
search_buffer_size=50

cp $1 $1.work
cp $2 $2.work

# preprocessing steps for $1.work and $2.work can go here



python get_vectors.py $1.work $number_of_overlays
python get_vectors.py $2.work $number_of_overlays
rm ladder
./vecalign.py -a $number_of_overlays -d $deletion --search_buffer_size $search_buffer_size --alignment_max_size $number_of_overlays --src $1.work --tgt $2.work \
   --src_embed $1.work_overlay $1.work_vectors.npy  \
   --tgt_embed $2.work_overlay $2.work_vectors.npy >> ladder
rm $1.org
rm $1.train
python ladder2org.py $1.work $2.work ladder >> $1.org
python create_train.py $1.work $2.work ladder >> $1.train
python create_train_clean.py $1.work $2.work ladder >> $1.train_cleaned


rm $1.work
rm $2.work

rm $1.work.npy
rm $2.work.npy

