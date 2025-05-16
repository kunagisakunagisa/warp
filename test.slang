#include "builtin.slang"

// avoid namespacing of float type for casting to float type, this is to avoid wp::float(x), which is not valid in C++
#define float(x) cast_float(x)
#define adj_float(x, adj_x, adj_ret) adj_cast_float(x, adj_x, adj_ret)

#define int(x) cast_int(x)
#define adj_int(x, adj_x, adj_ret) adj_cast_int(x, adj_x, adj_ret)

#define builtin_tid1d() wp::tid(task_index, dim)
#define builtin_tid2d(x, y) wp::tid(x, y, task_index, dim)
#define builtin_tid3d(x, y, z) wp::tid(x, y, z, task_index, dim)
#define builtin_tid4d(x, y, z, w) wp::tid(x, y, z, w, task_index, dim)


#define WP_API

void threshold_5c48d906_cpu_kernel_forward(
    wp::launch_bounds_t dim,
    size_t task_index,
    wp::float32 var_value,
    wp::array_t<wp::float32> var_out)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::float32* var_1;
    bool var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1.0;
    const wp::float32 var_5 = 1.0;
    const wp::float32 var_6 = -1.0;
    wp::float32 var_7;
    //---------
    // forward
    // def threshold(value: float, out: wp.array(dtype=float)):                               <L 7>
    // i = wp.tid()                                                                           <L 8>
    var_0 = builtin_tid1d();
    // out[i] = 1.0 if out[i] < value else -1.0                                               <L 10>
    var_1 = wp::address(var_out, var_0);
    var_3 = wp::load(var_1);
    var_2 = (var_3 < var_value);
    var_7 = wp::where(var_2, var_4, var_6);
    wp::array_store(var_out, var_0, var_7);
}



void threshold_5c48d906_cpu_kernel_backward(
    wp::launch_bounds_t dim,
    size_t task_index,
    wp::float32 var_value,
    wp::array_t<wp::float32> var_out,
    wp::float32 adj_value,
    wp::array_t<wp::float32> adj_out)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::float32* var_1;
    bool var_2;
    wp::float32 var_3;
    const wp::float32 var_4 = 1.0;
    const wp::float32 var_5 = 1.0;
    const wp::float32 var_6 = -1.0;
    wp::float32 var_7;
    //---------
    // dual vars
    wp::int32 adj_0 = {};
    wp::float32 adj_1 = {};
    bool adj_2 = {};
    wp::float32 adj_3 = {};
    wp::float32 adj_4 = {};
    wp::float32 adj_5 = {};
    wp::float32 adj_6 = {};
    wp::float32 adj_7 = {};
    //---------
    // forward
    // def threshold(value: float, out: wp.array(dtype=float)):                               <L 7>
    // i = wp.tid()                                                                           <L 8>
    var_0 = builtin_tid1d();
    // out[i] = 1.0 if out[i] < value else -1.0                                               <L 10>
    var_1 = wp::address(var_out, var_0);
    var_3 = wp::load(var_1);
    var_2 = (var_3 < var_value);
    var_7 = wp::where(var_2, var_4, var_6);
    // wp::array_store(var_out, var_0, var_7);
    //---------
    // reverse
    wp::adj_array_store(var_out, var_0, var_7, adj_out, adj_0, adj_7);
    wp::adj_where(var_2, var_4, var_6, adj_2, adj_4, adj_6, adj_7);
    wp::adj_load(var_1, adj_1, adj_3);
    wp::adj_address(var_out, var_0, adj_out, adj_0, adj_1);
    // adj: out[i] = 1.0 if out[i] < value else -1.0                                          <L 10>
    // adj: i = wp.tid()                                                                      <L 8>
    // adj: def threshold(value: float, out: wp.array(dtype=float)):                          <L 7>
    return;
}



extern "C" {

// Python CPU entry points
WP_API void threshold_5c48d906_cpu_forward(
    wp::launch_bounds_t dim,
    wp::float32 var_value,
    wp::array_t<wp::float32> var_out)
{
for (size_t task_index = 0; task_index < dim.size; ++task_index)
    {
        // init shared memory allocator
        wp::tile_alloc_shared(0, true);

        threshold_5c48d906_cpu_kernel_forward(
            dim,
            task_index,
            var_value,
            var_out);

        // check shared memory allocator
        wp::tile_alloc_shared(0, false, true);

    }
}


/*
WP_API void threshold_5c48d906_cpu_backward(
    wp::launch_bounds_t dim,
    wp::float32 var_value,
    wp::array_t<wp::float32> var_out,
    wp::float32 adj_value,
    wp::array_t<wp::float32> adj_out)
{
    for (size_t task_index = 0; task_index < dim.size; ++task_index)
    {
        // initialize shared memory allocator
        wp::tile_alloc_shared(0, true);

        threshold_5c48d906_cpu_kernel_backward(
            dim,
            task_index,
            var_value,
            var_out,
            adj_value,
            adj_out);

        // check shared memory allocator
        wp::tile_alloc_shared(0, false, true);
    }
}
*/
