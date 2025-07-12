module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate signals per bit
    wire g0 = (~A[0]) & B[0];
    wire g1 = (~A[1]) & B[1];
    wire g2 = (~A[2]) & B[2];
    wire g3 = (~A[3]) & B[3];

    // Borrow propagate signals per bit
    wire p0 = ~(A[0] ^ B[0]);
    wire p1 = ~(A[1] ^ B[1]);
    wire p2 = ~(A[2] ^ B[2]);
    wire p3 = ~(A[3] ^ B[3]);

    // Borrow lookahead signals
    wire borrow_1 = g0;
    wire borrow_2 = g1 | (p1 & borrow_1);
    wire borrow_3 = g2 | (p2 & borrow_2);
    wire borrow_4 = g3 | (p3 & borrow_3); // borrow_out

    // Equality check: all bits equal if bitwise XNOR reduction is true
    wire equal_bits = &(~(A ^ B));

    assign A_less    = borrow_4;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_4 | equal_bits);

endmodule