module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the 100-bit input into 25 groups of 4 bits each
    wire [24:0] and_group;
    wire [24:0] or_group;
    wire [24:0] xor_group;

    genvar i;
    generate
        for (i = 0; i < 25; i = i + 1) begin
            // Perform AND, OR, and XOR operations on each group of 4 bits
            assign and_group[i] = &in[i*4 +: 4];
            assign or_group[i] = |in[i*4 +: 4];
            assign xor_group[i] = ^in[i*4 +: 4];
        end
    endgenerate

    // Combine the intermediate results in a hierarchical manner
    wire [4:0] and_level1;
    wire [4:0] or_level1;
    wire [4:0] xor_level1;

    genvar j;
    generate
        for (j = 0; j < 5; j = j + 1) begin
            // Combine 5 groups of intermediate results
            assign and_level1[j] = &and_group[j*5 +: 5];
            assign or_level1[j] = |or_group[j*5 +: 5];
            assign xor_level1[j] = ^xor_group[j*5 +: 5];
        end
    endgenerate

    // Final combination of intermediate results
    assign out_and = &and_level1;
    assign out_or = |or_level1;
    assign out_xor = ^xor_level1;

endmodule