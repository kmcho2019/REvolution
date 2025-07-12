module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for subtraction result and borrow
wire [3:0] result;
wire borrow;

// Perform subtraction: A - B
assign {borrow, result} = A - B;

// Determine if A is greater than B
assign A_greater = ~borrow & ~(|result); // result is non-zero and no borrow

// Determine if A is equal to B
assign A_equal = ~borrow & ~(|result) == 1'b0 & |result == 1'b0; // result is zero and no borrow
assign A_equal = ~(A_greater | A_less); // Mutual exclusion

// Determine if A is less than B
assign A_less = borrow; // Borrow occurs, A is less than B

endmodule