module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B and generate borrow signal
wire [3:0] result;
wire borrow;

assign result = A - B;
assign borrow = (B > A)? 1'b1 : 1'b0;

// Generate output signals
assign A_greater = (~borrow) & (result!= 4'b0000);
assign A_equal = (~borrow) & (result == 4'b0000);
assign A_less = borrow;

endmodule