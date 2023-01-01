using Revise # this must come before `using PCDGroundRemoval`
using PCDGroundRemoval

#load data
points = read_xyz("data//1651738515.007457803.xyz")
#points = read_xyz("data//pol.xyz")
#compute distances from [0,0,0]
distances = distance([0, 0, 0],points)
#remove dron points
points = remove_drone(points, distances)
print(points)
#sort points into pillar grid
grid = make_pillar_grid(points;grid_box_size= 1.8)
#label ground points
ground = label_ground_points(grid; threshold = 0.4)
possible_ground_idx = findall(pts -> pts < 0, ground[:,3])
ground = ground[possible_ground_idx, :]
possible_ground = labels_single_ground_points(points)
#save data after dron removal
save_xyz(points, "data//test2.xyz")

#find if point is in pointcloud
pts = points[2,:]
findall(all(points .!= pts', dims=2)[:, 1])

#examples of distance and removal functions calls
delete_zero(grid[1,:,:])
distance([0, 0, 0],points)
distance(delete_zero(grid[1,:,:]), delete_zero(grid[3,:,:]))
distance(delete_zero(grid[1,:,:]), delete_zero(grid[2,:,:]))
distance(delete_zero(grid[2,:,:]), delete_zero(grid[1,:,:]))
distance(delete_zero(grid[1,:,:]), Matrix{Float64}(undef,0,3))

#visualizations
using Plots

plotlyjs()
scatter3d(points[:,1], points[:,2], points[:, 3],color = RGB(0,1,0), markersize = 1)
scatter3d!(ground[:,1], ground[:,2], ground[:, 3], color = RGB(1,0,0),markersize = 1)