#include "array.slang"
#include "range.slang"

///
/// C++ builtin types.
///

typealias size_t = uint64_t;

namespace wp
{

///
/// Warp C++ typedefs.
///

typealias float32 = float;
typealias float64 = double;

typealias int8 = int8_t;
typealias uint8 = uint8_t;

typealias int16 = int16_t;
typealias uint16 = uint16_t;

typealias int32 = int32_t;
typealias uint32 = uint32_t;

typealias int64 = int64_t;
typealias uint64 = uint64_t;


//
// Language intrinsics.
//

__generic<T>
[ForceInline]
T where(bool cond, T a, T b)
{
    return (!!cond) ? a : b;
}


//
// Arithmetic intrinsics.
//

__generic<T : __BuiltinArithmeticType>
[ForceInline]
T mul(T a, T b)
{
    return a * b;
}

__generic<T : __BuiltinArithmeticType>
[ForceInline]
void adj_mul(T a, T b, out T adj_a, out T adj_b, T adj_ret) { adj_a += b*adj_ret; adj_b += a*adj_ret; }


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
    launch_coord_t c = launch_coord(index, bounds);
    return (int)(c.i);
}

}
