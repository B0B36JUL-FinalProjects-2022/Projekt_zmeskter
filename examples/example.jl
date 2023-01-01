using Revise # this must come before `using PCDGroundRemoval`
using PCDGroundRemoval

#load data
points = read_xyz("data//pol.xyz")
#compute distances from [0,0,0]
distances = distance([0, 0, 0],points)
#remove dron points
points = remove_drone(points, distances)
print(points)
#sort points into pillar grid
grid = make_pillar_grid(points;grid_box_size= 1.8)
#save data after dron removal
save_xyz(points, "data//test2.xyz")

#examples of distance and removal functions calls
delete_zero(grid[1,:,:])
distance([0, 0, 0],points)
distance(delete_zero(grid[1,:,:]), delete_zero(grid[3,:,:]))
distance(delete_zero(grid[1,:,:]), delete_zero(grid[2,:,:]))
distance(delete_zero(grid[2,:,:]), delete_zero(grid[1,:,:]))
distance(delete_zero(grid[1,:,:]), Matrix{Float64}(undef,0,3))
