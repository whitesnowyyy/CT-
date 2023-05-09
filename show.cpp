// 引入OpenCV头文件
#include <opencv2/opencv.hpp>

...

// 创建一个400x400的Mat对象用于存储图像
cv::Mat img(400, 400, CV_64F, &image[0][0]);

// 对图像进行归一化处理
cv::normalize(img, img, 0, 255, cv::NORM_MINMAX);

// 显示图像
cv::imshow("Reconstructed Image", img);
cv::waitKey(0);