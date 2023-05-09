
#include <iostream>
#include <cmath>
#include <vector>
#include <cuda_runtime.h>

using namespace std;

#define PI 3.14159265358979323846
#define BLOCK_SIZE 16

global void compute_image_kernel(double* sinogram_gpu, double* image_gpu, double r, double pixel_s, double fr, double angel, double vs)
{
// 线程索引
int i = blockIdx.y * blockDim.y + threadIdx.y;
int j = blockIdx.x * blockDim.x + threadIdx.x;

// 如果超出像素范围则直接返回
if (i >= 400 || j >= 400)
    return;

double pa = 0;

for (int k = 0; k < 256; k++)
{
    double t = floor(sqrt(pow((j - 200) * pixel_s - cos(k * angel - PI) * r, 2) + pow((i - 200) * pixel_s - sin(k * angel - PI) * r, 2)) / (vs * fr)) + 1;
    pa = pa + sinogram_gpu[(int)t * 256 + k];
}

image_gpu[i * 400 + j] = pa;
}

void cuda_compute_image(std::vector<std::vector<double> > &sinogram, double *image, double r, double pixel_s, double fr, double angel, double vs)
{
// 声明GPU内存指针
double *sinogram_gpu, *image_gpu;

// 计算输入sinogram数组在设备内存中的尺寸
int sinogram_size = 4096 * 256 * sizeof(double);

// 计算输出image数组在设备内存中的尺寸
int image_size = 400 * 400 * sizeof(double);

// 在设备内存中分配输入与输出数组的空间
cudaMalloc((void**)&sinogram_gpu, sinogram_size);
cudaMalloc((void**)&image_gpu, image_size);

// 将输入sinogram数据复制到设备内存中
cudaMemcpy(sinogram_gpu, &sinogram[0][0], sinogram_size, cudaMemcpyHostToDevice);

// 定义线程块
dim3 block(BLOCK_SIZE, BLOCK_SIZE);
dim3 grid((400 + BLOCK_SIZE - 1) / BLOCK_SIZE, (400 + BLOCK_SIZE - 1) / BLOCK_SIZE);

// 执行GPU Kernel函数进行图像重建，并等待GPU处理完成
compute_image_kernel <<<grid, block >>> (sinogram_gpu, image_gpu, r, pixel_s, fr, angel, vs);
cudaDeviceSynchronize();

// 将输出image数据从设备内存中复制回主机内存
cudaMemcpy(image, image_gpu, image_size, cudaMemcpyDeviceToHost);

// 释放GPU内存空间
cudaFree(sinogram_gpu);
cudaFree(image_gpu);
}

int main() {
std::vector<std::vector<double>> sinogram(4096, std::vector<double>(256, 1.0));

for (int i = 0; i < 2000; i++) {
    for (int j = 0; j < 256; j++) {
        sinogram[i][j] = 0.0;
    }
}

double image[400][400];

double r = 55e-3;
double pixel_s = 0.1e-3;
double fr = 40e6;
double angel = 2 * PI  / 256;
double vs = 1.5e3;

// 调用CUDA函数进行图像重建计算
cuda_compute_image(sinogram, &image[0][0], r, pixel_s, fr, angel, vs);

return 0;
}