module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise equality signals for each bit
    wire eq_bit0 = ~(A[0] ^ B[0]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit2 = ~(A[2] ^ B[2]);

    // Aggregate equality signals
    wire bits_equal = eq_bit0 & eq_bit1 & eq_bit2;

    // Combine MSB and next bit equality to reduce redundant checks
    wire eq_bit2_and_1 = eq_bit2 & eq_bit1;

    // Greater-than logic with shared equality signals to minimize gate count
    wire greater = (A[2] & ~B[2]) |
                   (eq_bit2 & A[1] & ~B[1]) |
                   (eq_bit2_and_1 & A[0] & ~B[0]);

    assign A_equal   = bits_equal;
    assign A_greater = greater;
    assign A_less    = ~greater & ~bits_equal;

endmodule