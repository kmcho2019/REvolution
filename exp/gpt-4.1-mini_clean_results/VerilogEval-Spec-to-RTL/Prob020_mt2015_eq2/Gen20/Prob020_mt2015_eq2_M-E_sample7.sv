module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire bit0_equal;
wire bit1_equal;

// Bitwise XNOR to check each corresponding bit equality
assign bit0_equal = ~(A[0] ^ B[0]);
assign bit1_equal = ~(A[1] ^ B[1]);

// Output is high only if all bit pairs are equal
assign z = bit0_equal & bit1_equal;

endmodule