module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire equal;
assign equal = (A == B);

assign A_equal = equal;
assign A_greater = ~equal & (A > B);
assign A_less = ~equal & (A < B);

endmodule