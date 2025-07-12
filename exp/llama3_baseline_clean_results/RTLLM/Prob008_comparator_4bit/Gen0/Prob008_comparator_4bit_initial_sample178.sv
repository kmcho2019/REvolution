module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction by adding the two's complement of B to A
// Calculate two's complement of B
wire [3:0] B_complement;
assign B_complement = ~B + 1'b1;

// Add A and the two's complement of B
wire [3:0] result;
wire carry_out;
assign {carry_out, result} = A + B_complement;

// Generate outputs based on carry-out and result
assign A_greater = ~carry_out & (|result);
assign A_equal = ~(|result);
assign A_less = carry_out;

endmodule