module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire [3:0] rightmost_one = in & ((~in) + 1);

assign pos[1] = rightmost_one[3] | rightmost_one[2];
assign pos[0] = rightmost_one[3] | rightmost_one[1];

endmodule