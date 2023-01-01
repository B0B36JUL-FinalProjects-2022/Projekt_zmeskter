
"""
    distance(points1::Array{<:Real}, points2::Array{<:Real})

calculate the distance of two points in 3D space given as two Arrays
# Examples
```julia-repl
julia> distance([1,1,1],[1,2,3])
2.23606797749979
```
"""
function distance(points1::Array{<:Real}, points2::Array{<:Real})
    #d = ((x2 - x1)2 + (y2 - y1)2 + (z2 - z1)2)1/2 
    x1,y1,z1 = points1
    x2,y2,z2 = points2
    return sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

"""
    distance(points1::Array{<:Real}, points2::Matrix{<:Real})

calculate distances of points from cluster (points2) given as Matrix from one specified point (points1) given as Array
# Examples
```julia-repl
julia> distance([1,1,1], [1 2 3;2 3 4;3 4 5])
3-element Vector{Float64}:
 2.23606797749979
 3.7416573867739413
 5.385164807134504
```
"""
function distance(points1::Array{<:Real}, points2::Matrix{<:Real})
    num_of_points = size(points2)[1]
    distances = zeros( num_of_points)
    for j = 1: num_of_points
        distances[j] = distance(points1, points2[j,:])
    end
    return distances
end
"""
    distance(points1::Matrix{<:Real},points2::Matrix{<:Real})
    
calculate the distance of two clusters of points given as Matrix
where the distance of these clusters is defined as the smallest distance between two points where each is from a different cluster
# Examples
```julia-repl
julia> distance([1 1 1; 2 2 2; 3 3 3], [1 2 3; 2 3 4; 3 4 5])
1.4142135623730951
```
"""
function distance(points1::Matrix{<:Real},points2::Matrix{<:Real})
    
    size1 = size(points1)[1]
    size2 = size(points2)[1]
    #println(size1, "   ", size2)
    if size1==0 || size2 == 0
        error("one of the clusters contains no point")
    end
    min_distances = zeros(size1)
    for i = 1:size1
        min_distances[i] = minimum(distance(points1[i,:], points2))
    end
    return minimum(min_distances)
end

export  distance