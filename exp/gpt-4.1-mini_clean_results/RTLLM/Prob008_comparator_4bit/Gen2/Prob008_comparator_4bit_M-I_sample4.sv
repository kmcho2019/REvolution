module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit_equal [3:0];
    wire bit_A_greater [3:0];
    wire bit_B_greater [3:0];

    // Compare each bit
    assign bit_equal[3] = (A[3] == B[3]);
    assign bit_equal[2] = (A[2] == B[2]);
    assign bit_equal[1] = (A[1] == B[1]);
    assign bit_equal[0] = (A[0] == B[0]);

    assign bit_A_greater[3] = (A[3] & ~B[3]);
    assign bit_A_greater[2] = (A[2] & ~B[2]);
    assign bit_A_greater[1] = (A[1] & ~B[1]);
    assign bit_A_greater[0] = (A[0] & ~B[0]);

    assign bit_B_greater[3] = (~A[3] & B[3]);
    assign bit_B_greater[2] = (~A[2] & B[2]);
    assign bit_B_greater[1] = (~A[1] & B[1]);
    assign bit_B_greater[0] = (~A[0] & B[0]);

    // Hierarchical comparison from MSB to LSB

    wire gt3 = bit_A_greater[3];
    wire eq3 = bit_equal[3];
    wire lt3 = bit_B_greater[3];

    wire gt2 = bit_A_greater[2];
    wire eq2 = bit_equal[2];
    wire lt2 = bit_B_greater[2];

    wire gt1 = bit_A_greater[1];
    wire eq1 = bit_equal[1];
    wire lt1 = bit_B_greater[1];

    wire gt0 = bit_A_greater[0];
    wire eq0 = bit_equal[0];
    wire lt0 = bit_B_greater[0];

    assign A_greater = gt3
                    | (eq3 & gt2)
                    | (eq3 & eq2 & gt1)
                    | (eq3 & eq2 & eq1 & gt0);

    assign A_less = lt3
                 | (eq3 & lt2)
                 | (eq3 & eq2 & lt1)
                 | (eq3 & eq2 & eq1 & lt0);

    assign A_equal = eq3 & eq2 & eq1 & eq0;

endmodule