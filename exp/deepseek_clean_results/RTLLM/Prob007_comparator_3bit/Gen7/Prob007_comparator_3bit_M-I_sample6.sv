module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bit-wise equality check
wire eq2 = ~(A[2] ^ B[2]);
wire eq1 = ~(A[1] ^ B[1]);
wire eq0 = ~(A[0] ^ B[0]);

// Full equality when all bits equal
assign A_equal = eq2 & eq1 & eq0;

// Magnitude comparison (MSB first)
wire gt2 = A[2] & ~B[2];
wire gt1 = A[1] & ~B[1] & eq2;
wire gt0 = A[0] & ~B[0] & eq2 & eq1;

wire lt2 = ~A[2] & B[2];
wire lt1 = ~A[1] & B[1] & eq2;
wire lt0 = ~A[0] & B[0] & eq2 & eq1;

// Combine comparison results
assign A_greater = gt2 | gt1 | gt0;
assign A_less = lt2 | lt1 | lt0;

endmodule