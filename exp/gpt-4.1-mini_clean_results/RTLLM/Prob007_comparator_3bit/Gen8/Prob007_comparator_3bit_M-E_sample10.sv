module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // 1-bit comparator outputs for each bit position
    wire gt2, eq2, lt2;
    wire gt1, eq1, lt1;
    wire gt0, eq0, lt0;

    // Compare bit 2 (MSB)
    assign gt2 = (A[2] & ~B[2]);
    assign lt2 = (~A[2] & B[2]);
    assign eq2 = ~(gt2 | lt2);

    // Compare bit 1 if bit 2 equal
    assign gt1 = eq2 & (A[1] & ~B[1]);
    assign lt1 = eq2 & (~A[1] & B[1]);
    assign eq1 = eq2 & ~(gt1 | lt1);

    // Compare bit 0 if bit 2 and bit 1 equal
    assign gt0 = eq1 & (A[0] & ~B[0]);
    assign lt0 = eq1 & (~A[0] & B[0]);
    assign eq0 = eq1 & ~(gt0 | lt0);

    // Final outputs
    assign A_greater = gt2 | gt1 | gt0;
    assign A_less    = lt2 | lt1 | lt0;
    assign A_equal   = eq0;

endmodule