#version 450
/*
 * 1.1 ComputeShader
 * Lable Particle
 */
layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

struct Particle{
    vec4 position;
    vec4 velocity;
    vec4 startPosition;
    vec4 normal;
    vec4 vorticity;
    float temperature;
    uint memoryPosition;
    float density;
    float pressure;
};

struct Grid{
    int id;
    int particlesInGrid;
    int previousSortOutPut;
    int currentSortOutPut;
};

layout(std430, binding = 0) readonly buffer buffer_inParticle
{
    Particle inParticle[];
};

layout(std430, binding = 1) writeonly buffer buffer_outParticle
{
    Particle outParticle[];
};

layout(std430, binding = 2) coherent buffer buffer_grid
{
    Grid grid[];
};

uniform float deltaTime;
uniform uint particleCount;
uniform ivec4 gridSize;

uint cubeID(vec4 position){
    return int(floor(position.x) * gridSize.x * gridSize.x + floor(position.y) * gridSize.y + floor(position.z));
}

void main(void) {
    uint id = gl_GlobalInvocationID.x;
    uint temp;
    if (id >= particleCount)
    {
        return;
    } else
    {
        outParticle[id] = inParticle[id];
        temp = cubeID(inParticle[id].position);
        outParticle[id].memoryPosition = atomicAdd(grid[temp].particlesInGrid, 1);
    }
}