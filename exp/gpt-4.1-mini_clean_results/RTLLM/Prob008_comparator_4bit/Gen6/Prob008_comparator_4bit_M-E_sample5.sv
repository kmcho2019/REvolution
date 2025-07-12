module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise comparisons
    wire gt3 = A[3] & ~B[3];
    wire lt3 = ~A[3] & B[3];
    wire eq3 = ~(A[3] ^ B[3]);

    wire gt2 = A[2] & ~B[2];
    wire lt2 = ~A[2] & B[2];
    wire eq2 = ~(A[2] ^ B[2]);

    wire gt1 = A[1] & ~B[1];
    wire lt1 = ~A[1] & B[1];
    wire eq1 = ~(A[1] ^ B[1]);

    wire gt0 = A[0] & ~B[0];
    wire lt0 = ~A[0] & B[0];
    wire eq0 = ~(A[0] ^ B[0]);

    // Priority chain for greater than
    wire greater = gt3 | (eq3 & gt2) | (eq3 & eq2 & gt1) | (eq3 & eq2 & eq1 & gt0);

    // Priority chain for less than
    wire less = lt3 | (eq3 & lt2) | (eq3 & eq2 & lt1) | (eq3 & eq2 & eq1 & lt0);

    // Equal if all bits equal
    wire equal = eq3 & eq2 & eq1 & eq0;

    assign A_greater = greater;
    assign A_less    = less;
    assign A_equal   = equal;

endmodule