using Revise # this must come before `using PCDGroundRemoval`
using PCDGroundRemoval

points = read_xyz("data//pol.xyz")
print(points)
grid = make_pillar_grid(points;grid_box_size= 1.8)
delete_zero(grid[1,:,:])
for i = 1:size(points)[1]
    println(distance(points[i,:], [0;0;0]))
end
grid[1,:,:]
grid[2,:,:]
distance(delete_zero(grid[1,:,:]), delete_zero(grid[3,:,:]))
distance(delete_zero(grid[1,:,:]), delete_zero(grid[2,:,:]))
distance(delete_zero(grid[2,:,:]), delete_zero(grid[1,:,:]))
distance(delete_zero(grid[1,:,:]), Matrix{Float64}(undef,0,3))
save_xyz(points, "data//test2.xyz")