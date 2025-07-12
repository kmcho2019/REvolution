module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire b0, b1, b2, b3; // borrows for each stage

    // Full subtractor bit 0
    assign diff[0] = A[0] ^ B[0];
    assign b0 = (~A[0] & B[0]);

    // Full subtractor bit 1
    assign diff[1] = A[1] ^ B[1] ^ b0;
    assign b1 = ((~A[1] & B[1]) | ((~A[1] | B[1]) & b0));

    // Full subtractor bit 2
    assign diff[2] = A[2] ^ B[2] ^ b1;
    assign b2 = ((~A[2] & B[2]) | ((~A[2] | B[2]) & b1));

    // Full subtractor bit 3
    assign diff[3] = A[3] ^ B[3] ^ b2;
    assign b3 = ((~A[3] & B[3]) | ((~A[3] | B[3]) & b2));

    wire diff_zero = ~(|diff);

    assign A_less    = b3;
    assign A_equal   = ~b3 & diff_zero;
    assign A_greater = ~b3 & ~diff_zero;

endmodule