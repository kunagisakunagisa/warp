#define WP_TILE_BLOCK_DIM 1
#define WP_NO_CRT
#include "slang/builtin.slang"

// avoid namespacing of float type for casting to float type, this is to avoid wp::float(x), which is not valid in C++
#define float(x) cast_float(x)
#define adj_float(x, adj_x, adj_ret) adj_cast_float(x, adj_x, adj_ret)

#define int(x) cast_int(x)
#define adj_int(x, adj_x, adj_ret) adj_cast_int(x, adj_x, adj_ret)

#define builtin_tid1d() wp::tid(task_index, dim)
#define builtin_tid2d(x, y) wp::tid(x, y, task_index, dim)
#define builtin_tid3d(x, y, z) wp::tid(x, y, z, task_index, dim)
#define builtin_tid4d(x, y, z, w) wp::tid(x, y, z, w, task_index, dim)

#define builtin_block_dim() wp::block_dim()

typedef DifferentialPair<float> dpfloat;
typedef float.Differential dfloat;


[Differentiable]
void kernel_forward(
    wp::launch_bounds_t dim,
    size_t task_index,
    wp::float32 var_value,
    wp::array_t<wp::float32> var_out)
{
    //---------
    // primal vars
    wp::int32 var_0;
    const wp::int32 var_1 = 0;
    bool var_2;
    const wp::float32 var_3 = 2.0;
    wp::float32 var_4;
    bool var_5;
    wp::float32 var_6;
    //---------
    // forward
    // def threshold(value: float, out: wp.array(dtype=float)):                               <L 7>
    // i = wp.tid()                                                                           <L 8>
    var_0 = builtin_tid1d();
    // if i == 0:                                                                             <L 10>
    var_2 = (var_0 == var_1);
    if (var_2) {
        // out[i] = value * 2.0                                                               <L 11>
        var_4 = wp::mul(var_value, var_3);
        wp::array_store(var_out, var_0, var_4);
        // return                                                                             <L 12>
        return;
    }
    // out[i] = value * value;                                                                <L 14>
    var_6 = wp::mul(var_value, var_value);
    wp::array_store(var_out, var_0, var_6);
}

struct ShaderInputs
{
    wp::launch_bounds_t launch_bounds;

    // Kernel parameters.
    wp::float32* var_value;
    wp::array_t<wp::float32>* var_out;
};

ConstantBuffer<ShaderInputs> inputs;

[shader("compute")]
[numthreads(32)]
void computeMain(uint3 dispatch_id : SV_DispatchThreadID)
{
     dpfloat dpa = dpfloat(1.0, 0.0);

        __bwd_diff(kernel_forward)(dpa, inputs.launch_bounds,  *(inputs.var_value), *(inputs.var_out));
    
    // kernel_forward(inputs.launch_bounds, dispatch_id.x, *(inputs.var_value), *(inputs.var_out));
}
