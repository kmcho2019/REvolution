module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [3:0] borrow;

    // Bit 0 subtraction and borrow (borrow_in = 0)
    assign diff[0]   = A[0] ^ B[0];
    assign borrow[0] = (~A[0] & B[0]);

    // Bit 1 subtraction and borrow
    assign diff[1] = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow[0]);

    // Bit 2 subtraction and borrow
    assign diff[2] = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = (~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow[1]);

    // Bit 3 subtraction and borrow
    assign diff[3] = A[3] ^ B[3] ^ borrow[2];
    assign borrow[3] = (~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow[2]);

    // Equality: check if all diff bits are zero (A == B)
    wire all_zero_diff = ~|diff;

    // Outputs (mutually exclusive)
    assign A_less    = borrow[3];
    assign A_equal   = ~borrow[3] & all_zero_diff;
    assign A_greater = ~borrow[3] & ~all_zero_diff;

endmodule