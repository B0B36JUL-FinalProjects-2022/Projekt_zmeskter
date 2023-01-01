module PCDGroundRemoval

# Write your package code here.
include("xyzIO.jl")
include("pointsDeleting.jl")
include("distances.jl")

"""
    make_pillar_grid(points::Matrix{<:Real}; grid_box_size = 1.8)

Take Nx3 Matrix of points and return points devided to grid with specific box size: NxMx3 array and delete those pillars with no points
# Examples
```julia-repl
julia> make_pillar_grid([0 0 0; 1 1 1; 2 2 2; 1.5 1.5 1.5; 3 3 3]; grid_box_size = 1.8)
2x5x3 Array{Float64, 3}:
[:, :, 1] =
 0.0  1.0  1.5  0.0  0.0
 2.0  3.0  0.0  0.0  0.0

[:, :, 2] =
 0.0  1.0  1.5  0.0  0.0
 2.0  3.0  0.0  0.0  0.0

[:, :, 3] =
 0.0  1.0  1.5  0.0  0.0
 2.0  3.0  0.0  0.0  0.0

 julia> make_pillar_grid([0 0 0; 1 1 1; 2 2 2; 1.5 1.5 1.5; 3.1 3.1 3]; grid_box_size = 1)
3x5x3 Array{Float64, 3}:
[:, :, 1] =
 1.0  1.5  0.0  0.0  0.0
 2.0  0.0  0.0  0.0  0.0
 3.1  0.0  0.0  0.0  0.0

[:, :, 2] =
 1.0  1.5  0.0  0.0  0.0
 2.0  0.0  0.0  0.0  0.0
 3.1  0.0  0.0  0.0  0.0

[:, :, 3] =
 1.0  1.5  0.0  0.0  0.0
 2.0  0.0  0.0  0.0  0.0
 3.0  0.0  0.0  0.0  0.0
```
"""
function make_pillar_grid(points::Matrix{<:Real}; grid_box_size = 1.8)
    x_max,y_max,x_min, y_min = my_extremas(points, grid_box_size)
    xmin = ceil(abs(minimum(points[:,1])))
    ymin = ceil(abs(minimum(points[:,2])))
    #println(x_max, " ", x_min, " ", y_max, " ", y_min, " ", xmin, " ", ymin)
    x_size = x_min + x_max
    y_size = y_min + y_max
    #println(x_size,"   ", y_size)
    X = points[:,1]
    Y = points[:,2]
    grid = zeros((Int64(x_size*y_size), size(points)[1], 3))
    for i = 1:x_size
        for j =1:y_size
            x_part1 = findall(x-> x < (grid_box_size*i - xmin), X)
            x_part2 = findall(x-> x >= (grid_box_size*(i-1) - xmin),X)
            y_part1 = findall(y-> y < (grid_box_size*j-ymin),Y)
            y_part2 = findall(y-> y >= (grid_box_size*(j-1)-ymin),Y)
            #println(x_part1, "    ", x_part2)
            x_part= intersect(x_part1,x_part2)
            y_part = intersect(y_part1,y_part2)
            common = intersect(x_part,y_part)
            #println(common, "   ", i*x_size + j + 1, "    ",points[common,:])
            shape = size(common)
            grid[(i-1)*x_size + j, 1:shape[1], :] = points[common,:]
        end
    end
    #print(size(grid))
    return delete_zero(grid)

end

function my_extremas(points::Matrix{<:Real}, grid_box_size)
    x_max = ceil(Int64,ceil( (abs(maximum(points[:,1]))))/grid_box_size)
    y_max = ceil(Int64,ceil((abs(maximum(points[:,2]))))/grid_box_size)
    x_min = ceil(Int64,ceil((abs(minimum(points[:,1]))))/grid_box_size)
    y_min = ceil(Int64,ceil((abs(minimum(points[:,2]))))/grid_box_size)
    return x_max,y_max,x_min, y_min
end

function remove_drone(points::Matrix{<:Real}, distances::Array{<:Real})
    distance_not_zero_idx = findall(dist-> dist != 0, distances)
    distance_not_zero = distances[distance_not_zero_idx]
    distance_smaller_than = findall(dist-> dist >= 0.35, distance_not_zero)
    points_without_zero = points[distance_not_zero_idx,:]
    points = points_without_zero[distance_smaller_than,:]
    return points
end



export make_pillar_grid, remove_drone
end