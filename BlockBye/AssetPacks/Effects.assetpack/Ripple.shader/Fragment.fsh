//
// Ripple fragment shader
//

//This represents the current texture on the mesh
uniform lowp sampler2D texture;

//The interpolated vertex color for this fragment
varying lowp vec4 vColor;

//The interpolated texture coordinate for this fragment
varying highp vec2 vTexCoord;

uniform highp float time;
uniform highp float freq;

void main()
{
    highp vec2 tc = vTexCoord.xy;
    highp vec2 p = -1.0 + 2.0 * tc;
    highp float len = length(p);
    highp vec2 uv = tc + (p/len)*freq*cos(len*24.0-time*4.0)*0.03;
    highp vec4 col = texture2D(texture,uv);
    
    gl_FragColor = vec4(col.rgb * vColor.rgb, col.a);
}
