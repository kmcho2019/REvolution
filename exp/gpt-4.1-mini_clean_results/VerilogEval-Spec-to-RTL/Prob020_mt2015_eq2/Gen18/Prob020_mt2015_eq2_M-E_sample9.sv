module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Perform bitwise XNOR on each bit and AND the results to detect equality
wire bit0_equal = ~(A[0] ^ B[0]);
wire bit1_equal = ~(A[1] ^ B[1]);

assign z = bit0_equal & bit1_equal;

endmodule