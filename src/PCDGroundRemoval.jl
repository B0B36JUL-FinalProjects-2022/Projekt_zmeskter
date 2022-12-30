module PCDGroundRemoval

# Write your package code here.
include("xyzIO.jl")
include("pointsDeleting.jl")


function make_pillar_grid(points::Matrix{<:Real}; grid_box_size = 1.8)
    """
    take Nx3 Matrix of points and return points devided to grid: NxMx3 array
    """
    x_max,y_max,x_min, y_min = my_extremas(points, grid_box_size)
    x_size = x_min + x_max
    y_size = y_min + y_max
    #println(x_size,"   ", y_size)
    x = points[:,1]
    y = points[:,2]
    grid = zeros((Int64(x_size*y_size), size(points)[1], 3))
    for i = 0:x_size-1
        for j =0:y_size-1
            x_test1 = findall(c-> c < (grid_box_size*i - x_min), x)
            x_test2 = findall(c-> c >= (grid_box_size*(i-1) - x_min),x)
            y_test1 = findall(c-> c < (grid_box_size*j-y_min),y)
            y_test2 = findall(c-> c >= (grid_box_size*(j-1)-y_min),y)
            x_test = intersect(x_test1,x_test2)
            y_test = intersect(y_test1,y_test2)
            common = intersect(x_test,y_test)
            #println(common, "   ", i*x_size + j + 1, "    ",points[common,:])
            shape = size(common)
            grid[i*x_size + j + 1, 1:shape[1], :] = points[common,:]
        end
    end
    return delete_zero(grid)

end

function my_extremas(points::Matrix{<:Real}, grid_box_size)
    x_max = ceil(Int64,ceil( (abs(maximum(points[:,1]))))/grid_box_size)
    y_max = ceil(Int64,ceil((abs(maximum(points[:,2]))))/grid_box_size)
    x_min = ceil(Int64,ceil((abs(minimum(points[:,1]))))/grid_box_size)
    y_min = ceil(Int64,ceil((abs(minimum(points[:,2]))))/grid_box_size)
    return x_max,y_max,x_min, y_min
end

function distance(point1::Array{<:Real}, point2::Array{<:Real})
    #d = ((x2 - x1)2 + (y2 - y1)2 + (z2 - z1)2)1/2 
    x1,y1,z1 = point1
    x2,y2,z2 = point2
    return sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function pcl_distances(points1::Matrix{<:Real},points2::Matrix{<:Real})
    size1 = size(points1)[1]
    size2 = size(points2)[1]
    println(size1, "   ", size2)
    if size1==0 || size2 == 0
        error("one of the pcl contains no point")
    end
    min_distances = zeros(size1)
    for i = 1:size1
        min_distances2 = zeros(size2)
        for j = 1:size2
            min_distances2[j] = distance(points1[i,:], points2[j,:])
        end
        min_distances[i] = minimum(min_distances2)
    end
    return minimum(min_distances)
end

export make_pillar_grid, distance, pcl_distances
end
