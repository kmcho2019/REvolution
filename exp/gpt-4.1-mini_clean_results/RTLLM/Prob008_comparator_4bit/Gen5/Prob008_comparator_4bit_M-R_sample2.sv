module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    // Internal wires for borrow chain and difference bits
    wire [4:0] borrow;
    wire [3:0] diff;

    assign borrow[0] = 1'b0; // no initial borrow

    // Bit 0 subtraction and borrow
    assign diff[0]   = A[0] ^ B[0] ^ borrow[0];
    assign borrow[1] = (~A[0] & B[0]) | ((~(A[0] ^ B[0])) & borrow[0]);

    // Bit 1 subtraction and borrow
    assign diff[1]   = A[1] ^ B[1] ^ borrow[1];
    assign borrow[2] = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow[1]);

    // Bit 2 subtraction and borrow
    assign diff[2]   = A[2] ^ B[2] ^ borrow[2];
    assign borrow[3] = (~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow[2]);

    // Bit 3 subtraction and borrow
    assign diff[3]   = A[3] ^ B[3] ^ borrow[3];
    assign borrow[4] = (~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow[3]);

    // Zero detection of difference: all difference bits zero means A == B
    wire zero_diff;
    assign zero_diff = ~( |diff ); // OR reduction then inverted

    assign A_less    = borrow[4];
    assign A_equal   = zero_diff;
    assign A_greater = ~(borrow[4] | zero_diff);

endmodule