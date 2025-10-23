module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND operation
    wire [9:0] and_group;
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin
            wire [9:0] and_subgroup;
            and_subgroup[0] = in[i*10];
            for (genvar j = 1; j < 10; j = j + 1) begin
                and_subgroup[j] = and_subgroup[j-1] & in[i*10 + j];
            end
            and_group[i] = and_subgroup[9];
        end
    endgenerate
    wire [4:0] and_level1;
    generate
        for (i = 0; i < 5; i = i + 1) begin
            and_level1[i] = and_group[i*2] & and_group[i*2 + 1];
        end
    endgenerate
    wire [1:0] and_level2;
    generate
        for (i = 0; i < 2; i = i + 1) begin
            and_level2[i] = and_level1[i*2] & and_level1[i*2 + 1];
        end
    endgenerate
    assign out_and = and_level2[0] & and_level2[1];

    // OR operation
    wire [9:0] or_group;
    generate
        for (i = 0; i < 10; i = i + 1) begin
            wire [9:0] or_subgroup;
            or_subgroup[0] = in[i*10];
            for (genvar j = 1; j < 10; j = j + 1) begin
                or_subgroup[j] = or_subgroup[j-1] | in[i*10 + j];
            end
            or_group[i] = or_subgroup[9];
        end
    endgenerate
    wire [4:0] or_level1;
    generate
        for (i = 0; i < 5; i = i + 1) begin
            or_level1[i] = or_group[i*2] | or_group[i*2 + 1];
        end
    endgenerate
    wire [1:0] or_level2;
    generate
        for (i = 0; i < 2; i = i + 1) begin
            or_level2[i] = or_level1[i*2] | or_level1[i*2 + 1];
        end
    endgenerate
    assign out_or = or_level2[0] | or_level2[1];

    // XOR operation
    wire [9:0] xor_group;
    generate
        for (i = 0; i < 10; i = i + 1) begin
            wire [9:0] xor_subgroup;
            xor_subgroup[0] = in[i*10];
            for (genvar j = 1; j < 10; j = j + 1) begin
                xor_subgroup[j] = xor_subgroup[j-1] ^ in[i*10 + j];
            end
            xor_group[i] = xor_subgroup[9];
        end
    endgenerate
    wire [4:0] xor_level1;
    generate
        for (i = 0; i < 5; i = i + 1) begin
            xor_level1[i] = xor_group[i*2] ^ xor_group[i*2 + 1];
        end
    endgenerate
    wire [1:0] xor_level2;
    generate
        for (i = 0; i < 2; i = i + 1) begin
            xor_level2[i] = xor_level1[i*2] ^ xor_level1[i*2 + 1];
        end
    endgenerate
    assign out_xor = xor_level2[0] ^ xor_level2[1];

endmodule