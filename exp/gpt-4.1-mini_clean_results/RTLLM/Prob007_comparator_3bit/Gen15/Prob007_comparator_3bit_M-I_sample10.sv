module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire eq_bit2, eq_bit1;
    wire eq_upper_bits;

    // Equality signals per bit
    assign eq_bit2 = (A[2] == B[2]);
    assign eq_bit1 = (A[1] == B[1]);
    assign eq_upper_bits = eq_bit2 & eq_bit1;

    // Equality check for all bits using built-in operator for synthesis efficiency
    assign A_equal = (A == B);

    // Greater-than logic using factored equality signals to reduce gate count
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & A[1] & ~B[1]) |
                       (eq_upper_bits & A[0] & ~B[0]);

    // Less than is mutually exclusive with greater and equal
    assign A_less = ~(A_greater | A_equal);

endmodule