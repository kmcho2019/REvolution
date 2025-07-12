module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire bit0_diff, bit1_diff, any_diff;

assign bit0_diff = A[0] ^ B[0];
assign bit1_diff = A[1] ^ B[1];
assign any_diff  = bit0_diff | bit1_diff;
assign z         = ~any_diff;

endmodule