module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Equality is true when vectors are identical
    assign A_equal   = (A == B);

    // A_greater is true when A > B
    assign A_greater = (A > B);

    // A_less is true when A < B
    assign A_less    = (A < B);

endmodule