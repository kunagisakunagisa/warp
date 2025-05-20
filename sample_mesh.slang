
// #define WP_TILE_BLOCK_DIM 1
// #define WP_NO_CRT
// #include "builtin.h"

#include "slang/builtin_complete.slang"

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

void accumulate_cdf_53384ead_cpu_kernel_forward(
    wp::launch_bounds_t dim,
    size_t task_index,
    wp::int32 var_tri_count,
    wp::array_t<wp::float32> var_out_cdf)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 1;
    wp::range_t var_1;
    wp::int32 var_2;
    const wp::int32 var_3 = 1;
    wp::int32 var_4;
    wp::float32* var_5;
    wp::float32 var_6;
    wp::float32 var_7;
    //---------
    // forward
    // def accumulate_cdf(                                                                    <L 155>
    // for tri in range(1, tri_count):                                                        <L 160>
    var_1 = wp::range(var_0, var_tri_count);
    // start_for_0:;
        while(wp::iter_cmp(var_1)) {
            var_2 = wp::iter_next(var_1);
            // out_cdf[tri] += out_cdf[tri - 1]                                               <L 161>
            var_4 = wp::sub(var_2, var_3);
            var_5 = wp::address(var_out_cdf, var_4);
            var_7 = wp::load(var_5);
            var_6 = wp::atomic_add(var_out_cdf, var_2, var_7);
            // var_out_cdf.data[var_2] += var_7;
        // end_for_0:;
        } // FW end for
}

void simple1(
    wp::launch_bounds_t dim,
    size_t task_index,
    wp::int32 var_tri_count,
    wp::array_t<wp::float32> var_out_cdf)
{
    //---------
    // primal vars
    const wp::int32 var_0 = 1;
    wp::range_t var_1;
    wp::int32 var_2;
    const wp::int32 var_3 = 1;
    wp::int32 var_4;
    wp::float32* var_5;
    wp::float32 var_6;
    wp::float32 var_7;

    // uint index = gl_GlobalInvocationID.x;
    // var_out_cdf.data[index] = index * 2;

    // //---------
    // // forward
    // // def accumulate_cdf(                                                                    <L 155>
    // // for tri in range(1, tri_count):                                                        <L 160>
    var_1 = wp::range(var_0, var_tri_count);
    // start_for_0:;
        while(wp::iter_cmp(var_1)) {
            var_2 = wp::iter_next(var_1);
            // out_cdf[tri] += out_cdf[tri - 1]                                               <L 161>
            var_4 = wp::sub(var_2, var_3);
            var_5 = wp::address(var_out_cdf, var_4);
            var_7 = wp::load(var_5);
            var_6 = wp::atomic_add(var_out_cdf, var_2, var_7);
            // var_out_cdf.data[var_2] += var_7;
        // end_for_0:;
        } // FW end for
}

struct ShaderInputs
{
    wp::launch_bounds_t launch_bounds;

    // Kernel parameters.
    wp::int32* var_value;
    wp::array_t<wp::float32>* var_out;
};

ConstantBuffer<ShaderInputs> inputs;

struct SI
{
    wp::launch_bounds_t launch_bounds;
    wp::float32 *ptr1;
    wp::int32 var_value;
    wp::array_t<wp::float32> var_out;
}
ConstantBuffer<SI> input1;

[shader("compute")]
[numthreads(32, 1, 1)]
void computeMain(uint3 dispatch_id : SV_DispatchThreadID)
{
    accumulate_cdf_53384ead_cpu_kernel_forward(inputs.launch_bounds, dispatch_id.x, *(inputs.var_value), *(inputs.var_out));
}


