using Revise # this must come before `using ImageInspector`
using PCDGroundRemoval

points = read_xyz("data//pol.xyz")
save_xyz(points, "data//test2.xyz")