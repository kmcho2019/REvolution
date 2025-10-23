module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct output assignments without intermediate wires
    assign A_equal = (A == B);
    assign A_less = (A < B);
    assign A_greater = (A > B);  // Direct comparison instead of ~borrow & ~equal

endmodule