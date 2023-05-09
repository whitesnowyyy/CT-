/*
 * @Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @Date: 2023-05-07 10:25:26
 * @LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
 * @LastEditTime: 2023-05-07 12:44:13
 * @FilePath: \笔试\test.cpp
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

#include <iostream>
#include <cmath>
#include <vector>
using namespace std;
#define PI 3.14159265358979323846


int main(){
    vector<vector<double>> sinogram(4096, vector<double>(256, 1.0)); // 创建一个动态二维数组sinogram，大小为4096x256，初始化为1.0
    
    for(int i=0; i<2000; i++){
        for(int j=0; j<256; j++){
            sinogram[i][j] = 0.0;
        }
    }
    
    double image[400][400];//  创建一个二维数组image，大小为400x400，用于存储最后生成的图像
    double r = 55e-3;
    double pixel_s = 0.1e-3;
    double fr = 40e6;
    double angel = 2 * PI/256;
    double vs = 1.5e3;
    
    for(int i=0; i<400; i++){
        for(int j=0; j<400; j++){
            double pa = 0;//该变量将用于存储重构图像中特定像素位置附近的所有sinogram值之和。
            for(int k=0; k<256; k++){
                double t = floor(sqrt(pow((j-200)*pixel_s-cos(k*angel-m_pi)*r,2) + pow((i-200)*pixel_s-sin(k*angel-m_pi)*r,2))/(vs*fr))+1;
                pa = pa + sinogram[t][k];
            }
            image[i][j] = pa;
        }
    }
    
    return 0;
}


