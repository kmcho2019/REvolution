module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

wire gt2 = (A[2] & ~B[2]);
wire lt2 = (~A[2] & B[2]);

wire gt1 = (A[1] & ~B[1]);
wire lt1 = (~A[1] & B[1]);

wire gt0 = (A[0] & ~B[0]);
wire lt0 = (~A[0] & B[0]);

assign A_greater = gt2 | (~(gt2 | lt2) & gt1) | (~(gt2 | lt2) & ~(gt1 | lt1) & gt0);
assign A_less    = lt2 | (~(gt2 | lt2) & lt1) | (~(gt2 | lt2) & ~(gt1 | lt1) & lt0);
assign A_equal   = ~(A_greater | A_less);

endmodule