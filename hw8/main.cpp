#include <iostream>
#include <pthread.h>
#include <vector>
#include <chrono>

const int VECTOR_SIZE = 10000000;
const int NUM_THREADS = 4;

std::vector<double> vectorA(VECTOR_SIZE);
std::vector<double> vectorB(VECTOR_SIZE);
double result = 0;

// Структура для передачи данных потоку
struct ThreadData {
    int threadId;
    int startIdx;
    int endIdx;
};

// Функция, выполняемая каждым потоком
void* computeDotProduct(void* arg) {
    ThreadData* data = static_cast<ThreadData*>(arg);

    for (int i = data->startIdx; i < data->endIdx; ++i) {
        result += vectorA[i] * vectorB[i];
    }

    pthread_exit(nullptr);
}

int main() {
    // Инициализация векторов
    for (int i = 0; i < VECTOR_SIZE; ++i) {
        vectorA[i] = i + 1;
        vectorB[i] = VECTOR_SIZE - i;
    }

    // Создание потоков
    pthread_t threads[NUM_THREADS];
    ThreadData threadData[NUM_THREADS];

    auto start_time = std::chrono::high_resolution_clock::now();

    // Разделение работы между потоками
    int chunkSize = VECTOR_SIZE / NUM_THREADS;
    for (int i = 0; i < NUM_THREADS; ++i) {
        threadData[i].threadId = i;
        threadData[i].startIdx = i * chunkSize;
        threadData[i].endIdx = (i == NUM_THREADS - 1) ? VECTOR_SIZE : (i + 1) * chunkSize;

        pthread_create(&threads[i], nullptr, computeDotProduct, &threadData[i]);
    }

    // Ожидание завершения работы всех потоков
    for (int i = 0; i < NUM_THREADS; ++i) {
        pthread_join(threads[i], nullptr);
    }

    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time);

    // Вывод результата и времени выполнения
    std::cout << "Vector Dot Product: " << result << std::endl;
    std::cout << "Execution Time: " << duration.count() << " milliseconds" << std::endl;

    return 0;
}
