#include <iostream>
#include <cmath>

double calculateArctan(double x, double precision) {
    double result = 0.0;
    double pow2_x = x * x;
    double term = x;
    double sign = 1.0;
    int n = 1;

    while (std::abs(term) > precision) {
        double tmp = sign * term;
        result = result + tmp;
        n = n + 2;
        sign = 0 - sign;
        term = x * pow2_x / n;

    }

    return result;
}

int main() {
    double x_value = 0.4;  // Укажите здесь значение x, для которого вы хотите вычислить arctan(x)
    double precision = 0.0005;  // Желаемая точность

    double approx_arctan = calculateArctan(x_value, precision);
    double true_arctan = std::atan(x_value);

    std::cout << "Приближенное значение arctan(" << x_value << ") с точностью не хуже 0.0005 (0.05%): " << approx_arctan << std::endl;
    std::cout << "Точное значение arctan(" << x_value << "): " << true_arctan << std::endl;

    return 0;
}
