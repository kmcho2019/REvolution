module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire eq_bits;

    // Equality check by bitwise XNOR and reduction
    assign eq_bits = &(~(A ^ B));

    // Outputs assignment using simple relational operators
    assign A_equal   = eq_bits;
    assign A_greater = (~eq_bits) & (A > B);
    assign A_less    = (~eq_bits) & (A < B);

endmodule