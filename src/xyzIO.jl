using FileIO


function save_xyz(points::Matrix{Float64}, filename::String)
    """
    Save points stored in Matrix format (Nx3) into an xyz file with specified filename
    """
    prep_points = [join(k, " ") for k in  eachrow(points)]
    len = size(prep_points,1)
    open(filename, "w") do file
        for l = 1:len
            write(file, prep_points[l])
            write(file, "\n")
        end
    end
end

function read_xyz(ifile::String)
    """
    Reads in an xyz file and return points cooridantes in Matrix format (Nx3)
    """
    @time file_contents = readlines(ifile)
    N = size(file_contents, 1)
    points = zeros((N,3))
    for (i, line) in enumerate(file_contents)
        coords = split(file_contents[i])
        points[i,:] = parse.(Float64, coords)
    end
    return points
end

export save_xyz, read_xyz