void compute_probability_distribution_4b3d1eed_cpu_kernel_forward(
    wp::launch_bounds_t dim,
    size_t task_index,
    wp::array_t<wp::float32> var_tri_areas,
    wp::array_t<wp::float32> var_total_area,
    wp::array_t<wp::float32> var_out_probabilities)
{
    //---------
    // primal vars
    wp::int32 var_0;
    wp::float32* var_1;
    const wp::int32 var_2 = 0;
    wp::float32* var_3;
    wp::float32 var_4;
    wp::float32 var_5;
    wp::float32 var_6;
    //---------
    // forward
    // def compute_probability_distribution(                                                  <L 142>
    // tri = wp.tid()                                                                         <L 147>
    var_0 = builtin_tid1d();
    // out_probabilities[tri] = tri_areas[tri] / total_area[0]                                <L 151>
    var_1 = wp::address(var_tri_areas, var_0);
    var_3 = wp::address(var_total_area, var_2);
    var_5 = wp::load(var_1);
    var_6 = wp::load(var_3);
    var_4 = wp::div(var_5, var_6);
    wp::array_store(var_out_probabilities, var_0, var_4);
}


// void sample_mesh_08ea8426_cpu_kernel_forward(
//     wp::launch_bounds_t dim,
//     size_t task_index,
//     wp::uint64 var_mesh,
//     wp::array_t<wp::float32> var_cdf,
//     wp::int32 var_seed,
//     wp::array_t<wp::vec_t<3,wp::float32>> var_out_points)
// {
//     //---------
//     // primal vars
//     wp::int32 var_0;
//     wp::uint32 var_1;
//     wp::float32 var_2;
//     wp::int32 var_3;
//     wp::float32 var_4;
//     wp::float32 var_5;
//     const wp::float32 var_6 = 1.0;
//     wp::float32 var_7;
//     wp::float32 var_8;
//     wp::float32 var_9;
//     const wp::float32 var_10 = 1.0;
//     wp::float32 var_11;
//     wp::float32 var_12;
//     wp::vec_t<3,wp::float32> var_13;
//     //---------
//     // forward
//     // def sample_mesh(                                                                       <L 165>
//     // tid = wp.tid()                                                                         <L 171>
//     var_0 = builtin_tid1d();
//     // rng = wp.rand_init(seed, tid)                                                          <L 173>
//     var_1 = wp::rand_init(var_seed, var_0);
//     // sample = wp.randf(rng)                                                                 <L 176>
//     var_2 = wp::randf(var_1);
//     // tri = wp.lower_bound(cdf, sample)                                                      <L 177>
//     var_3 = wp::lower_bound(var_cdf, var_2);
//     // ru = wp.randf(rng)                                                                     <L 180>
//     var_4 = wp::randf(var_1);
//     // rv = wp.randf(rng)                                                                     <L 181>
//     var_5 = wp::randf(var_1);
//     // tri_u = 1.0 - wp.sqrt(ru)                                                              <L 182>
//     var_7 = wp::sqrt(var_4);
//     var_8 = wp::sub(var_6, var_7);
//     // tri_v = wp.sqrt(ru) * (1.0 - rv)                                                       <L 183>
//     var_9 = wp::sqrt(var_4);
//     var_11 = wp::sub(var_10, var_5);
//     var_12 = wp::mul(var_9, var_11);
//     // pos = wp.mesh_eval_position(mesh, tri, tri_u, tri_v)                                   <L 184>
//     var_13 = wp::mesh_eval_position(var_mesh, var_3, var_8, var_12);
//     // out_points[tid] = pos                                                                  <L 187>
//     wp::array_store(var_out_points, var_0, var_13);
// }


