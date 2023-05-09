#include <cuda_runtime.h>

cudaEvent_t start, end;
float elapsedTime;

cudaEventCreate(&start);
cudaEventCreate(&end);

cudaEventRecord(start, 0);

...
cudaEventRecord(end, 0);
cudaEventSynchronize(end);

cudaEventElapsedTime(&elapsedTime, start, end);

cudaEventDestroy(start);
cudaEventDestroy(end);

std::cout << "Elapsed time: " << elapsedTime << " milliseconds" << std::endl;
