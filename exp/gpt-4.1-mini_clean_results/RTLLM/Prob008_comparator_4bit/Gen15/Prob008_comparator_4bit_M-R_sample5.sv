module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Generate equality signals for each bit
    wire eq3 = (A[3] == B[3]);
    wire eq2 = (A[2] == B[2]);
    wire eq1 = (A[1] == B[1]);
    wire eq0 = (A[0] == B[0]);

    // Generate greater signals for each bit
    wire gt3 = (A[3] & ~B[3]);
    wire gt2 = (A[2] & ~B[2]);
    wire gt1 = (A[1] & ~B[1]);
    wire gt0 = (A[0] & ~B[0]);

    // Overall equality: all bits equal
    assign A_equal = eq3 & eq2 & eq1 & eq0;

    // A greater than B: highest priority bit where A > B and all higher bits equal
    assign A_greater = gt3 |
                       (eq3 & gt2) |
                       (eq3 & eq2 & gt1) |
                       (eq3 & eq2 & eq1 & gt0);

    // A less than B: if not equal and not greater
    assign A_less = ~A_equal & ~A_greater;

endmodule