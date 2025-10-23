module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal wires for borrow and difference bits
    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Full subtractor for bit 0
    // diff = A - B - borrow_in; borrow_out if borrow needed
    // For bit 0, borrow_in = 0
    assign diff[0] = A[0] ^ B[0];
    assign borrow0 = (~A[0] & B[0]);

    // Bit 1 full subtractor
    assign diff[1] = A[1] ^ B[1] ^ borrow0;
    assign borrow1 = ((~A[1]) & B[1]) | (((~A[1]) | B[1]) & borrow0);

    // Bit 2 full subtractor
    assign diff[2] = A[2] ^ B[2] ^ borrow1;
    assign borrow2 = ((~A[2]) & B[2]) | (((~A[2]) | B[2]) & borrow1);

    // Bit 3 full subtractor
    assign diff[3] = A[3] ^ B[3] ^ borrow2;
    assign borrow3 = ((~A[3]) & B[3]) | (((~A[3]) | B[3]) & borrow2);

    // borrow3 = 1 means A < B
    // If borrow3=0 and diff all zero => A == B
    wire diff_zero = ~|diff; // reduction NOR to check if difference is zero

    assign A_less    = borrow3;
    assign A_equal   = (~borrow3) & diff_zero;
    assign A_greater = (~borrow3) & (~diff_zero);

endmodule