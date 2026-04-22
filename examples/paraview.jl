using FEMLab

## unstructured quadrilateral mesh

# columns: node indices, rows: x- and y-coordinates
nodes = [
    -8.3  -4.7  -1.8  -3.3  -9.2  -4.0   1.8  2.8  2.8  1.8
     1.2  -2.4   1.5   4.5   5.4   6.0  -1.7  2.2  7.0  9.4
]

# columns: element indices, rows: node indices
elements = [
    1   4  1  3  2
    4   9  2  8  7
    6  10  3  9  8
    5   6  4  4  3
]

# number of nodes
nnodes = size(nodes, 2)

# number of elements
nelems = size(elements, 2)

# unstructured paraview output
points = vcat(nodes, zeros(nnodes)') # adds third row with zero z-coordinate
cells = [MeshCell(VTKCellTypes.VTK_LAGRANGE_QUADRILATERAL, elements[:, k]) for k in 1:nelems ]
vtk_grid(joinpath("results", "unstructured_quad_mesh"), points, cells) do vtk
    vtk["coordinates"] = points
    vtk["element_indices"] = 1:nelems
end




## unstructured triangular mesh

# columns: node indices, rows: x- and y-coordinates
nodes = [
    -8.3  -4.7  -1.8  -3.3  -9.2  -4.0   1.8  2.8  2.8  1.8
     1.2  -2.4   1.5   4.5   5.4   6.0  -1.7  2.2  7.0  9.4
]

# columns: element indices, rows: node indices
elements = [
    1  4   4   4  2  2  3  8  2  7
    4  6  10   9  4  3  8  9  7  8
    5  5   6  10  1  4  4  4  3  3
]

# number of nodes
nnodes = size(nodes, 2)

# number of elements
nelems = size(elements, 2)

# unstructured paraview output
points = vcat(nodes, zeros(nnodes)') # adds third row with zero z-coordinate
cells = [MeshCell(VTKCellTypes.VTK_LAGRANGE_TRIANGLE, elements[:, k]) for k in 1:nelems ]
vtk_grid(joinpath("results", "unstructured_triangular_mesh"), points, cells) do vtk
    vtk["coordinates", VTKPointData()] = points
    vtk["element_indices", VTKCellData()] = 1:nelems
end

