
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

export  distance, pcl_distances