module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Precompute equality of each bit
    wire eq3 = ~(A[3] ^ B[3]);
    wire eq2 = ~(A[2] ^ B[2]);
    wire eq1 = ~(A[1] ^ B[1]);
    wire eq0 = ~(A[0] ^ B[0]);

    // Overall equality: all bits equal
    wire all_equal = eq3 & eq2 & eq1 & eq0;

    // Subtract A - B with borrow chain (borrow indicates A < B)
    wire b0, b1, b2, b3;

    // Bit 0: borrow if A[0]<B[0]
    assign b0 = (~A[0] & B[0]);
    // Bit 1: borrow if A[1] < B[1] + borrow_in
    assign b1 = (~A[1] & B[1]) | ((~A[1] | B[1]) & b0);
    // Bit 2: borrow if A[2] < B[2] + borrow_in
    assign b2 = (~A[2] & B[2]) | ((~A[2] | B[2]) & b1);
    // Bit 3: borrow if A[3] < B[3] + borrow_in (final borrow)
    assign b3 = (~A[3] & B[3]) | ((~A[3] | B[3]) & b2);

    // borrow at MSB means A < B
    wire less = b3;

    // Result of subtraction bits (for checking zero)
    wire [3:0] diff;
    assign diff[0] = A[0] ^ B[0] ^ 1'b0; // borrow_in at LSB is 0
    assign diff[1] = A[1] ^ B[1] ^ b0;
    assign diff[2] = A[2] ^ B[2] ^ b1;
    assign diff[3] = A[3] ^ B[3] ^ b2;

    // Check if difference is zero
    wire diff_zero = ~(diff[3] | diff[2] | diff[1] | diff[0]);

    // Determine greater: no borrow and non-zero diff
    wire greater = (~less) & (~diff_zero);

    assign A_equal   = diff_zero;  // equal if diff zero
    assign A_less    = less;
    assign A_greater = greater;

endmodule