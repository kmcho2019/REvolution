module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Full subtractor per bit: inputs are A[i], B[i], borrow_in
    // Outputs are difference[i] and borrow_out

    wire b0, b1, b2, b3; // borrows between bits
    wire [3:0] diff;     // difference bits

    // Bit 0 subtractor
    assign diff[0] = A[0] ^ B[0] ^ 1'b0;               // borrow_in = 0 for LSB
    assign b0 = (~A[0] & B[0]) | ((~A[0] | B[0]) & 1'b0);

    // Bit 1 subtractor
    assign diff[1] = A[1] ^ B[1] ^ b0;
    assign b1 = (~A[1] & B[1]) | ((~A[1] | B[1]) & b0);

    // Bit 2 subtractor
    assign diff[2] = A[2] ^ B[2] ^ b1;
    assign b2 = (~A[2] & B[2]) | ((~A[2] | B[2]) & b1);

    // Bit 3 subtractor (MSB)
    assign diff[3] = A[3] ^ B[3] ^ b2;
    assign b3 = (~A[3] & B[3]) | ((~A[3] | B[3]) & b2);

    // borrow_out from MSB subtractor = b3
    // If b3=1 => A < B
    // If b3=0 and diff=0 => A == B
    // Else A > B

    wire any_diff = |diff;        // 1 if any bit of difference is 1
    wire no_diff = ~any_diff;     // 1 if difference is zero

    assign A_less    = b3;
    assign A_equal   = (~b3) & no_diff;
    assign A_greater = (~b3) & any_diff;

endmodule