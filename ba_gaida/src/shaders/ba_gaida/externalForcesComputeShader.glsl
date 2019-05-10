#version 450
/*
 * 1.1 ComputeShader
 * Calculates the Gravity
 */
layout( local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

struct Particle{
    vec4 position;
    vec4 velocity;
    uint gridID;
    int pad1,pad2,pad3;
};

layout( std430, binding = 0) readonly buffer buffer_particle1
{
    Particle particle1[];
};

layout( std430, binding = 1) writeonly buffer buffer_particle2
{
    Particle particle2[];
};

uniform float deltaTime;
uniform uint particleCount;
uniform uint gridSize;

#define gravity  (-9.81/10)

void main(void) {
    uint id = gl_GlobalInvocationID.x;
    if(id >= particleCount)
    {
        return;
    } else
    {
        particle2[id].position = particle1[id].position;
        particle2[id].velocity.y = particle1[id].velocity.y +  gravity * deltaTime;
    }
}
