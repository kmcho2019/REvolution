module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise equality: all bits equal if XNOR reduction is 1
    wire eq_all = &(~(A ^ B));

    // Borrow generation and propagation signals per bit
    wire g0 = (~A[0]) & B[0];
    wire p0 = ~(A[0] ^ B[0]);

    wire g1 = (~A[1]) & B[1];
    wire p1 = ~(A[1] ^ B[1]);

    wire g2 = (~A[2]) & B[2];
    wire p2 = ~(A[2] ^ B[2]);

    wire g3 = (~A[3]) & B[3];
    wire p3 = ~(A[3] ^ B[3]);

    // Ripple borrow calculation
    wire b0 = g0;
    wire b1 = g1 | (p1 & b0);
    wire b2 = g2 | (p2 & b1);
    wire b3 = g3 | (p3 & b2);

    // b3 is the borrow out indicating A < B
    assign A_less = b3;
    assign A_equal = eq_all;
    assign A_greater = ~b3 & ~eq_all;

endmodule