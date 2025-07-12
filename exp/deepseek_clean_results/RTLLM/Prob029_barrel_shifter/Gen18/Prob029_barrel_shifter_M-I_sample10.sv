module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Barrel shifter with left rotation (higher bits move to lower positions)
    // ctrl[2] = 1: rotate left by 4 bits
    // ctrl[1] = 1: rotate left by 2 bits
    // ctrl[0] = 1: rotate left by 1 bit
    // Shifts are applied in order: 4, then 2, then 1
    
    assign out = ctrl[0] ? {in[0], in[7:1]} : in;  // 1-bit shift
    assign out = ctrl[1] ? {out[1:0], out[7:2]} : out;  // 2-bit shift
    assign out = ctrl[2] ? {out[3:0], out[7:4]} : out;  // 4-bit shift
endmodule