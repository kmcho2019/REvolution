module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Manually unrolled ripple borrow chain
    wire borrow0 = 1'b0;
    wire borrow1 = (~A[0] & B[0]) | ((~(A[0] ^ B[0])) & borrow0);
    wire borrow2 = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow1);
    wire borrow3 = (~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow2);
    wire borrow4 = (~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow3);

    // Equality check using bitwise XNOR and reduction AND
    wire [3:0] xnor_bits = ~(A ^ B);
    wire equal_bits = &xnor_bits; // reduction AND

    // Outputs (mutually exclusive)
    assign A_less    = borrow4;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow4 | equal_bits);

endmodule