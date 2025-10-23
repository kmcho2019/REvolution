module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Equality check (XNOR reduction)
    assign A_equal = (A == B);

    // Magnitude comparison (MSB-first priority)
    assign A_greater = (A > B);
    assign A_less = (A < B);

endmodule