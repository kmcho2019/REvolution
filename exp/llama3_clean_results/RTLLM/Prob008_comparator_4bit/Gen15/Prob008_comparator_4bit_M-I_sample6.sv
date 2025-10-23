module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Direct comparison for optimization
    assign A_equal = (A == 4'b0 && B == 4'b0) || (A == B);
    assign A_greater = (A > B);
    assign A_less = (A < B);

endmodule