module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;         // difference bits (A - B)
    wire [3:0] borrow;       // borrow signals between bits
    wire [3:0] AxorB;        // precomputed XOR of A and B bits

    // Precompute XOR for all bits to reuse
    assign AxorB = A ^ B;

    // Bit 0 subtractor (LSB)
    assign diff[0]   = AxorB[0];
    assign borrow[0] = (~A[0]) & B[0];

    // Bit 1 subtractor
    assign diff[1]   = AxorB[1] ^ borrow[0];
    assign borrow[1] = ((~A[1]) & B[1]) | ((~AxorB[1]) & borrow[0]);

    // Bit 2 subtractor
    assign diff[2]   = AxorB[2] ^ borrow[1];
    assign borrow[2] = ((~A[2]) & B[2]) | ((~AxorB[2]) & borrow[1]);

    // Bit 3 subtractor (MSB)
    assign diff[3]   = AxorB[3] ^ borrow[2];
    assign borrow[3] = ((~A[3]) & B[3]) | ((~AxorB[3]) & borrow[2]);

    // borrow[3] = 1 if A < B (borrow out from MSB)
    assign A_less    = borrow[3];

    // Check if diff is zero and borrow[3] is zero => A == B
    assign A_equal   = (~|diff) & (~borrow[3]);

    // If no borrow and difference non-zero => A > B
    assign A_greater = (~borrow[3]) & (|diff);

endmodule