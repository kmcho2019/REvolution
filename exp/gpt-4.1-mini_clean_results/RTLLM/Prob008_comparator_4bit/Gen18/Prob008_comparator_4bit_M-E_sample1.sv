module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal wires for borrow chain and difference bits
    wire [3:0] diff;
    wire [3:0] borrow;

    // Full subtractor bit 0
    // borrow[0] = ~A[0]&B[0] | (B[0]&borrow_in) | (~A[0]&borrow_in)
    // borrow_in at LSB is 0 (no borrow in)
    assign diff[0] = A[0] ^ B[0]; // since borrow_in0=0, diff0 = A0 xor B0 xor 0 = A0 xor B0
    assign borrow[0] = (~A[0] & B[0]);

    // Full subtractor bit 1
    // diff1 = A1 xor B1 xor borrow0
    // borrow1 = (~A1 & B1) | ((B1 | ~A1) & borrow0)
    assign diff[1] = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = (~A[1] & B[1]) | (((B[1] | ~A[1]) & borrow[0]));

    // Full subtractor bit 2
    assign diff[2] = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = (~A[2] & B[2]) | (((B[2] | ~A[2]) & borrow[1]));

    // Full subtractor bit 3
    assign diff[3] = A[3] ^ B[3] ^ borrow[2];
    assign borrow[3] = (~A[3] & B[3]) | (((B[3] | ~A[3]) & borrow[2]));

    // Borrow out indicates A < B
    // If borrow[3] == 1 => A < B
    // If borrow[3] == 0 and diff==0 => A == B
    // If borrow[3] == 0 and diff != 0 => A > B

    wire diff_zero = ~(diff[0] | diff[1] | diff[2] | diff[3]);

    assign A_less    = borrow[3];
    assign A_equal   = (~borrow[3]) & diff_zero;
    assign A_greater = (~borrow[3]) & (~diff_zero);

endmodule