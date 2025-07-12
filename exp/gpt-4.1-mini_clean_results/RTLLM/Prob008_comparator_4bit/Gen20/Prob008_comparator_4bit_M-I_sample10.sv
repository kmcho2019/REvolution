module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal wires for borrow and difference bits
    wire [3:0] diff;
    wire [3:0] borrow;

    // Bit 0 subtraction (A0 - B0)
    assign diff[0] = A[0] ^ B[0];
    assign borrow[0] = ~A[0] & B[0];

    // Bit 1 subtraction with borrow
    assign diff[1] = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow[0]);

    // Bit 2 subtraction with borrow
    assign diff[2] = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow[1]);

    // Bit 3 subtraction with borrow
    assign diff[3] = A[3] ^ B[3] ^ borrow[2];
    assign borrow[3] = (~A[3] & B[3]) | ((~A[3] | B[3]) & borrow[2]);

    // Zero detection: all difference bits zero => A == B
    wire zero_diff = ~(diff[3] | diff[2] | diff[1] | diff[0]);

    // Borrow out from MSB indicates A < B
    assign A_less = borrow[3];

    // A_equal: zero difference and no borrow
    assign A_equal = zero_diff & ~borrow[3];

    // A_greater: not less and not equal
    assign A_greater = ~A_less & ~A_equal;

endmodule