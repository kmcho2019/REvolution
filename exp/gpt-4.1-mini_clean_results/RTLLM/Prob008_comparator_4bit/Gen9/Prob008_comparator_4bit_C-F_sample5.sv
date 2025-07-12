module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Ripple borrow chain for A < B detection
    wire [4:0] borrow;
    assign borrow[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : borrow_chain
            // borrow_out = (~A & B) | ((~(A ^ B)) & borrow_in)
            assign borrow[i+1] = (~A[i] & B[i]) | ((~(A[i] ^ B[i])) & borrow[i]);
        end
    endgenerate

    // Bitwise equality using XNOR (A==B) per bit
    wire [3:0] bit_equal = ~(A ^ B);

    // Balanced AND-tree for overall equality (improves timing)
    wire eq_01 = bit_equal[0] & bit_equal[1];
    wire eq_23 = bit_equal[2] & bit_equal[3];
    wire equal_bits = eq_01 & eq_23;

    // Outputs: mutually exclusive
    assign A_less    = borrow[4];
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow[4] | equal_bits);

endmodule