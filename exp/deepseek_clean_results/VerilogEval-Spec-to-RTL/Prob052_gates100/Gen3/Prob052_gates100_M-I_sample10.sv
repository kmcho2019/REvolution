module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Simple reduction for AND and OR - already optimal
    assign out_and = &in;  // 100-input AND
    assign out_or  = |in;  // 100-input OR

    // Balanced XOR tree implementation
    wire [24:0] xor_level1;
    wire [5:0] xor_level2;
    wire [1:0] xor_level3;

    // First level: 25 groups of 4 bits
    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin : xor_tree1
            assign xor_level1[i] = ^in[i*4 +: 4];
        end
    endgenerate

    // Second level: 6 groups of 4 bits + 1 extra
    generate
        for (i = 0; i < 6; i = i + 1) begin : xor_tree2
            assign xor_level2[i] = ^xor_level1[i*4 +: 4];
        end
    endgenerate
    assign xor_level2[6] = ^xor_level1[24];

    // Third level: Final XOR
    assign xor_level3[0] = ^xor_level2[3:0];
    assign xor_level3[1] = ^xor_level2[6:4];
    assign out_xor = ^xor_level3;

endmodule