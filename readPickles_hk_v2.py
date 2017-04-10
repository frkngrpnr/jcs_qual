#import numpy
import sys, pprint, cPickle, random, csv
import cv2
sys.path.append('/usr/local/lib/python2.7/site-packages')
#pkl_file = open('given/annotation_training.pkl', 'rb')
ds=[]
a=0
# read system predictions
with open('predictions.csv', 'rb') as csvfile:
   spamreader = csv.reader(csvfile, delimiter=';', quotechar='|')
   for row in spamreader:
      #print row	
      ds.append(row)

#pprint.pprint(ds)

# read template file 
# pkl_file = open('prediction.pkl', 'rb')

data1 = {'agreeableness': {},
'conscientiousness': {},
'extraversion': {},
'interview': {},
'neuroticism': {},
'openness': {}}

descriptions = {}

image = cv2.imread('image.jpg')

# cPickle.load(pkl_file)
i=-1;
for row in ds:
   i=i+1
   if i == 0:
    continue
   else:
      if i == 1:
         im = image
      else:
         im = None
#      im = None
      d=-1
      for col in ds[i]:
         d=d+1
         if d == 0:
            continue
         else:
            if d < 7:
               data1[ds[0][d]][ds[i][0]]=ds[i][d]
            else:
               descriptions[ds[i][0]] = (ds[i][d], im)

pprint.pprint(data1)
pprint.pprint(descriptions)
#pkl_file.close()
# write pkl file
f = file('prediction.pkl', 'wb')
cPickle.dump(data1, f, protocol=cPickle.HIGHEST_PROTOCOL)
f.close()
f2= file('description.pkl', 'wb')
cPickle.dump(descriptions, f2, protocol=cPickle.HIGHEST_PROTOCOL)
f2.close()

#cPickle.dump(data1, f, protocol=2)



