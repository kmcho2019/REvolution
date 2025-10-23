module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Equality check using XOR reduction and NOT
    assign A_equal = ~( |(A ^ B) );

    // Use built-in relational operator for greater-than
    assign A_greater = (A > B);

    // Less-than derived by exclusion for mutual exclusivity
    assign A_less = ~A_equal & ~A_greater;

endmodule