// void compute_tri_areas_5da7cd6b_cpu_kernel_forward(
//     wp::launch_bounds_t dim,
//     size_t task_index,
//     wp::array_t<wp::vec_t<3,wp::float32>> var_points,
//     wp::array_t<wp::int32> var_face_vertex_indices,
//     wp::array_t<wp::float32> var_out_tri_areas,
//     wp::array_t<wp::float32> var_out_total_area)
// {
//     //---------
//     // primal vars
//     wp::int32 var_0;
//     const wp::int32 var_1 = 3;
//     wp::int32 var_2;
//     wp::int32* var_3;
//     wp::int32 var_4;
//     wp::int32 var_5;
//     const wp::int32 var_6 = 3;
//     wp::int32 var_7;
//     const wp::int32 var_8 = 1;
//     wp::int32 var_9;
//     wp::int32* var_10;
//     wp::int32 var_11;
//     wp::int32 var_12;
//     const wp::int32 var_13 = 3;
//     wp::int32 var_14;
//     const wp::int32 var_15 = 2;
//     wp::int32 var_16;
//     wp::int32* var_17;
//     wp::int32 var_18;
//     wp::int32 var_19;
//     wp::vec_t<3,wp::float32>* var_20;
//     wp::vec_t<3,wp::float32> var_21;
//     wp::vec_t<3,wp::float32> var_22;
//     wp::vec_t<3,wp::float32>* var_23;
//     wp::vec_t<3,wp::float32> var_24;
//     wp::vec_t<3,wp::float32> var_25;
//     wp::vec_t<3,wp::float32>* var_26;
//     wp::vec_t<3,wp::float32> var_27;
//     wp::vec_t<3,wp::float32> var_28;
//     wp::vec_t<3,wp::float32> var_29;
//     wp::vec_t<3,wp::float32> var_30;
//     wp::vec_t<3,wp::float32> var_31;
//     wp::float32 var_32;
//     const wp::float32 var_33 = 0.5;
//     wp::float32 var_34;
//     const wp::int32 var_35 = 0;
//     wp::float32 var_36;
//     //---------
//     // forward
//     // def compute_tri_areas(                                                                 <L 113>
//     // tri = wp.tid()                                                                         <L 119>
//     var_0 = builtin_tid1d();
//     // vtx_0 = face_vertex_indices[tri * 3]                                                   <L 122>
//     var_2 = wp::mul(var_0, var_1);
//     var_3 = wp::address(var_face_vertex_indices, var_2);
//     var_5 = wp::load(var_3);
//     var_4 = wp::copy(var_5);
//     // vtx_1 = face_vertex_indices[tri * 3 + 1]                                               <L 123>
//     var_7 = wp::mul(var_0, var_6);
//     var_9 = wp::add(var_7, var_8);
//     var_10 = wp::address(var_face_vertex_indices, var_9);
//     var_12 = wp::load(var_10);
//     var_11 = wp::copy(var_12);
//     // vtx_2 = face_vertex_indices[tri * 3 + 2]                                               <L 124>
//     var_14 = wp::mul(var_0, var_13);
//     var_16 = wp::add(var_14, var_15);
//     var_17 = wp::address(var_face_vertex_indices, var_16);
//     var_19 = wp::load(var_17);
//     var_18 = wp::copy(var_19);
//     // pt_0 = points[vtx_0]                                                                   <L 127>
//     var_20 = wp::address(var_points, var_4);
//     var_22 = wp::load(var_20);
//     var_21 = wp::copy(var_22);
//     // pt_1 = points[vtx_1]                                                                   <L 128>
//     var_23 = wp::address(var_points, var_11);
//     var_25 = wp::load(var_23);
//     var_24 = wp::copy(var_25);
//     // pt_2 = points[vtx_2]                                                                   <L 129>
//     var_26 = wp::address(var_points, var_18);
//     var_28 = wp::load(var_26);
//     var_27 = wp::copy(var_28);
//     // cross = wp.cross((pt_1 - pt_0), (pt_2 - pt_0))                                         <L 133>
//     var_29 = wp::sub(var_24, var_21);
//     var_30 = wp::sub(var_27, var_21);
//     var_31 = wp::cross(var_29, var_30);
//     // area = wp.length(cross) * 0.5                                                          <L 134>
//     var_32 = wp::length(var_31);
//     var_34 = wp::mul(var_32, var_33);
//     // out_tri_areas[tri] = area                                                              <L 137>
//     wp::array_store(var_out_tri_areas, var_0, var_34);
//     // wp.atomic_add(out_total_area, 0, area)                                                 <L 138>
//     var_36 = wp::atomic_add(var_out_total_area, var_35, var_34);
// }

