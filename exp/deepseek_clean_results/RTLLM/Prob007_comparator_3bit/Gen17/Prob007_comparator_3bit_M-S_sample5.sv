module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire gt2 = A[2] & ~B[2];
wire eq2 = A[2] ~^ B[2];
wire lt2 = ~A[2] & B[2];

wire gt1 = A[1] & ~B[1];
wire eq1 = A[1] ~^ B[1];
wire lt1 = ~A[1] & B[1];

wire gt0 = A[0] & ~B[0];
wire eq0 = A[0] ~^ B[0];
wire lt0 = ~A[0] & B[0];

assign A_greater = gt2 | (eq2 & gt1) | (eq2 & eq1 & gt0);
assign A_equal = eq2 & eq1 & eq0;
assign A_less = lt2 | (eq2 & lt1) | (eq2 & eq1 & lt0);

endmodule