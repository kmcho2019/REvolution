module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Bitwise XNOR: 1 if bits are equal, 0 otherwise
wire bit0_equal = ~(A[0] ^ B[0]);
wire bit1_equal = ~(A[1] ^ B[1]);

// Output is 1 if both bits are equal
assign z = bit0_equal & bit1_equal;

endmodule