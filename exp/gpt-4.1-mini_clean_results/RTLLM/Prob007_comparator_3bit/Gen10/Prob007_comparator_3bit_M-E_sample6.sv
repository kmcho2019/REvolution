module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire gt2, eq2, lt2; // bit 2 comparison
    wire gt1, eq1, lt1; // bit 1 comparison
    wire gt0, eq0, lt0; // bit 0 comparison

    // Bitwise comparisons
    assign gt2 =  A[2] & ~B[2];
    assign lt2 = ~A[2] &  B[2];
    assign eq2 = ~(gt2 | lt2);

    assign gt1 =  A[1] & ~B[1];
    assign lt1 = ~A[1] &  B[1];
    assign eq1 = ~(gt1 | lt1);

    assign gt0 =  A[0] & ~B[0];
    assign lt0 = ~A[0] &  B[0];
    assign eq0 = ~(gt0 | lt0);

    // Combine comparisons from MSB down
    assign A_greater =  gt2 | (eq2 & gt1) | (eq2 & eq1 & gt0);
    assign A_less    =  lt2 | (eq2 & lt1) | (eq2 & eq1 & lt0);
    assign A_equal   =  eq2 & eq1 & eq0;

endmodule