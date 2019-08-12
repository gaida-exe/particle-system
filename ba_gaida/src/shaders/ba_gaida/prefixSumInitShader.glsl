#version 450
/*
 * 1.2.1 ComputeShader
 * Calc PreFixSum of Grid
 */
layout(local_size_x = 10, local_size_y = 1, local_size_z = 1) in;

struct Grid{
    uint gridID;
    uint particlesInGrid;
    uint previousSortOutPut;
    uint currentSortOutPut;
};

layout(std430, binding = 2) coherent buffer buffer_grid
{
    Grid grid[];
};

layout(std430, binding = 3) writeonly buffer buffer_gridBuffer
{
    uint gridBuffer[];
};

uniform float deltaTime;
uniform uint step;
uniform ivec4 gridSize;

//int cubeid;
const uint maxCubes = (gridSize.x * gridSize.y * gridSize.z);

void main(void) {

    uint id = gl_GlobalInvocationID.x;
    const int threadID = int (id);
    if (threadID >= maxCubes)
    {
        return;
    } else {
        grid[threadID].currentSortOutPut = grid[threadID-1].particlesInGrid;
        gridBuffer[threadID] = grid[threadID-1].particlesInGrid;
    }
}