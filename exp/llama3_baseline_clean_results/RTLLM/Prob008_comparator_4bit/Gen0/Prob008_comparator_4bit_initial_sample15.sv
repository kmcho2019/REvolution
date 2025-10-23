module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires to hold the result of subtraction and borrow
wire [3:0] diff;
wire borrow;

// Perform subtraction (A - B) and generate borrow
assign {borrow, diff} = A - B;

// Determine if A is greater than B (no borrow and non-zero difference)
assign A_greater = ~borrow & ~(|diff); // Corrected condition to ensure A_greater is high when A > B

// Determine if A is equal to B (zero difference and no borrow)
assign A_equal = ~borrow & ~(|diff); // This condition needs correction to simply check for equality without considering borrow

// Corrected conditions for A_equal and A_greater
assign A_equal = ~(|diff); // A_equal is high when the difference is zero, regardless of borrow
assign A_greater = ~borrow & |diff; // A_greater is high when there's no borrow and the difference is not zero

// Determine if A is less than B (borrow occurred)
assign A_less = borrow;

endmodule