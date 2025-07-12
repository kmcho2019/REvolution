module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Bitwise equality signals using XNOR for clarity and minimal gates
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit0 = ~(A[0] ^ B[0]);

    // Combined equality of upper two bits to reduce redundancy
    wire eq_21 = eq_bit2 & eq_bit1;

    // Overall equality: all bits equal
    assign A_equal = eq_21 & eq_bit0;

    // Greater-than logic using hierarchical structure and combined equality signals
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_21    & (A[0] & ~B[0]));

    // Less-than by mutual exclusivity (only one output is high)
    assign A_less = ~A_equal & ~A_greater;

endmodule