module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire [3:0] diff;
    wire [3:0] borrow;

    // Bit 0 subtraction with borrow-in = 0
    assign diff[0]   = A[0] ^ B[0];
    assign borrow[0] = (~A[0]) & B[0];

    // Bit 1 subtraction with borrow from bit 0
    assign diff[1]   = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = ((~A[1]) & B[1]) | (((~A[1]) | B[1]) & borrow[0]);

    // Bit 2 subtraction with borrow from bit 1
    assign diff[2]   = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = ((~A[2]) & B[2]) | (((~A[2]) | B[2]) & borrow[1]);

    // Bit 3 subtraction with borrow from bit 2
    assign diff[3]   = A[3] ^ B[3] ^ borrow[2];
    assign borrow[3] = ((~A[3]) & B[3]) | (((~A[3]) | B[3]) & borrow[2]);

    // If borrow[3] = 1, then A < B
    wire a_less = borrow[3];

    // A equal B if all diff bits are zero
    wire a_equal = ~(diff[0] | diff[1] | diff[2] | diff[3]);

    // If not less and not equal, A > B
    wire a_greater = ~a_less & ~a_equal;

    assign A_less    = a_less;
    assign A_equal   = a_equal;
    assign A_greater = a_greater;

endmodule