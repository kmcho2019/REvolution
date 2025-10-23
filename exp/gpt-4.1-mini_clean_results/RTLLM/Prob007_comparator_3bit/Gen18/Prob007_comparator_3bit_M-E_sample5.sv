module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    wire borrow0, borrow1, borrow2;
    wire diff0, diff1, diff2;

    // Subtract bit 0: diff0 = A0 - B0
    assign diff0 = A[0] ^ B[0];
    assign borrow0 = (~A[0]) & B[0];

    // Subtract bit 1: diff1 = A1 - B1 - borrow0
    // Using full subtractor logic:
    // diff1 = A1 ^ B1 ^ borrow0
    // borrow1 = (~A1 & B1) | ((~A1 | B1) & borrow0)
    assign diff1 = A[1] ^ B[1] ^ borrow0;
    assign borrow1 = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow0);

    // Subtract bit 2: diff2 = A2 - B2 - borrow1
    // diff2 = A2 ^ B2 ^ borrow1
    // borrow2 = (~A2 & B2) | ((~A2 | B2) & borrow1)
    assign diff2 = A[2] ^ B[2] ^ borrow1;
    assign borrow2 = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow1);

    // Compose the 3-bit difference result
    wire [2:0] diff = {diff2, diff1, diff0};

    // Equality check: diff == 0 means A == B
    assign A_equal = ~|diff; // NOR reduction on diff bits

    // borrow2 is the final borrow output
    // If borrow2=0 and diff !=0 => A > B
    assign A_greater = (~borrow2) & (|diff);

    // Else A < B when borrow2=1
    assign A_less = borrow2;

endmodule