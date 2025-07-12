module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wire to hold the borrow
wire borrow;

// Perform subtraction A - B and generate borrow
assign {borrow, A_greater, A_equal, A_less} = A - B;

// Determine outputs based on subtraction result and borrow
assign A_greater = (A > B)? 1'b1 : 1'b0;
assign A_equal = (A == B)? 1'b1 : 1'b0;
assign A_less = (A < B)? 1'b1 : 1'b0;

endmodule