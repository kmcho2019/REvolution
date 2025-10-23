module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

// Precompute all possible shifted versions
wire [7:0] shifted [0:7];
assign shifted[0] = in;                            // no shift
assign shifted[1] = {in[0], in[7:1]};              // right shift by 1
assign shifted[2] = {in[1:0], in[7:2]};            // right shift by 2
assign shifted[3] = {in[2:0], in[7:3]};            // right shift by 3
assign shifted[4] = {in[3:0], in[7:4]};            // right shift by 4
assign shifted[5] = {in[4:0], in[7:5]};            // right shift by 5
assign shifted[6] = {in[5:0], in[7:6]};            // right shift by 6
assign shifted[7] = {in[6:0], in[7]};              // right shift by 7

// Select the appropriate shifted version based on control
assign out = shifted[ctrl];

endmodule