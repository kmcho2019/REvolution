module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] borrow; // borrow signals for each bit

    // borrow_in is 0 at LSB (no borrow input to start)
    // borrow[i] indicates borrow out of bit i
    // borrow[0] depends on LSB bits A[0], B[0]
    assign borrow[0] = (~A[0] & B[0]);

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : BORROW_CHAIN
            // borrow out of bit i:
            // borrow[i] = (~A[i] & B[i]) | ((~(A[i] ^ B[i])) & borrow[i-1])
            assign borrow[i] = (~A[i] & B[i]) | ((~(A[i] ^ B[i])) & borrow[i-1]);
        end
    endgenerate

    // Equality: all bits equal means all bits are XNOR equal
    wire equal_bits = &(~(A ^ B)); // XNOR reduction by ~(A^B) and AND

    // Outputs are mutually exclusive:
    // A_less is borrow out of MSB (borrow[3])
    // A_equal is equality
    // A_greater is neither less nor equal
    assign A_less    = borrow[3];
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow[3] | equal_bits);

endmodule