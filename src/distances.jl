
function distance(points1::Array{<:Real}, points2::Array{<:Real})
    """
    calculate the distance of two points in 3D space given as two Arrays
    """
    #d = ((x2 - x1)2 + (y2 - y1)2 + (z2 - z1)2)1/2 
    x1,y1,z1 = points1
    x2,y2,z2 = points2
    return sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

function distance(points1::Array{<:Real}, points2::Matrix{<:Real})
    """
    calculate the distance of a custer of points (points2) given as Matrix from one specified point (points1) given as Array
    """
    num_of_points = size(points2)[1]
    distances = zeros( num_of_points)
    for j = 1: num_of_points
        distances[j] = distance(points1, points2[j,:])
    end
    return distances
end

function distance(points1::Matrix{<:Real},points2::Matrix{<:Real})
    """
    calculate the distance of two clusters of points given as Matrix
    Where the distance of these clusters is defined as the smallest distance between two points when each is from a different cluster
    """
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

export  distance, pcl_distances