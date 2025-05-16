namespace wp
{
    
// #include "builtin_complete.slang"

const int ARRAY_MAX_DIMS = 4;       // must match constant in types.py

struct shape_t
{
    int dims[ARRAY_MAX_DIMS];
}

__generic<T>
struct array_t
{
    T* data;
    T* grad;
    shape_t shape;
    int strides[ARRAY_MAX_DIMS];
    int ndim;
}

__generic<T>
[ForceInline]
T* address(const array_t<T> buf, int i) { return &buf.data[i]; }

__generic<T>
[ForceInline]
T load(T* data) { return *data; }

__generic<T>
[ForceInline]
void array_store(const array_t<T> buf, int i, T value)
{
    buf.data[i] = value;
}

__generic<T>
[ForceInline]
T index(const array_t<T> arr, int i)
{
    return arr.data[i];
}

__generic<T>
[ForceInline]
T index_grad(const array_t<T> arr, int i)
{
    return arr.grad[i];
}

__generic<T : __BuiltinArithmeticType>
[ForceInline]
void adj_array_store(const array_t<T> buf, int i, T value, const array_t<T> adj_buf, int adj_i, out T adj_value)
{
    if (adj_buf.data)
        adj_value += index(adj_buf, i);
    else if (buf.grad)
        adj_value += index_grad(buf, i);

}


//
// Atomics.
//

// __generic<T: __BuiltinFloatingPointType>
[ForceInline]
float atomic_add(float* buf, float value)
{
    return atomicAdd(*buf, value);
}

// [ForceInline]
// float atomic_add(const array_t<float> buf, int i, float value) { return atomic_add(&index(buf, i), value); }

[ForceInline]
float atomic_add(const array_t<float> buf, int i, float value) { return atomic_add(buf.data, value); }

}
