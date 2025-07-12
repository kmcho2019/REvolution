module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [4:0] borrow;

    // Initial borrow_in is zero
    assign borrow[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUB_BITS
            // Bitwise subtraction with borrow:
            // diff[i] = A[i] ^ B[i] ^ borrow[i]
            assign diff[i] = A[i] ^ B[i] ^ borrow[i];
            // borrow[i+1] = (~A[i] & B[i]) | ((~A[i] | B[i]) & borrow[i])
            assign borrow[i+1] = (~A[i] & B[i]) | ((~A[i] | B[i]) & borrow[i]);
        end
    endgenerate

    // Equality check separate from subtraction:
    // eq_bits = all bits of A and B are equal (XNOR then reduction AND)
    wire eq_bits = &(~(A ^ B));

    // Outputs mutually exclusive:
    // If borrow out of MSB+1 is 1, A < B
    // Else if no borrow and A==B, A_equal=1
    // Else A > B
    assign A_less    = borrow[4];
    assign A_equal   = (~borrow[4]) & eq_bits;
    assign A_greater = (~borrow[4]) & (~eq_bits);

endmodule