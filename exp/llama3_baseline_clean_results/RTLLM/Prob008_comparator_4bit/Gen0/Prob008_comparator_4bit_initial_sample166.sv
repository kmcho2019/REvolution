module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

// Perform subtraction and capture the borrow (assuming A - B)
wire [3:0] diff;
wire borrow;

// Since Verilog doesn't directly support subtraction with borrow,
// we use a workaround by performing the subtraction manually bit by bit
// or by using a simple comparison logic without explicit subtraction.

// Manual comparison without explicit subtraction (more straightforward in Verilog)
assign A_greater = (A > B);
assign A_equal   = (A == B);
assign A_less    = (A < B);

// Alternatively, if you want to simulate the borrow and subtraction manually:
//assign {borrow, diff} = A - B; // This won't work directly due to Verilog's limitations
// Instead, use the above direct comparisons or implement bit-by-bit subtraction

endmodule