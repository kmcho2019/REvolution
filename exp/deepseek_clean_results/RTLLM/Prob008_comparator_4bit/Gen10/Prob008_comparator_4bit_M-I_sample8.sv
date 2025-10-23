module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Combined equality and magnitude comparison
    wire equal = (A == B);
    wire greater = (A > B);

    // Output assignments (mutually exclusive by construction)
    assign A_equal = equal;
    assign A_greater = greater & ~equal;
    assign A_less = ~greater & ~equal;

endmodule