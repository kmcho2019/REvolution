module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire equal = (A == B);
wire greater = (A > B) & ~equal;

assign A_equal = equal;
assign A_greater = greater;
assign A_less = ~equal & ~greater;

endmodule