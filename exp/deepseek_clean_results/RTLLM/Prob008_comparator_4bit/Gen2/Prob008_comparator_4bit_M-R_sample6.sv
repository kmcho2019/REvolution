module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Intermediate comparison signals
wire equal = (A == B);
wire greater = (A > B);

// Output assignments - mutually exclusive
assign A_equal = equal;
assign A_greater = ~equal & greater;
assign A_less = ~equal & ~greater;

endmodule