module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B and generate borrow
wire [3:0] result;
wire borrow;

assign {borrow, result} = A - B;

// Determine if A is less than B (borrow occurred)
assign A_less = borrow;

// Determine if A is equal to B (result of subtraction is zero)
assign A_equal = ~|result;  // ~|result checks if all bits are zero

// Determine if A is greater than B (no borrow and result is non-zero)
assign A_greater = ~borrow & ~A_equal;

endmodule