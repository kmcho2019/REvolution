module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit equality signals (XNOR)
    wire eq0 = ~(A[0] ^ B[0]);
    wire eq1 = ~(A[1] ^ B[1]);
    wire eq2 = ~(A[2] ^ B[2]);
    wire eq3 = ~(A[3] ^ B[3]);

    // Equal if all bits equal
    wire equal_bits = eq0 & eq1 & eq2 & eq3;

    // Full subtractor borrow chain
    // borrow_in to bit 0 = 0 (no initial borrow)
    wire borrow0 = 1'b0;

    // bit 0 borrow out
    wire borrow1 = (~A[0] & B[0]) | ((~A[0] | B[0]) & borrow0);

    // bit 1 borrow out
    wire borrow2 = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow1);

    // bit 2 borrow out
    wire borrow3 = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow2);

    // bit 3 borrow out (final borrow)
    wire borrow4 = (~A[3] & B[3]) | ((~A[3] | B[3]) & borrow3);

    // Outputs
    assign A_less    = borrow4;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow4 | equal_bits);

endmodule