module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Direct arithmetic comparison for greater-than to reduce logic depth
    assign A_greater = (A > B);

    // Equality detection remains simple and clear
    assign A_equal = (A == B);

    // Less-than derived by exclusion to ensure mutual exclusivity
    assign A_less = ~A_equal & ~A_greater;

endmodule