module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Use built-in relational operators directly
    assign A_equal   = (A == B);
    assign A_greater = (A > B);
    assign A_less    = (A < B);

endmodule