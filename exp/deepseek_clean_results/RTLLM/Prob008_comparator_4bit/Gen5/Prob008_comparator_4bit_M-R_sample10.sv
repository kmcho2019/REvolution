module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct equality comparison
    assign A_equal = (A == B);

    // Bitwise magnitude comparison
    wire [3:0] bit_greater = A & ~B;
    wire [3:0] bit_less = ~A & B;

    // Aggregate comparison results
    wire greater = |bit_greater;
    wire less = |bit_less;

    // Final outputs (mutually exclusive)
    assign A_greater = greater & ~less;
    assign A_less = less & ~greater;

endmodule