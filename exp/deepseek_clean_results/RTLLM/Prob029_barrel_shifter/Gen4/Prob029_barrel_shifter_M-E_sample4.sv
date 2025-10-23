module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

// Level 0: Shift by 4 (controlled by ctrl[2])
wire [7:0] level0_out;
assign level0_out = ctrl[2] ? {in[3:0], in[7:4]} : in;

// Level 1: Shift by 2 (controlled by ctrl[1])
wire [7:0] level1_out;
assign level1_out = ctrl[1] ? {level0_out[1:0], level0_out[7:2]} : level0_out;

// Level 2: Shift by 1 (controlled by ctrl[0])
assign out = ctrl[0] ? {level1_out[0], level1_out[7:1]} : level1_out;

endmodule