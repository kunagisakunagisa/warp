#define RAD_TO_DEG 57.29577951308232087679
#define DEG_TO_RAD  0.01745329251994329577
#define kEps 0.0f

#include "array.slang"
#include "range.slang"

#define size_t uint32_t

namespace wp
{

// numeric types (used from generated kernels)
typealias float16 = half;
typealias float32 = float;
typealias float64 = double;

typealias int8   = int8_t;
typealias uint8  = uint8_t;

typealias int16  = int16_t;
typealias uint16 = uint16_t;

typealias int32  = int;
typealias uint32 = uint;

typealias int64  = int64_t;
typealias uint64 = uint64_t;


// __generic<T : __BuiltinFloatingPointType>
// [ForceInline]
// float cast_float(T x) { return float(x); }

// __generic<T : __BuiltinIntegerType>
// [ForceInline]
// int cast_int(T x) { return int(x); }

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_cast_float(T x, inout T adj_x, float adj_ret) { adj_x += T(adj_ret); }

__generic<T : __BuiltinIntegerType>
[ForceInline]
void adj_cast_int(T x, inout T adj_x, int adj_ret) { adj_x += T(adj_ret); }

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_int8(T, inout T, int8) {}

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_uint8(T, inout T, uint8) {}

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_int16(T, inout T, int16) {}

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_uint16(T, inout T, uint16) {}

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_int32(T, inout T, int32) {}

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_uint32(T, inout T, uint32) {}

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_int64(T, inout T, int64) {}

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_uint64(T, inout T, uint64) {}


__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_float16(T x, inout T adj_x, float16_t adj_ret) { adj_x += T(adj_ret); }

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_float32(T x, inout T adj_x, float32 adj_ret) { adj_x += T(adj_ret); }

__generic<T : __BuiltinFloatingPointType>
[ForceInline]
void adj_float64(T x, inout T adj_x, float64 adj_ret) { adj_x += T(adj_ret); }


// XXX TODO: Some of these can be implemented using SPIRV's builtin intrinsics.
#define DECLARE_INT_OPS(T) \
[ForceInline] T mul(T a, T b) { return a * b; } \
[ForceInline] T div(T a, T b) { return a / b; } \
[ForceInline] T add(T a, T b) { return a + b; } \
[ForceInline] T sub(T a, T b) { return a - b; } \
[ForceInline] T mod(T a, T b) { return a % b; } \
[ForceInline] T min(T a, T b) { return min(a, b); } \
[ForceInline] T max(T a, T b) { return max(a, b); } \
[ForceInline] T clamp(T x, T a, T b) { return ::clamp(x, a, b); } \
[ForceInline] T floordiv(T a, T b) { return a / b; } \
[ForceInline] T nonzero(T x) { return x == T(0) ? T(0) : T(1); } \
[ForceInline] T sqrt(T x) { return 0; } \
[ForceInline] T bit_and(T a, T b) { return a & b; } \
[ForceInline] T bit_or(T a, T b) { return a | b; } \
[ForceInline] T bit_xor(T a, T b) { return a ^ b; } \
[ForceInline] T lshift(T a, T b) { return a << b; } \
[ForceInline] T rshift(T a, T b) { return a >> b; } \
[ForceInline] T invert(T x) { return ~x; } \
[ForceInline] bool isfinite(T x) { return !isinf(double(x)); } \
[ForceInline] bool isnan(T x) { return isnan(double(x)); } \
[ForceInline] bool isinf(T x) { return isinf(double(x)); } \
[ForceInline] void adj_mul(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_div(T a, T b, T ret, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_add(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_sub(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_mod(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_min(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_max(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_abs(T x, T adj_x, inout T adj_ret) { } \
[ForceInline] void adj_sign(T x, T adj_x, inout T adj_ret) { } \
[ForceInline] void adj_clamp(T x, T a, T b, inout T adj_x, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_floordiv(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_step(T x, inout T adj_x, T adj_ret) { } \
[ForceInline] void adj_nonzero(T x, inout T adj_x, T adj_ret) { } \
[ForceInline] void adj_sqrt(T x, T adj_x, inout T adj_ret) { } \
[ForceInline] void adj_bit_and(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_bit_or(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_bit_xor(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_lshift(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_rshift(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_invert(T x, T adj_x, inout T adj_ret) { } \
[ForceInline] void adj_isnan(const T, inout T, bool) { } \
[ForceInline] void adj_isinf(const T, inout T, bool) { } \
[ForceInline] void adj_isfinite(const T, inout T, bool) { }


// Integer absolute value overloads
[ForceInline] int8 abs(int8 x) { return abs(x); }
[ForceInline] int16 abs(int16 x) { return abs(x); }
[ForceInline] int32 abs(int32 x) { return abs(x); }
// [ForceInline] int64 abs(int64 x) { return llabs(x); }
[ForceInline] uint8 abs(uint8 x) { return x; }
[ForceInline] uint16 abs(uint16 x) { return x; }
[ForceInline] uint32 abs(uint32 x) { return x; }
[ForceInline] uint64 abs(uint64 x) { return x; }


// Instantiate for all types
DECLARE_INT_OPS(int8)
DECLARE_INT_OPS(int16)
DECLARE_INT_OPS(int32)
DECLARE_INT_OPS(int64)
DECLARE_INT_OPS(uint8)
DECLARE_INT_OPS(uint16)
DECLARE_INT_OPS(uint32)
DECLARE_INT_OPS(uint64)

[ForceInline] int8 step(int8 x) { return x < 0 ? 1 : 0; }
[ForceInline] int16 step(int16 x) { return x < 0 ? 1 : 0; }
[ForceInline] int32 step(int32 x) { return x < 0 ? 1 : 0; }
[ForceInline] int64 step(int64 x) { return x < 0 ? 1 : 0; }
[ForceInline] uint8 step(uint8 x) { return 0; }
[ForceInline] uint16 step(uint16 x) { return 0; }
[ForceInline] uint32 step(uint32 x) { return 0; }
[ForceInline] uint64 step(uint64 x) { return 0; }

[ForceInline] int8 sign(int8 x) { return x < 0 ? -1 : 1; }
[ForceInline] int8 sign(int16 x) { return x < 0 ? -1 : 1; }
[ForceInline] int8 sign(int32 x) { return x < 0 ? -1 : 1; }
[ForceInline] int8 sign(int64 x) { return x < 0 ? -1 : 1; }
[ForceInline] uint8 sign(uint8 x) { return 1; }
[ForceInline] uint16 sign(uint16 x) { return 1; }
[ForceInline] uint32 sign(uint32 x) { return 1; }
[ForceInline] uint64 sign(uint64 x) { return 1; }


#define DECLARE_FLOAT_OPS(T) \
[ForceInline] T mul(T a, T b) { return a * b; } \
[ForceInline] T add(T a, T b) { return a + b; } \
[ForceInline] T sub(T a, T b) { return a - b; } \
[ForceInline] T min(T a, T b) { return a < b ? a : b; } \
[ForceInline] T max(T a, T b) { return a > b ? a : b; } \
[ForceInline] T sign(T x) { return x < T(0) ? -1 : 1; } \
[ForceInline] T step(T x) { return x < T(0) ? T(1) : T(0); } \
[ForceInline] T nonzero(T x) { return x == T(0) ? T(0) : T(1); } \
[ForceInline] T clamp(T x, T a, T b) { return min(max(a, x), b); } \
[ForceInline] void adj_abs(T x, inout T adj_x, T adj_ret) { \
    if (x < T(0)) \
        adj_x -= adj_ret; \
    else \
        adj_x += adj_ret; \
} \
[ForceInline] void adj_mul(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { adj_a += b * adj_ret; adj_b += a * adj_ret; } \
[ForceInline] void adj_add(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { adj_a += adj_ret; adj_b += adj_ret; } \
[ForceInline] void adj_sub(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { adj_a += adj_ret; adj_b -= adj_ret; } \
[ForceInline] void adj_min(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { \
    if (a < b) \
        adj_a += adj_ret; \
    else \
        adj_b += adj_ret; \
} \
[ForceInline] void adj_max(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { \
    if (a > b) \
        adj_a += adj_ret; \
    else \
        adj_b += adj_ret; \
} \
[ForceInline] void adj_floordiv(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { } \
[ForceInline] void adj_mod(T a, T b, inout T adj_a, inout T adj_b, T adj_ret) { adj_a += adj_ret; } \
[ForceInline] void adj_sign(T x, T adj_x, inout T adj_ret) { } \
[ForceInline] void adj_step(T x, inout T adj_x, T adj_ret) { } \
[ForceInline] void adj_nonzero(T x, inout T adj_x, T adj_ret) { } \
[ForceInline] void adj_clamp(T x, T a, T b, inout T adj_x, inout T adj_a, inout T adj_b, T adj_ret) { \
    if (x < a) \
        adj_a += adj_ret; \
    else if (x > b) \
        adj_b += adj_ret; \
    else \
        adj_x += adj_ret; \
} \
[ForceInline] T div(T a, T b) { return a / b; } \
[ForceInline] void adj_div(T a, T b, T ret, inout T adj_a, inout T adj_b, T adj_ret) { \
    adj_a += adj_ret / b; \
    adj_b -= adj_ret * (ret) / b; \
} \
[ForceInline] void adj_isnan(const T x, inout T adj_x, bool ret) { } \
[ForceInline] void adj_isinf(const T x, inout T adj_x, bool ret) { } \
[ForceInline] void adj_isfinite(const T x, inout T adj_x, bool ret) { }

DECLARE_FLOAT_OPS(float16)
DECLARE_FLOAT_OPS(float32)
DECLARE_FLOAT_OPS(float64)


// basic ops for float types
[ForceInline]
float16 mod(float16 a, float16 b)
{
    return fmod(float(a), float(b));
}

[ForceInline]
float mod(float a, float b)
{
    return fmod(a, b);
}

[ForceInline]
double mod(double a, double b)
{
    return fmod(a, b);
}

[ForceInline]
float16 log(float16 a)
{
    return ::log(a);
}

[ForceInline]
float log(float a)
{
    return ::log(a);
}

[ForceInline]
double log(double a)
{
    return ::log(a);
}

[ForceInline]
float16 log2(float16 a) 
{
    return ::log2(float(a));    
}

[ForceInline]
float log2(float a) 
{
    return ::log2(a);    
}

[ForceInline]
double log2(double a) 
{
    return ::log2(a);    
}

[ForceInline]
float16 log10(float16 a) 
{
    return ::log10(float(a)); 
}

[ForceInline]
float log10(float a) 
{
    return ::log10(a); 
}

[ForceInline]
double log10(double a) 
{
    return ::log10(a); 
}

[ForceInline]
float16 exp(float16 a)
{
    float16 result = ::exp(float(a));
    return result;
}

[ForceInline]
float exp(float a)
{
    float result = ::exp(a);
    return result;
}

[ForceInline]
double exp(double a)
{
    double result = ::exp(a);
    return result;
}

[ForceInline]
float16 pow(float16 a, float16 b)
{
    float result = ::pow(float(a), float(b));
    return result;
}

[ForceInline]
float pow(float a, float b)
{
    float result = ::pow(a, b);
    return result;
}

[ForceInline]
double pow(double a, double b)
{
    double result = ::pow(a, b);
    return result;
}

[ForceInline]
float16 floordiv(float16 a, float16 b)
{
    return floor(float(a/b));
}

[ForceInline]
float floordiv(float a, float b)
{
    return floor(a/b);
}

[ForceInline]
double floordiv(double a, double b)
{
    return ::floor(a/b);
}












/////
/////  Added out of order
/////

__generic<T>
[ForceInline]
T where(bool cond, T a, T b)
{
    return (!!cond) ? a : b;
}

//
// Invocation indices.
//

const int LAUNCH_MAX_DIMS = 4;   // should match types.py

struct launch_bounds_t
{
    int shape[LAUNCH_MAX_DIMS]; // size of each dimension
    int ndim;                   // number of valid dimension
    size_t size;                // total number of threads
};

struct launch_coord_t
{
    int i;
    int j;
    int k;
    int l;
};

// unravels a linear thread index to the corresponding launch grid coord (up to 4d)
[ForceInline]
inline launch_coord_t launch_coord(size_t linear, const launch_bounds_t bounds)
{
    launch_coord_t coord = {0, 0, 0, 0};

    if (bounds.ndim > 3)
    {
        coord.l = linear%bounds.shape[3];
        linear /= bounds.shape[3];
    }

    if (bounds.ndim > 2)
    {
        coord.k = linear%bounds.shape[2];
        linear /= bounds.shape[2];
    }

    if (bounds.ndim > 1)
    {
        coord.j = linear%bounds.shape[1];
        linear /= bounds.shape[1];
    }

    if (bounds.ndim > 0)
    {
        coord.i = linear;
    }

    return coord;
}

[ForceInline]
int tid(size_t index, const launch_bounds_t bounds)
{
    // launch_coord_t c = launch_coord(index, bounds);
    // return (int)(c.i);
    return index;
}


//
// Atomics.
//

// // __generic<T: __BuiltinFloatingPointType>
// [Forceinline]
// float atomic_add(float* buf, float value)
// {
//     return atomicAdd(*buf, value);
// }

}