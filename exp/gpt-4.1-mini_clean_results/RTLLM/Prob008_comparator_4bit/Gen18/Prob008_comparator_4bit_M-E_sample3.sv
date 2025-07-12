module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal wires for borrow chain and difference bits
    wire b0 = 1'b0;  // initial borrow-in is zero
    wire [3:0] diff;
    wire [3:0] borrow;

    // Bit 0 subtraction: diff = A0 - B0 - b0
    assign diff[0] = A[0] ^ B[0] ^ b0;
    assign borrow[0] = (~A[0] & B[0]) | ((~A[0] | B[0]) & b0);

    // Bit 1 subtraction: diff = A1 - B1 - borrow[0]
    assign diff[1] = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow[0]);

    // Bit 2 subtraction: diff = A2 - B2 - borrow[1]
    assign diff[2] = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow[1]);

    // Bit 3 subtraction: diff = A3 - B3 - borrow[2]
    assign diff[3] = A[3] ^ B[3] ^ borrow[2];
    assign borrow[3] = (~A[3] & B[3]) | ((~A[3] | B[3]) & borrow[2]);

    wire result_zero = ~( |diff ); // result is zero if all diff bits are zero

    // If borrow out (borrow[3]) = 1, A < B
    assign A_less = borrow[3];

    // If no borrow out, and result non-zero => A > B
    assign A_greater = (~borrow[3]) & (~result_zero);

    // If no borrow and result zero => A == B
    assign A_equal = (~borrow[3]) & (result_zero);

endmodule