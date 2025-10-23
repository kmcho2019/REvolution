module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compute bitwise XOR for equality detection
    wire [2:0] xor_AB = A ^ B;
    wire equal = ~(xor_AB[0] | xor_AB[1] | xor_AB[2]); // all bits equal if none differ

    // Subtract B from A as unsigned 3-bit values and interpret as signed for comparison
    wire [3:0] diff_ext = {1'b0, A} - {1'b0, B}; // Extend to 4 bits to avoid overflow

    // If difference is zero -> equal
    assign A_equal = equal;

    // The difference sign bit (MSB of the 4-bit diff_ext) is 1 if A < B (unsigned borrow)
    // But since both are unsigned 3-bit, diff_ext[3] = borrow out
    // borrow out = 1 means A < B
    // borrow out = 0 and difference != 0 means A > B
    wire borrow = diff_ext[3];
    wire diff_not_zero = |diff_ext[2:0];

    assign A_less = borrow;
    assign A_greater = (~borrow) & diff_not_zero;

endmodule