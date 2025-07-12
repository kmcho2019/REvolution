module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Bitwise equality signals
    wire [3:0] eq_bit = ~(A ^ B);

    // Ripple borrow subtractor: A - B
    // borrow_in for LSB is 0
    // borrow_out = (~A & B) | ((~A | B) & borrow_in)
    assign borrow0 = (~A[0] & B[0]);
    assign diff[0] = A[0] ^ B[0];

    assign borrow1 = (~A[1] & B[1]) | ((~A[1] | B[1]) & borrow0);
    assign diff[1] = A[1] ^ B[1] ^ borrow0;

    assign borrow2 = (~A[2] & B[2]) | ((~A[2] | B[2]) & borrow1);
    assign diff[2] = A[2] ^ B[2] ^ borrow1;

    assign borrow3 = (~A[3] & B[3]) | ((~A[3] | B[3]) & borrow2);
    assign diff[3] = A[3] ^ B[3] ^ borrow2;

    // Zero detection: all diff bits are zero
    wire zero = &(~diff);

    // Outputs based on borrow and zero
    assign A_less    = borrow3;           // borrow out indicates A < B
    assign A_equal   = zero;              // all diff bits zero means equal
    assign A_greater = ~borrow3 & ~zero; // no borrow and non-zero means A > B

endmodule