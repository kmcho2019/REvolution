module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] borrow;

    // Initial borrow-in is 0
    assign borrow[0] = 1'b0;

    // Bit 0 subtraction
    assign borrow[1] = (~A[0] & B[0]) | ((~(A[0] ^ B[0])) & borrow[0]);

    // Bit 1 subtraction
    assign borrow[2] = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow[1]);

    // Bit 2 subtraction
    assign borrow[3] = (~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow[2]);

    // Bit 3 subtraction
    assign borrow[4] = (~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow[3]);

    // Equality check: if any bit of (A^B) is 1, then A != B
    wire any_bit_diff = |(A ^ B);
    wire equal_bits = ~any_bit_diff;

    // Outputs: mutually exclusive
    assign A_less    = borrow[4];
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow[4] | equal_bits);

endmodule