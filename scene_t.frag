#version 330 core

out vec4 fragColor;

in vec2 texCoord;

uniform sampler2D tex;

void main()
{
    fragColor = vec4(texture(tex, texCoord).xzy, 0.5);
}
