module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit equality signals (XNOR)
    wire eq_bit0 = ~(A[0] ^ B[0]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit3 = ~(A[3] ^ B[3]);

    // Ripple borrow chain for A < B detection
    wire borrow0 = 1'b0;
    wire borrow1 = (~A[0] & B[0]) | (eq_bit0 & borrow0);
    wire borrow2 = (~A[1] & B[1]) | (eq_bit1 & borrow1);
    wire borrow3 = (~A[2] & B[2]) | (eq_bit2 & borrow2);
    wire borrow4 = (~A[3] & B[3]) | (eq_bit3 & borrow3);

    // Equality detection via reduction AND of eq_bit signals
    wire equal_bits = eq_bit0 & eq_bit1 & eq_bit2 & eq_bit3;

    // Outputs: mutually exclusive encoding
    assign A_less    = borrow4;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow4 | equal_bits);

endmodule