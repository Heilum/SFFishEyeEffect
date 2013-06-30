SFFishEyeEffect
===============

This project is to illustrate the Fish Eye(barrel distorting) algorithm on iOS!

![ScreenShot](http://ww3.sinaimg.cn/mw690/5d84b24ajw1e66jgvm2cfj20hs0vkwif.jpg)

Bellow is the algorithm chart:

![ScreenShot](https://raw.github.com/JagieChen/SFFishEyeEffect/master/algorithm_chart.jpg)

Our input is a bitmap and the output is another bitmap but with the sampe size.For conviently,We assume the 
input image's shape is a squar with the origin at the center of the images. 

So,the flow of the algorithm is to iterate every pixel in the output image,find the corresponding one in the input image and use the later to set the former.Obversely,the distance of the later between the origin is longer than that of the former,but they has the same slope.

From the chart,we get:d= h * tan(b/r).

First,let's assume the half of the whole fish eye's angle is A and We get "r = ri / A".Here "ri" is the radius of the output image,a contant value.

To let the output image contain all the content the input image have,"h" must equl "ri / tan(A)".

Put all together,We get: "d = (ri / tan(A)) * tan(b * A / ri)".

See the code,and you will understand thoroughly!


=========================================================
本项目在iOS平台演示鱼眼算法。

我们的输入是一个bitmp,输出还是同样大的bitmap.为演示方便，定原始的bitmap为正方形，图片中心为原点。

总流程就是遍历输出bitmap的每一个像素，比如P(x,y),找到原始bitmap中的像素P0(x0,y0)，来设置(x,y).毫无疑问，P0离图片中心点要比P远。以极坐标的观点来看,P0的极径大于P的极径，但是极角相同。所以，只需找出以P极径为自变量的P0的极径表达式即可。
    
设P离图片中心点的距离为b,也就是图中的棕色弧长。
因为b = r * a(a为P与原点之夹角),且d=h*tan(a),所以有d = h * tan(b/r).
    
设整个球面镜(鱼眼)的张角的一半为A(弧度),则r = ri(图片的半径,也就是整个鱼眼弧长的一半) / A
为了让原图的所有像素都纳入鱼眼内，势必有tan(A) = R(视野半径,即为ri) / h => h = ri / tan(A)
    
综上：d = (ri / tan(A)) * tan(b * A / ri) // ri已知,A为可调参数，b为自变量。
    
    
    
    