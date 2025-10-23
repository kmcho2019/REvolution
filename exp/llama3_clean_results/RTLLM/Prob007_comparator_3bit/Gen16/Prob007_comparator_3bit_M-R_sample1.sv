module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

assign A_greater = (A > B)? 1'b1 : 1'b0;
assign A_equal = (A == B)? 1'b1 : 1'b0;
assign A_less = (A < B)? 1'b1 : 1'b0;

endmodule