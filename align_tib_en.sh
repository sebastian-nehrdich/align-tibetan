#!/bin/bash
number_of_overlays=6 # the higher the number of overlays, the more precise alignment is going to be, but also slower
deletion=0.06 # higher = less precise
search_buffer_size=50 
# first parameter is a file in Tibetan unicode, second parameter is a file with English in plain text. 

cp $1 $1.work
cp $2 $2.work

# this is a lot of preprocessing steps to check new-line behaviour etc. Ideally, there should be one "sentence" per line, and the number of sentences between Tibetan and English should match up as closely as possible before we apply the aligner. 
perl -p -CIO -i -e 's/། །/།_།/g;' $1.work
perl -C -p -i -e 's/\n//g;' $1.work
perl -C -p -i -e 's/\r//g;' $1.work
perl -p -CIO -i -e 's/དང་། /དང་།_/g;' $1.work

perl -p -CIO -i -e 's/།([^_])/།\n$1/g;' $1.work
perl -p -CIO -i -e 's/དང་།_/དང་། /g;' $1.work
perl -p -CIO -i -e 's/^ +//g;' $1.work
perl -p -CIO -i -e 's/[0-9a-zA-Z]+//g;'  $1.work
sed -i -e 's/_/ /g'  $1.work
sed -i "s/[0-9]://g;" $1.work


perl -p -CIO -i -e 's/ [1-9]+[a-z.-]+\.//g;' $2.work
perl -p -CIO -i -e 's/vs\./vs /g;' $2.work
perl -p -CIO -i -e 's/ +/ /g;' $2.work
perl -p -CIO -i -e 's/([.!?:；;!?:] )/$1\n/g;' $2.work
sed -i '/^.\{,7\}$/d' $2.work

cp $2.work $2.work2

sed -i -e 's/([^()]*)//g' $2.work
sed -i -e 's/\[[^][]*\]//g'  $2.work
sed -i -e 's/{[^}{]*}//g'  $2.work

#sed -i -e 's/{[^}{]*}//g'  $1.work
sed -i "s/{[^{}]*}//g" $2.work
sed -i "s/{[^{}]*}//g" $2.work
sed -i "s/{[^{}]*}//g" $2.work
sed -i "s/{[^{}]*}//g" $2.work
sed -i "s/{[^{}]*}//g" $2.work

#sed -i "s/{[^{}]*}//g" $1.work
#sed -i "s/{[^{}]*}//g" $1.work
#sed -i "s/{[^{}]*}//g" $1.work
#sed -i "s/{[^{}]*}//g" $1.work
#sed -i "s/{[^{}]*}//g" $1.work

sed -i '/^$/d' $1.work
sed -i '/^$/d' $2.work


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

cp $1.train $1.train_wylie
python convert_to_wylie.py $1.train_wylie

cp $1.train_cleaned $1.train_cleaned_wylie
python convert_to_wylie.py $1.train_cleaned_wylie


#python create_train.py $1.work $2.work2 ladder >> $1.train
#rm $1.work
rm $2.work
rm $2.work2 
rm $1.work_vectors.npy
rm $2.work_vectors.npy

