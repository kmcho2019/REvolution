module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal wires for difference bits and borrows
    wire [3:0] diff;
    wire [4:0] borrow; // borrow[0] is initial borrow in = 0

    assign borrow[0] = 1'b0;

    // Bit 0 subtractor: diff[0] = A[0] - B[0] - borrow[0]
    assign diff[0] = A[0] ^ B[0] ^ borrow[0];
    assign borrow[1] = (~A[0] & B[0]) | ((~A[0] | B[0]) & borrow[0]);

    // Bit 1 subtractor
    assign diff[1] = A[1] ^ B[1] ^ borrow[1];
    assign borrow[2] = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow[1]);

    // Bit 2 subtractor
    assign diff[2] = A[2] ^ B[2] ^ borrow[2];
    assign borrow[3] = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow[2]);

    // Bit 3 subtractor
    assign diff[3] = A[3] ^ B[3] ^ borrow[3];
    assign borrow[4] = (~A[3] & B[3]) | ((~A[3] | B[3]) & borrow[3]);

    // Determine outputs:
    // If borrow out (borrow[4]) = 1 => A < B
    // Else if diff == 0 => A == B
    // Else A > B

    wire diff_zero = ~|diff; // reduction NOR to check if all bits are 0

    assign A_less    = borrow[4];
    assign A_equal   = (~borrow[4]) & diff_zero;
    assign A_greater = (~borrow[4]) & (~diff_zero);

endmodule