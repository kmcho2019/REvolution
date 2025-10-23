module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

assign z = ~(A ^ B) & ~((A ^ B) >> 1);

// Alternatively, a more straightforward approach:
// assign z = ~(A[0] ^ B[0]) & ~(A[1] ^ B[1]);

// Or using the equality operator directly:
// assign z = (A == B);

endmodule