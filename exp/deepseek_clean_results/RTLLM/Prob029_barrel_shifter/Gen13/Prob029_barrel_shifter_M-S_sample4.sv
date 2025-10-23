module barrel_shifter(
    input [7:0] in,        // 8-bit input
    input [2:0] ctrl,      // Control: [2]=4-bit, [1]=2-bit, [0]=1-bit
    output [7:0] out       // Rotated output
);

    // Direct cascaded rotation in one assignment
    assign out = ctrl[0] ? {in[0], in[7:1]} :               // 1-bit right
                ctrl[1] ? {in[1:0], in[7:2]} :             // 2-bit right
                ctrl[2] ? {in[3:0], in[7:4]} : in;         // 4-bit right or no shift

endmodule