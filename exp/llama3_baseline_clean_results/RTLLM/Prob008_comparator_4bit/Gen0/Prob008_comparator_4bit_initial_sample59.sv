module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] result;
wire borrow;

assign {borrow, result} = A - B;

assign A_greater = (borrow == 1'b0) && (result != 4'b0);
assign A_equal = (borrow == 1'b0) && (result == 4'b0);
assign A_less = borrow;

endmodule