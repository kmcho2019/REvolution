module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Compare from MSB to LSB
    wire gt3 = A[3] & ~B[3];
    wire lt3 = ~A[3] & B[3];
    wire eq3 = ~(gt3 | lt3);

    wire gt2 = A[2] & ~B[2] & eq3;
    wire lt2 = ~A[2] & B[2] & eq3;
    wire eq2 = eq3 & ~(A[2] ^ B[2]);

    wire gt1 = A[1] & ~B[1] & eq2;
    wire lt1 = ~A[1] & B[1] & eq2;
    wire eq1 = eq2 & ~(A[1] ^ B[1]);

    wire gt0 = A[0] & ~B[0] & eq1;
    wire lt0 = ~A[0] & B[0] & eq1;
    wire eq0 = eq1 & ~(A[0] ^ B[0]);

    assign A_greater = gt3 | gt2 | gt1 | gt0;
    assign A_less = lt3 | lt2 | lt1 | lt0;
    assign A_equal = eq0;

endmodule