module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow signals for each bit subtraction
    wire borrow0, borrow1, borrow2, borrow3;

    // Borrow for LSB subtraction: borrow0 = (~A0 & B0)
    assign borrow0 = (~A[0] & B[0]);

    // Borrow for bit 1: borrow1 = (~A1 & B1) | ((~(A1 ^ B1)) & borrow0)
    assign borrow1 = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow0);

    // Borrow for bit 2: borrow2 = (~A2 & B2) | ((~(A2 ^ B2)) & borrow1)
    assign borrow2 = (~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow1);

    // Borrow for bit 3: borrow3 = (~A3 & B3) | ((~(A3 ^ B3)) & borrow2)
    assign borrow3 = (~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow2);

    // Equality check: all bits must be equal, done by bitwise XNOR and reduction AND
    wire equal_bits = &(~(A ^ B));

    // Outputs: mutually exclusive based on borrow3 and equality
    assign A_less    = borrow3;
    assign A_equal   = (~borrow3) & equal_bits;
    assign A_greater = (~borrow3) & (~equal_bits);

endmodule