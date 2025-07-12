module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct equality check
    assign A_equal = (A == B);

    // Priority-encoded greater check
    assign A_greater = (A > B);

    // Derived less than (mutually exclusive)
    assign A_less = !A_equal && !A_greater;

endmodule