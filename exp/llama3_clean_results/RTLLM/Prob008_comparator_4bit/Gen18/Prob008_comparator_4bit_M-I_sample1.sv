module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output wire A_greater,
    output wire A_equal,
    output wire A_less
);

    assign A_equal = (A == B);
    assign A_greater = (A > B);
    assign A_less = (A < B);

endmodule