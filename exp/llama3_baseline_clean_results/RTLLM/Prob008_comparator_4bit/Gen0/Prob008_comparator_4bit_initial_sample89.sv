module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

// Internal signals for borrow and result
wire [3:0] result;
wire       borrow;

// Perform subtraction (A - B) using a ripple borrow subtractor
assign {borrow, result[3:0]} = A - B;

// Set output flags based on the result and borrow
assign A_greater = ~borrow & ~(|result); // If no borrow and result is non-zero, A is greater than B
assign A_equal   = ~borrow &  (|result) == 1'b0; // If no borrow and result is zero, A is equal to B
assign A_less    = borrow; // If borrow occurs, A is less than B

endmodule