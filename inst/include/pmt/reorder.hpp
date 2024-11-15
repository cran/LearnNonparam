#pragma once

#include <algorithm>

template <typename T>
T rand_int(T n)
{
    return static_cast<T>(unif_rand() * n);
}

template <typename T>
void random_shuffle(T v)
{
    R_len_t n = v.size();

    R_len_t j;
    for (R_len_t i = 0; i < n - 1; i++) {
        j = i + rand_int(n - i);
        std::swap(v[i], v[j]);
    }
}

template <typename T>
bool next_permutation(T v)
{
    return std::next_permutation(v.begin(), v.end());
}

template <typename T>
double n_permutation(T v)
{
    double A = 1;

    R_len_t n = v.size();
    R_len_t n_i = 0;

    auto current = v[0];
    for (R_len_t i = 0; i < n; i++) {
        A *= (i + 1);
        if (v[i] == current) {
            A /= ++n_i;
        } else {
            n_i = 1;
        }
        current = v[i];
    }

    return A;
}
