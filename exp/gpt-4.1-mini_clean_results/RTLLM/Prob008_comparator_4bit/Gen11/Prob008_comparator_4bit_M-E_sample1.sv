module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise comparison signals
    wire gt3 =  A[3] & ~B[3];
    wire lt3 = ~A[3] &  B[3];
    wire eq3 = ~(A[3] ^ B[3]);

    wire gt2 =  A[2] & ~B[2];
    wire lt2 = ~A[2] &  B[2];
    wire eq2 = ~(A[2] ^ B[2]);

    wire gt1 =  A[1] & ~B[1];
    wire lt1 = ~A[1] &  B[1];
    wire eq1 = ~(A[1] ^ B[1]);

    wire gt0 =  A[0] & ~B[0];
    wire lt0 = ~A[0] &  B[0];
    wire eq0 = ~(A[0] ^ B[0]);

    // A is greater if MSB bit shows greater or all higher bits equal and current bit greater, cascade down
    assign A_greater =
           gt3
        | (eq3 & gt2)
        | (eq3 & eq2 & gt1)
        | (eq3 & eq2 & eq1 & gt0);

    // Similarly for less than
    assign A_less =
           lt3
        | (eq3 & lt2)
        | (eq3 & eq2 & lt1)
        | (eq3 & eq2 & eq1 & lt0);

    // Equal if all bits are equal
    assign A_equal = eq3 & eq2 & eq1 & eq0;

endmodule