using Revise # this must come before `using ImageInspector`
using PCDGroundRemoval

points = read_xyz("data//pol.xyz")
grid = make_pillar_grid(points;grid_box_size= 1.8)
delete_zero(grid[1,:,:])
save_xyz(points, "data//test2.xyz")