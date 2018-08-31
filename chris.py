#!/usr/bin/env python
#coding=utf-8

import os, sys
import caffe
import numpy as np
import Image
root='/home/chris/caffe-master/'
cluster_herb = ['A','B','C','D','E','F','G','H','I','J','K','L']

def load_model(group):
	deploy=root + 'chm_python/v45/'+cluster_herb[group]+'/model/deploy.prototxt'
	caffe_model=root + 'chm_python/v45/'+cluster_herb[group]+'/model/v45_'+cluster_herb[group]+'.caffemodel'
	mean_file= root + 'chm_python/v45/'+cluster_herb[group]+'/'+cluster_herb[group]+'_mean.npy'
	net = caffe.Net(deploy,caffe_model,caffe.TEST)

	return net,mean_file


def CNN(img,net,mean_file):   

	#圖片預處理1
	transformer = caffe.io.Transformer({'data': (1,3,256,256)})  #設定圖片的shape格式
	transformer.set_transpose('data', (2,0,1))    #改變維度顺序，由原始图片(256,256,3)--->(3,256,256)
	transformer.set_mean('data', np.load(mean_file))    #减去均值，.mean(1).mean(1)--->這個不需要！
	transformer.set_raw_scale('data', 255)    # 縮放到【0，255】
	transformer.set_channel_swap('data', (2,1,0))   #由RGB變成BGR  


	im=caffe.io.load_image(img)                   #載入圖片
	x = transformer.preprocess('data',im)      #執行上面設置的圖片預處理操作，並將圖片載入到blob中
	x = x[:,14:241,14:241] #取中間(227,227)
	net.blobs['data'].data[...] = x

	out = net.forward()
 
	prob= net.blobs['prob'].data[0].flatten() #取出最後一層（Softmax）屬於某個類別的概率值
		
	order=prob.argsort()[::-1][:3]  #概率值排序
	g = order[0]

	return g
