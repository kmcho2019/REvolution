module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire diff0, diff1, any_diff;

assign diff0 = A[0] ^ B[0];
assign diff1 = A[1] ^ B[1];
assign any_diff = diff0 | diff1;

assign z = ~any_diff;

endmodule