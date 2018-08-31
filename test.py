#!/usr/bin/env python
#coding=utf-8

import os, sys
os.environ["GLOG_minloglevel"] = "2" #不顯示caffe info
import numpy as np
import chris
import caffe
root='xxxx' #自己定義
deploy=root + 'deploy.prototxt'    
caffe_model=root + 'XXXXX.caffemodel'   
mean_file = root + 'XXXX_mean.npy'
name= ['山藥','木薯','黃耆','紅耆','人參','西洋參','川牛膝','味牛膝','北板藍根','南板藍根','綠衣枳實','枳實',
       '川烏','草烏','黃芩','綠黃芩','半夏','水半夏','石蓮子','苦石蓮','川木通','關木通','川母貝(松貝)','平母貝']
cluster_herb = ['A','B','C','D','E','F','G','H','I','J','K','L']
herb = ['A1','A2','B1','B2','C1','C2','D1','D2','E1','E2','F1','F2','G1','G2','H1','H2','I1','I2','J1','J2','K1','K2','L1','L2']
caffe.set_mode_gpu()
net = caffe.Net(deploy,caffe_model,caffe.TEST)



for i in range(0,7):
	for j in range(1,41):
		#input
		img=root+'chm_new/chm_test/iphone/test/'+herb[i]+'/'+str(j)+'.jpg'
		#input

		group =chris.CNN(img,net,mean_file)

		print "group: ",group
		
		#如果不是hcnn 就不用繼續做下去		
		(net_layer2,mean_file_layer2)=chris.load_model(group) # load classify model
		classify =chris.CNN(img,net_layer2,mean_file_layer2) #classify = 0 or 1
		result = name[(2*group) + classify]
		label = 2*group +classify
		print "result: ", result

		f = open('..../result.txt','a+')
		f.write(str(label)+'\n')
f.close()
