#!/bin/bash


ivector_dir=./yizhous/ivector-extractor
tdnn_dir=./yizhous/tdnnf-biased
graph_dir=./yizhous/tdnnf-biased/graph_base

new_model_dir=./model_pack
mkdir -p ./model_pack/am
mkdir -p ./model_pack/ivector
mkdir -p ./model_pack/graph


cp  $tdnn_dir/final.mdl  ./model_pack/am
cp -r $ivector_dir/{0.ie,10.ie,final.dubm,final.ie,final.ie.id,final.mat,global_cmvn.stats,num_jobs,online_cmvn.conf,splice_opts}  ./model_pack/ivector
cat ./model_pack/ivector/splice_opts | awk '{print $1 ; print$2}'  > ./model_pack/ivector/splice.conf
cp -r ./yizhous/tdnnf-biased/graph_base/* ./model_pack/graph/