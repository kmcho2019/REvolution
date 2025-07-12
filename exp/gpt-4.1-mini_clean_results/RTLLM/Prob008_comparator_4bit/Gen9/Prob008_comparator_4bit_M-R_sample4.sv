module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compute equality of each bit
    wire eq0 = ~(A[0] ^ B[0]);
    wire eq1 = ~(A[1] ^ B[1]);
    wire eq2 = ~(A[2] ^ B[2]);
    wire eq3 = ~(A[3] ^ B[3]);

    // Overall equality
    wire all_equal = eq0 & eq1 & eq2 & eq3;

    // Ripple borrow bits: borrow_in for bit0 is zero (no borrow in)
    wire borrow0 = 1'b0;

    // Borrow for bit0: borrow if A[0] < B[0] + borrow_in (borrow0)
    wire borrow1 = (~A[0] & B[0]) | ((~A[0] | B[0]) & borrow0);

    // Borrow for bit1
    wire borrow2 = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow1);

    // Borrow for bit2
    wire borrow3 = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow2);

    // Borrow for bit3 (final borrow out)
    wire borrow4 = (~A[3] & B[3]) | ((~A[3] | B[3]) & borrow3);

    // Outputs mutually exclusive:
    assign A_less    = borrow4;       // borrow out means A < B
    assign A_equal   = all_equal;     // all bits equal means A == B
    assign A_greater = ~borrow4 & ~all_equal; // no borrow and not equal means A > B

endmodule