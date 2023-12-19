#include <pthread.h>
#include <cstdio>
#include <cstdlib>
#include <unistd.h>

#define NUM_SMOKERS 3  // Количество курильщиков

const char* items[NUM_SMOKERS] = {"табак", "бумага", "спички"};  // Компоненты для сигарет

int table_items[2];  // Компоненты на столе
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;  // Мьютекс для синхронизации доступа к столу
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;  // Условная переменная для синхронизации потоков

// Функция потока курильщика
[[noreturn]] void* smoker(void *arg) {
    int smoker_id = *(int*)arg;  // ID курильщика
    int item1, item2;

    while(true) {
        pthread_mutex_lock(&mutex);  // Захватываем мьютекс

        // Если на столе нет нужных компонентов, ждем
        if(smoker_id == table_items[0] || smoker_id == table_items[1]) {
            pthread_cond_wait(&cond, &mutex);
        }

        item1 = table_items[0];
        item2 = table_items[1];

        table_items[0] = table_items[1] = -1;  // Забираем компоненты со стола

        pthread_cond_signal(&cond);  // Сигнализируем о том, что стол свободен
        pthread_mutex_unlock(&mutex);  // Освобождаем мьютекс

        printf("Курильщик %d забрал %s и %s\n", smoker_id, items[item1], items[item2]);
        sleep(1);  // Курильщик курит
    }
}

// Функция потока посредника
[[noreturn]] void* mediator(void *arg) {
    while(true) {
        pthread_mutex_lock(&mutex);  // Захватываем мьютекс

        // Если на столе есть компоненты, ждем
        if(table_items[0] != -1 || table_items[1] != -1) {
            pthread_cond_wait(&cond, &mutex);
        }

        table_items[0] = rand() % NUM_SMOKERS;  // Выкладываем первый компонент
        table_items[1] = (table_items[0] + 1 + rand() % (NUM_SMOKERS - 1)) % NUM_SMOKERS;  // Выкладываем второй компонент

        printf("Посредник выложил %s и %s\n", items[table_items[0]], items[table_items[1]]);

        pthread_cond_broadcast(&cond);  // Сигнализируем о том, что на столе появились компоненты
        pthread_mutex_unlock(&mutex);  // Освобождаем мьютекс

        sleep(1);  // Посредник ждет
    }
}

int main() {
    srand(time(nullptr));  // Инициализируем генератор случайных чисел

    pthread_t smoker_threads[NUM_SMOKERS];  // Потоки курильщиков
    pthread_t mediator_thread;  // Поток посредника

    int smoker_ids[NUM_SMOKERS];  // ID курильщиков

    table_items[0] = table_items[1] = -1;  // Изначально стол пуст

    pthread_create(&mediator_thread, nullptr, mediator, nullptr);  // Создаем поток посредника

    for(int i = 0; i < NUM_SMOKERS; ++i) {
        smoker_ids[i] = i;
        pthread_create(&smoker_threads[i], nullptr, smoker, &smoker_ids[i]);  // Создаем потоки курильщиков
    }

    for(auto & smoker_thread : smoker_threads) {
        pthread_join(smoker_thread, nullptr);  // Ждем завершения потоков курильщиков
    }

    pthread_join(mediator_thread, nullptr);  // Ждем завершения потока посредника

    return 0;
}
