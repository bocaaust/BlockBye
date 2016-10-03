//
// Ripple vertex shader
//

//This is the current model * view * projection matrix
// Codea sets it automatically
uniform mat4 modelViewProjection;

//This is the current mesh vertex position, color and tex coord
// Set automatically
attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

//This is an output variable that will be passed to the fragment shader
varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

void main()
{
    gl_Position = modelViewProjection * position;
    
    //Pass values to our fragment shader
    vColor.rgb = color.rgb * color.a;
    vColor.a = color.a;
    vTexCoord = texCoord;
}
