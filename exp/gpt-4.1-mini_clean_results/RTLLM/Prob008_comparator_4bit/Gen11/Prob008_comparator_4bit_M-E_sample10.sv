module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // At each bit, compare A[i] and B[i].
    // Define intermediate signals indicating if decision was made at or above this bit.
    // We process from MSB (3) down to LSB (0).

    // Compare bit 3
    wire gt3 = A[3] & ~B[3];
    wire lt3 = ~A[3] & B[3];
    wire eq3 = ~(gt3 | lt3);

    // Compare bit 2, only if bits above are equal
    wire gt2 = A[2] & ~B[2];
    wire lt2 = ~A[2] & B[2];
    wire eq2 = ~(gt2 | lt2);

    // Compare bit 1, only if bits above are equal
    wire gt1 = A[1] & ~B[1];
    wire lt1 = ~A[1] & B[1];
    wire eq1 = ~(gt1 | lt1);

    // Compare bit 0, only if bits above are equal
    wire gt0 = A[0] & ~B[0];
    wire lt0 = ~A[0] & B[0];
    wire eq0 = ~(gt0 | lt0);

    // Cascade the comparison:
    // If bit 3 differs, output based on bit 3
    // else if bit 2 differs, output based on bit 2
    // else if bit 1 differs, output based on bit 1
    // else if bit 0 differs, output based on bit 0
    // else equal

    assign A_greater = gt3 ? 1'b1 :
                       eq3 ? (gt2 ? 1'b1 :
                              eq2 ? (gt1 ? 1'b1 :
                                     eq1 ? (gt0 ? 1'b1 : 1'b0)
                                          : 1'b0)
                                   : 1'b0)
                           : 1'b0;

    assign A_less    = lt3 ? 1'b1 :
                       eq3 ? (lt2 ? 1'b1 :
                              eq2 ? (lt1 ? 1'b1 :
                                     eq1 ? (lt0 ? 1'b1 : 1'b0)
                                          : 1'b0)
                                   : 1'b0)
                           : 1'b0;

    assign A_equal   = eq3 & eq2 & eq1 & eq0;

endmodule