module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B
wire [3:0] result;
wire borrow;

// Calculate result and borrow
assign {borrow, result} = A - B;

// Determine outputs based on result and borrow
assign A_greater = ~borrow & (|result);  // A > B if no borrow and result is non-zero
assign A_equal = ~borrow & ~(|result);  // A == B if no borrow and result is zero
assign A_less = borrow;  // A < B if borrow occurs

endmodule