module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Pipeline stage 1: AND, OR, XOR operations for first 25 bits
    wire [24:0] and_stage1;
    wire [24:0] or_stage1;
    wire [24:0] xor_stage1;
    assign and_stage1[0] = in[0];
    assign or_stage1[0] = in[0];
    assign xor_stage1[0] = in[0];
    for (genvar i = 1; i < 25; i++) begin
        assign and_stage1[i] = in[i] & and_stage1[i-1];
        assign or_stage1[i] = in[i] | or_stage1[i-1];
        assign xor_stage1[i] = in[i] ^ xor_stage1[i-1];
    end

    // Pipeline stage 2: AND, OR, XOR operations for next 25 bits
    wire [24:0] and_stage2;
    wire [24:0] or_stage2;
    wire [24:0] xor_stage2;
    assign and_stage2[0] = in[25];
    assign or_stage2[0] = in[25];
    assign xor_stage2[0] = in[25];
    for (genvar i = 1; i < 25; i++) begin
        assign and_stage2[i] = in[i+25] & and_stage2[i-1];
        assign or_stage2[i] = in[i+25] | or_stage2[i-1];
        assign xor_stage2[i] = in[i+25] ^ xor_stage2[i-1];
    end

    // Pipeline stage 3: AND, OR, XOR operations for last 25 bits
    wire [24:0] and_stage3;
    wire [24:0] or_stage3;
    wire [24:0] xor_stage3;
    assign and_stage3[0] = in[50];
    assign or_stage3[0] = in[50];
    assign xor_stage3[0] = in[50];
    for (genvar i = 1; i < 25; i++) begin
        assign and_stage3[i] = in[i+50] & and_stage3[i-1];
        assign or_stage3[i] = in[i+50] | or_stage3[i-1];
        assign xor_stage3[i] = in[i+50] ^ xor_stage3[i-1];
    end

    // Pipeline stage 4: Final AND, OR, XOR operations
    assign out_and = and_stage1[24] & and_stage2[24] & and_stage3[24];
    assign out_or = or_stage1[24] | or_stage2[24] | or_stage3[24];
    assign out_xor = xor_stage1[24] ^ xor_stage2[24] ^ xor_stage3[24];

endmodule