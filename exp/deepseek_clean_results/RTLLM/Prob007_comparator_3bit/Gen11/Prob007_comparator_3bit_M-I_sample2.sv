module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bitwise equality check
wire eq2 = ~(A[2] ^ B[2]);
wire eq1 = ~(A[1] ^ B[1]);
wire eq0 = ~(A[0] ^ B[0]);

// Full equality
assign A_equal = eq2 & eq1 & eq0;

// Magnitude comparison (MSB first)
wire gt2 = A[2] & ~B[2];
wire lt2 = ~A[2] & B[2];
wire eq_gt1 = eq2 & A[1] & ~B[1];
wire eq_lt1 = eq2 & ~A[1] & B[1];
wire eq_eq_gt0 = eq2 & eq1 & A[0] & ~B[0];
wire eq_eq_lt0 = eq2 & eq1 & ~A[0] & B[0];

assign A_greater = gt2 | eq_gt1 | eq_eq_gt0;
assign A_less = lt2 | eq_lt1 | eq_eq_lt0;

endmodule