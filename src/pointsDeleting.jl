
function delete_zero(points::Array{<:Real,3})
    """
    take NxMx3 array of point sorted into N pillars and delete those pillars which contain no point -> [n,:,:] are only zeros
    """
    indexes = []
    for i = 1:size(points)[1]
        #println(points[i,:,:])
        #println("i=",i, "    ",sum(points[i,:,1:2]) )
        if sum(points[i,:,1:2]) != 0
            append!(indexes, i)
        end
    end
    #print(indexes)
    grid2 = zeros((size(indexes)[1], size(points)[2], 3))
    for i = 1:size(indexes)[1]
        grid2[i,:,:] = points[indexes[i],:,:]
    end
    return grid2
end

function delete_zero(points::Array{<:Real,2})
    """
    take Nx3 Matrix of 3D point and delete all occurrences of point [0,0,0]
    """
    indexes = []
    for i=1:size(points)[1]
        #println(sum(points[i,:]), "   ", i)
        if sum(points[i,1:2]) != 0
            append!(indexes, i)
        end
    end
    real_points = zeros((size(indexes)[1], 3))
    for i = 1:size(indexes)[1]
        real_points[i,:] = points[i,:]
    end
    return real_points
end

export delete_zero