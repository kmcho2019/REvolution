module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Single assignment with cascaded right rotations
    assign out = ctrl[0] ? {in[0], in[7:1]} :  // Rotate right by 1
                ctrl[1] ? {in[1:0], in[7:2]} : // Rotate right by 2
                ctrl[2] ? {in[3:0], in[7:4]} : // Rotate right by 4
                in;                             // No rotation
endmodule