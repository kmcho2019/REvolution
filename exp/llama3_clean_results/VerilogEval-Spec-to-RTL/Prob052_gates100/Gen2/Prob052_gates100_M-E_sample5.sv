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
            assign and_group[i] = in[i*4] & in[i*4+1] & in[i*4+2] & in[i*4+3];
            assign or_group[i] = in[i*4] | in[i*4+1] | in[i*4+2] | in[i*4+3];
            assign xor_group[i] = in[i*4] ^ in[i*4+1] ^ in[i*4+2] ^ in[i*4+3];
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
            assign and_level1[j] = and_group[j*5] & and_group[j*5+1] & and_group[j*5+2] & and_group[j*5+3] & and_group[j*5+4];
            assign or_level1[j] = or_group[j*5] | or_group[j*5+1] | or_group[j*5+2] | or_group[j*5+3] | or_group[j*5+4];
            assign xor_level1[j] = xor_group[j*5] ^ xor_group[j*5+1] ^ xor_group[j*5+2] ^ xor_group[j*5+3] ^ xor_group[j*5+4];
        end
    endgenerate

    // Final combination of intermediate results
    assign out_and = and_level1[0] & and_level1[1] & and_level1[2] & and_level1[3] & and_level1[4];
    assign out_or = or_level1[0] | or_level1[1] | or_level1[2] | or_level1[3] | or_level1[4];
    assign out_xor = xor_level1[0] ^ xor_level1[1] ^ xor_level1[2] ^ xor_level1[3] ^ xor_level1[4];

endmodule