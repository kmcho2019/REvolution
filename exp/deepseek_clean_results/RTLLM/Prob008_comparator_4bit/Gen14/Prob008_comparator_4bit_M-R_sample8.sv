module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct equality comparison
    assign A_equal = (A == B);

    // Direct greater/less comparison using arithmetic
    assign A_greater = (A > B) & ~A_equal;
    assign A_less = (A < B) & ~A_equal;

endmodule