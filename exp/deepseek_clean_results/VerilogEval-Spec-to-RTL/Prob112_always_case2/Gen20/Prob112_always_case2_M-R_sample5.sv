module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Generate mask as before
wire [3:0] mask;
assign mask[0] = 1'b1;
assign mask[1] = ~in[0];
assign mask[2] = ~in[0] & ~in[1];
assign mask[3] = ~in[0] & ~in[1] & ~in[2];

// Find first '1' position
wire [3:0] first_one = in & mask;

// Directly compute output bits
assign pos[1] = first_one[2] | first_one[3];
assign pos[0] = first_one[1] | first_one[3];

endmodule