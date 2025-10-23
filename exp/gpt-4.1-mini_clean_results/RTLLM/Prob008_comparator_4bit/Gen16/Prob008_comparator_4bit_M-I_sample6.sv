module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generation signals (borrow lookahead)
    wire b0, b1, b2, b3;
    wire borrow0 = 1'b0;

    // Borrow from bit 0
    assign b0 = (~A[0] & B[0]) | ((B[0] ^ A[0]) & borrow0);
    // Borrow from bit 1
    assign b1 = (~A[1] & B[1]) | ((B[1] ^ A[1]) & b0);
    // Borrow from bit 2
    assign b2 = (~A[2] & B[2]) | ((B[2] ^ A[2]) & b1);
    // Borrow from bit 3
    assign b3 = (~A[3] & B[3]) | ((B[3] ^ A[3]) & b2);

    // Bitwise equality detection (XNOR)
    wire [3:0] bit_equal = ~(A ^ B);

    // Balanced AND-tree for equality
    wire eq_01 = bit_equal[0] & bit_equal[1];
    wire eq_23 = bit_equal[2] & bit_equal[3];
    wire equal_bits = eq_01 & eq_23;

    // Outputs - mutually exclusive
    assign A_less    = b3;
    assign A_equal   = equal_bits;
    assign A_greater = ~(b3 | equal_bits);

endmodule