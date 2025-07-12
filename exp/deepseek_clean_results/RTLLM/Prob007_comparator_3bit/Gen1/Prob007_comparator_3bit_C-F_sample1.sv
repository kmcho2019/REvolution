module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct assignments ensure mutual exclusivity and minimal logic
    assign A_greater = (A > B);
    assign A_equal = (A == B);
    assign A_less = (A < B);

endmodule