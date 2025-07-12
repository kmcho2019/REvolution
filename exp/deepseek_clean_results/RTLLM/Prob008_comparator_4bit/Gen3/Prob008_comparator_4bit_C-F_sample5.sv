module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire equal = (A == B);
    wire less = (A < B);

    assign A_equal = equal;
    assign A_less = less;
    assign A_greater = ~less & ~equal;

endmodule