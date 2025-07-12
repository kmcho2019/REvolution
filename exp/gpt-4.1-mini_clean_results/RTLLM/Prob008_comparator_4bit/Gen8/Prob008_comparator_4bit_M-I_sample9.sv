module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Full subtractor bit 0: A0 - B0 - borrow_in(=0)
    assign diff[0]   = A[0] ^ B[0];
    assign borrow0   = (~A[0] & B[0]);

    // Full subtractor bit 1: A1 - B1 - borrow0
    assign diff[1]   = A[1] ^ B[1] ^ borrow0;
    assign borrow1   = ((~A[1] & B[1]) | ((~A[1] | B[1]) & borrow0));

    // Full subtractor bit 2: A2 - B2 - borrow1
    assign diff[2]   = A[2] ^ B[2] ^ borrow1;
    assign borrow2   = ((~A[2] & B[2]) | ((~A[2] | B[2]) & borrow1));

    // Full subtractor bit 3: A3 - B3 - borrow2
    assign diff[3]   = A[3] ^ B[3] ^ borrow2;
    assign borrow3   = ((~A[3] & B[3]) | ((~A[3] | B[3]) & borrow2));

    wire zero = ~|diff; // result zero if all bits of diff are 0

    assign A_less    = borrow3;          // borrow out = 1 means A < B
    assign A_equal   = (~borrow3) & zero; // no borrow, result zero means equal
    assign A_greater = (~borrow3) & ~zero; // no borrow, result non-zero means greater

endmodule