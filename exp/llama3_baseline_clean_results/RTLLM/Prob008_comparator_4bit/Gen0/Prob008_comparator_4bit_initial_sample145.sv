module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] result;
wire borrow;

// Perform subtraction operation: A - B
assign result = A - B;
assign borrow = (A < B)? 1'b1 : 1'b0;

// Determine the relationship between A and B
assign A_greater = (~borrow && result!= 4'b0000)? 1'b1 : 1'b0;
assign A_equal = (result == 4'b0000 && ~borrow)? 1'b1 : 1'b0;
assign A_less = borrow? 1'b1 : 1'b0;

endmodule