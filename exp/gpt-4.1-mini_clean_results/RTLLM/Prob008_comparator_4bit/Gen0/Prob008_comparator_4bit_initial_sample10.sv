module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;       // difference bits
    wire [3:0] borrow;     // borrow signals between bits

    // Full subtractor for bit 0 (LSB)
    assign diff[0]   = A[0] ^ B[0];
    assign borrow[0] = (~A[0] & B[0]);

    // Full subtractor for bit 1
    assign diff[1]   = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow[0]);

    // Full subtractor for bit 2
    assign diff[2]   = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = (~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow[1]);

    // Full subtractor for bit 3 (MSB)
    assign diff[3]   = A[3] ^ B[3] ^ borrow[2];
    assign borrow[3] = (~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow[2]);

    // Borrow out (borrow[3]) indicates A < B
    assign A_less    = borrow[3];

    // Check if difference is zero => A == B
    assign A_equal   = (~|diff) & (~borrow[3]);

    // If no borrow out and difference != 0 => A > B
    assign A_greater = (~borrow[3]) & (|diff);

endmodule