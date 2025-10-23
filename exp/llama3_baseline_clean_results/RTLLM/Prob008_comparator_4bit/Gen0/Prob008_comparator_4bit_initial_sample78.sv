module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wire to hold the borrow signal
wire borrow;

// Perform subtraction A - B and generate borrow signal
assign {borrow, A_less} = ~A + B + 1;

// If no borrow occurs and the result of subtraction is non-zero, A is greater than B
assign A_greater = ~(A == B) && ~borrow;

// If A and B are equal, the result of subtraction is zero
assign A_equal = (A == B);

endmodule