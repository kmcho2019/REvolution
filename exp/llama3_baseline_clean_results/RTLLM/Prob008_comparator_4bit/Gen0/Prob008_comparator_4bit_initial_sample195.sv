module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction operation A - B
wire [3:0] result;
wire borrow;

assign {borrow, result} = A - B;

// Determine A_greater, A_equal, A_less based on result and borrow
assign A_greater = (~borrow) & (|result); // A_greater if no borrow and result is non-zero
assign A_equal = ~borrow & ~( |result);  // A_equal if no borrow and result is zero
assign A_less = borrow;                  // A_less if borrow occurs

endmodule