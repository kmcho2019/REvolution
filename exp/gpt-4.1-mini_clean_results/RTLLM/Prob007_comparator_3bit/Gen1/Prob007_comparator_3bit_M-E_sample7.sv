module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire gt2, eq2, lt2;
    wire gt1, eq1, lt1;
    wire gt0, eq0, lt0;

    // Compare bit 2 (MSB)
    assign gt2 = (A[2] & ~B[2]);
    assign lt2 = (~A[2] & B[2]);
    assign eq2 = (A[2] == B[2]);

    // Compare bit 1
    assign gt1 = (A[1] & ~B[1]);
    assign lt1 = (~A[1] & B[1]);
    assign eq1 = (A[1] == B[1]);

    // Compare bit 0 (LSB)
    assign gt0 = (A[0] & ~B[0]);
    assign lt0 = (~A[0] & B[0]);
    assign eq0 = (A[0] == B[0]);

    assign A_greater = gt2 | (eq2 & gt1) | (eq2 & eq1 & gt0);
    assign A_less    = lt2 | (eq2 & lt1) | (eq2 & eq1 & lt0);
    assign A_equal   = eq2 & eq1 & eq0;

endmodule