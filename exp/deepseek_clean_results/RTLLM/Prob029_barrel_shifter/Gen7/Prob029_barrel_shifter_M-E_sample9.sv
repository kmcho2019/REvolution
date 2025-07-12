module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,  // ctrl[0]=1: shift 1, ctrl[1]=1: shift 2, ctrl[2]=1: shift 4
    output [7:0] out
);

// Generate all possible shifted versions in parallel
wire [7:0] shift1 = {in[6:0], in[7]};    // Rotate left by 1
wire [7:0] shift2 = {in[5:0], in[7:6]};   // Rotate left by 2
wire [7:0] shift4 = {in[3:0], in[7:4]};   // Rotate left by 4

// First level: Select between original and shifted versions
wire [7:0] stage1 [0:3];
assign stage1[0] = in;                     // No shift
assign stage1[1] = ctrl[0] ? shift1 : in;  // Potential 1-bit shift
assign stage1[2] = ctrl[1] ? shift2 : in;  // Potential 2-bit shift
assign stage1[3] = ctrl[2] ? shift4 : in;  // Potential 4-bit shift

// Second level: Combine shifts (OR reduction of active shifts)
assign out = stage1[0] | stage1[1] | stage1[2] | stage1[3];

endmodule