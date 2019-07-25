#version 450
/*
 * 0.1 ComputeShader
 * reset Grid
 */
layout(local_size_x = 100, local_size_y = 1, local_size_z = 1) in;

struct Grid{
    uint id;
    uint particlesInGrid;
    uint particleToUse;
    uint currentSortOutPut;
    uint particles [16];
};

layout(std430, binding = 2) coherent buffer buffer_grid
{
    Grid grid[];
};

uniform float deltaTime;
uniform uint particleCount;
uniform ivec4 gridSize;

uint maxCubes = (gridSize.x * gridSize.y * gridSize.z);

void main(void) {
    uint id = gl_GlobalInvocationID.x;
    if (id >= maxCubes)
    {
        return;
    } else
    {
        grid[id].particlesInGrid = 0;
        grid[id].currentSortOutPut = 0;
        grid[id].particleToUse = 0;

        for(int i = 0; i <= 15; i++){
            grid[id].particles[i] = 0;
        }
    }
}