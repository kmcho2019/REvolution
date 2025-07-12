module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for borrow and result
wire [3:0] result;
wire borrow;

// Perform subtraction A - B
assign {borrow, result} = A - B;

// Determine A_greater
assign A_greater = (~borrow) & (~(|result)); // No borrow and non-zero result

// Determine A_equal
assign A_equal = ~(|result); // Result is zero

// Determine A_less
assign A_less = borrow; // Borrow occurred during subtraction

endmodule