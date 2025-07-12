module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    assign A_equal = (A == B);
    assign A_greater = (A!= B) & (A > B);
    assign A_less = (A!= B) & (A < B);

endmodule