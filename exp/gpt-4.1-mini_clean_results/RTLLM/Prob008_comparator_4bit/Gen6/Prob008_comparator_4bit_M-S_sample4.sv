module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] borrow; // borrow chain, borrow[0] = 0 (initial)
    assign borrow[0] = 1'b0;

    // Ripple borrow calculation for each bit
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : BORROW_CHAIN
            assign borrow[i+1] = (~A[i] & B[i]) | ((~(A[i] ^ B[i])) & borrow[i]);
        end
    endgenerate

    // Check equality using bitwise XNOR and AND reduction
    wire equal_bits = &(~(A ^ B));

    // Outputs: mutually exclusive
    assign A_less    = borrow[4];
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow[4] | equal_bits);

endmodule