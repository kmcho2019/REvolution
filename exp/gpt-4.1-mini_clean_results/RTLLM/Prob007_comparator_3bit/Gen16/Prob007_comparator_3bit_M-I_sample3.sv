module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise equality signals using equality operator for clarity and synthesis efficiency
    wire eq_bit2 = (A[2] == B[2]);
    wire eq_bit1 = (A[1] == B[1]);
    wire eq_bit0 = (A[0] == B[0]);

    // Overall equality signal as AND of all bitwise equalities
    assign A_equal = eq_bit2 & eq_bit1 & eq_bit0;

    // Greater-than logic with merged equality signals to minimize wires and gates
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & A[1] & ~B[1]) |
                       (eq_bit2 & eq_bit1 & A[0] & ~B[0]);

    // Less-than as mutual exclusivity of greater and equal outputs
    assign A_less = ~A_greater & ~A_equal;

endmodule