module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Per-bit equality signals using XNOR for explicit bitwise equality
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit0 = ~(A[0] ^ B[0]);

    // Overall equality: all bits equal
    assign A_equal = eq_bit2 & eq_bit1 & eq_bit0;

    // Hierarchical greater-than logic using per-bit equality signals for clarity and efficiency
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_bit2 & eq_bit1 & (A[0] & ~B[0]));

    // Less-than is the remainder to keep outputs mutually exclusive
    assign A_less = ~A_equal & ~A_greater;

endmodule