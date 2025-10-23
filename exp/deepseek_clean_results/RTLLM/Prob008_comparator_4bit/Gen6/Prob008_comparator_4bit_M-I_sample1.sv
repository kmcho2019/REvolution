module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Compute equality first (least significant in critical path)
wire eq3 = (A[3] == B[3]);
wire eq2 = (A[2] == B[2]);
wire eq1 = (A[1] == B[1]);
wire eq0 = (A[0] == B[0]);
assign A_equal = eq3 & eq2 & eq1 & eq0;

// Hierarchical comparison (MSB first)
wire gt3 = (A[3] & ~B[3]);
wire lt3 = (~A[3] & B[3]);
wire eq_high = eq3 & eq2;
wire gt2 = eq3 & (A[2] & ~B[2]);
wire lt2 = eq3 & (~A[2] & B[2]);
wire eq_mid = eq_high & eq1;
wire gt1 = eq_high & (A[1] & ~B[1]);
wire lt1 = eq_high & (~A[1] & B[1]);
wire gt0 = eq_mid & (A[0] & ~B[0]);
wire lt0 = eq_mid & (~A[0] & B[0]);

// Final outputs
assign A_greater = gt3 | gt2 | gt1 | gt0;
assign A_less = lt3 | lt2 | lt1 | lt0;

endmodule