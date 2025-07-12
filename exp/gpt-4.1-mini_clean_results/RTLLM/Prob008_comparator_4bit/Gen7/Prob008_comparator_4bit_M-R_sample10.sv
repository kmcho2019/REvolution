module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit equality signals
    wire eq3 = (A[3] == B[3]);
    wire eq2 = (A[2] == B[2]);
    wire eq1 = (A[1] == B[1]);
    wire eq0 = (A[0] == B[0]);

    // Overall equality: all bits equal
    wire eq = eq3 & eq2 & eq1 & eq0;

    // Per-bit greater signals
    wire gt3 = (A[3] & ~B[3]);
    wire gt2 = (eq3 & A[2] & ~B[2]);
    wire gt1 = (eq3 & eq2 & A[1] & ~B[1]);
    wire gt0 = (eq3 & eq2 & eq1 & A[0] & ~B[0]);
    wire a_gt_b = gt3 | gt2 | gt1 | gt0;

    // Per-bit less signals
    wire lt3 = (~A[3] & B[3]);
    wire lt2 = (eq3 & ~A[2] & B[2]);
    wire lt1 = (eq3 & eq2 & ~A[1] & B[1]);
    wire lt0 = (eq3 & eq2 & eq1 & ~A[0] & B[0]);
    wire a_lt_b = lt3 | lt2 | lt1 | lt0;

    // Assign outputs, mutually exclusive by construction
    assign A_equal   = eq;
    assign A_greater = a_gt_b;
    assign A_less    = a_lt_b;

endmodule