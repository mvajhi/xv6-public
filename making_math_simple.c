#include "making_math_simple.h"

#define MAX_RESULT_SIZE 128

// Function to convert string to double
double my_atof(const char *str) {
    double result = 0.0;
    double factor = 1.0;
    int i = 0;
    int decimal_point = 0;
    while (str[i]) {
        if (str[i] == '.') {
            decimal_point = 1;
            factor = 0.1;
        } else if (str[i] >= '0' && str[i] <= '9') {
            if (decimal_point) {
                result += (str[i] - '0') * factor;
                factor *= 0.1;
            } else {
                result = result * 10.0 + (str[i] - '0');
            }
        }
        i++;
    }
    return result;
}

// Function to convert integer to string
void my_itoa(int num, char *str) {
    int i = 0, j, sign;
    if ((sign = num) < 0) {
        num = -num;
    }
    do {
        str[i++] = num % 10 + '0';
    } while ((num /= 10) > 0);
    if (sign < 0) {
        str[i++] = '-';
    }
    str[i] = '\0';

    // Reverse the string
    for (j = 0, i--; j < i; j++, i--) {
        char temp = str[j];
        str[j] = str[i];
        str[i] = temp;
    }
}

// Function to convert double to string
void my_ftoa(double num, char *str, int precision) {
    int int_part = (int)num;
    double frac_part = num - (double)int_part;
    int i = 0;

    // Convert integer part
    my_itoa(int_part, str);
    while (str[i] != '\0') {
        i++;
    }

    // Add decimal point and fractional part
    if (precision > 0) {
        str[i++] = '.';
        while (precision-- > 0) {
            frac_part *= 10.0;
            int digit = (int)frac_part;
            str[i++] = digit + '0';
            frac_part -= (double)digit;
        }
    }
    str[i] = '\0';
}

// Function to evaluate a simple expression of the form NumOpNum
double evaluate_expression(const char *expr) {
    char num1_str[32] = {0}, num2_str[32] = {0};
    char op;
    int i = 0, j = 0;

    // Extract the first number
    while ((expr[i] >= '0' && expr[i] <= '9') || expr[i] == '.') {
        num1_str[i] = expr[i];
        i++;
    }
    double num1 = my_atof(num1_str);

    // Extract the operator
    op = expr[i++];

    // Extract the second number
    while ((expr[i] >= '0' && expr[i] <= '9') || expr[i] == '.') {
        num2_str[j++] = expr[i++];
    }
    double num2 = my_atof(num2_str);

    // Perform the calculation based on the operator
    switch (op) {
        case '+': return num1 + num2;
        case '-': return num1 - num2;
        case '*': return num1 * num2;
        case '/': return num1 / num2;
        default: return 0.0;
    }
}

// Function to replace mathematical expressions in a string
void replace_math_expressions(char *str) {
    char *p = str;
    char result[MAX_RESULT_SIZE];
    while (*p) {
        if ((*p >= '0' && *p <= '9') || (*p == '.' && (*(p + 1) >= '0' && *(p + 1) <= '9'))) {
            char *start = p;
            while ((*p >= '0' && *p <= '9') || *p == '.' || *p == '+' || *p == '-' || *p == '*' || *p == '/') {
                p++;
            }
            if (*p == '=' && *(p + 1) == '?') {
                char expr[64];
                int len = p - start;
                for (int i = 0; i < len; i++) {
                    expr[i] = start[i];
                }
                expr[len] = '\0';
                double res = evaluate_expression(expr);
                if (res == (int)res) {
                    my_itoa((int)res, result);
                } else {
                    my_ftoa(res, result, 1);
                }
                int result_len = 0;
                while (result[result_len] != '\0') {
                    result_len++;
                }
                int remaining_len = 0;
                char *temp = p + 2;
                while (*temp != '\0') {
                    remaining_len++;
                    temp++;
                }
                for (int i = 0; i <= remaining_len; i++) {
                    *(start + result_len + i) = *(p + 2 + i);
                }
                for (int i = 0; i < result_len; i++) {
                    start[i] = result[i];
                }
                p = start + result_len;
            } else {
                p = start + 1;
            }
        } else {
            p++;
        }
    }
}

// int main() {
//     char str[] = "1vv0+20=?vv 5.5*2=? 10.5/2=? 1.5-0.5=? ";
//     replace_math_expressions(str);
//     for (int i = 0; i < MAX_RESULT_SIZE; i++) {
//         if (str[i] == '\0') {
//             break;
//         }
//         printf(1, "%c", str[i]);
//     }
//     printf(1, "\n");
//     exit();
// }

char* making_math_simple(char* str) {
    replace_math_expressions(str);
    return str;
}