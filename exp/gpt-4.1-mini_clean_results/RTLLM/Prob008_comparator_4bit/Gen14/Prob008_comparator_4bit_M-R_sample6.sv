module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate equality signals per bit
    wire eq3 = (A[3] == B[3]);
    wire eq2 = (A[2] == B[2]);
    wire eq1 = (A[1] == B[1]);
    wire eq0 = (A[0] == B[0]);

    // Equality overall: all bits equal
    assign A_equal = eq3 & eq2 & eq1 & eq0;

    // Greater than detection cascading from MSB downwards
    assign A_greater = (A[3] & ~B[3]) |
                       (eq3 & A[2] & ~B[2]) |
                       (eq3 & eq2 & A[1] & ~B[1]) |
                       (eq3 & eq2 & eq1 & A[0] & ~B[0]);

    // Less than detection: neither equal nor greater
    assign A_less = ~A_equal & ~A_greater;

endmodule