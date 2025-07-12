module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [3:0] borrow;

    // 1-bit subtractor module instantiation
    // borrow_in = borrow from previous less significant bit
    // borrow_out and diff are outputs
    // borrow_out = (~A & B) | ((~(A ^ B)) & borrow_in)

    // Bit 0 subtractor (borrow_in is 0)
    assign diff[0]   = A[0] ^ B[0];
    assign borrow[0] = (~A[0] & B[0]);

    // Bit 1 subtractor
    assign diff[1]   = A[1] ^ B[1] ^ borrow[0];
    assign borrow[1] = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow[0]);

    // Bit 2 subtractor
    assign diff[2]   = A[2] ^ B[2] ^ borrow[1];
    assign borrow[2] = (~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow[1]);

    // Bit 3 subtractor
    assign diff[3]   = A[3] ^ B[3] ^ borrow[2];
    assign borrow[3] = (~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow[2]);

    // Equality detection via bitwise XNOR reduction
    wire equal_all = &(~(A ^ B));

    // Outputs are mutually exclusive:
    // borrow[3] = 1 => A < B
    // borrow[3] = 0 and equal_all = 1 => A == B
    // borrow[3] = 0 and equal_all = 0 => A > B
    assign A_less    = borrow[3];
    assign A_equal   = ~borrow[3] & equal_all;
    assign A_greater = ~borrow[3] & ~equal_all;

endmodule