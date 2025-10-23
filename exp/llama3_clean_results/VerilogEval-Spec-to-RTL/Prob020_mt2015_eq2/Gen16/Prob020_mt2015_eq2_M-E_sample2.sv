module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Compare each bit of A with the corresponding bit of B
wire bit1_match = (A[1] == B[1]);
wire bit0_match = (A[0] == B[0]);

// Use an AND gate to ensure all bits must match
assign z = bit1_match & bit0_match;

endmodule