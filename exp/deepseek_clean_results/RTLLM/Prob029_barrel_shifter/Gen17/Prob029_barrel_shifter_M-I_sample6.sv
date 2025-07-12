module barrel_shifter(
    input [7:0] in,        // 8-bit input
    input [2:0] ctrl,      // Control: [2]=4-bit, [1]=2-bit, [0]=1-bit
    output [7:0] out       // Rotated output (left rotation)
);

    // Single assign statement with cascaded shifts for better PPA
    assign out = ctrl[0] ? {in[0], in[7:1]} :         // 1-bit left rotate
                 ctrl[1] ? {in[1:0], in[7:2]} :       // 2-bit left rotate
                 ctrl[2] ? {in[3:0], in[7:4]} : in;    // 4-bit left rotate or pass-through

endmodule