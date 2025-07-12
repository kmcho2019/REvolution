module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Divide the input into 4 chunks of 25 bits each
    wire [24:0] chunk0;
    wire [24:0] chunk1;
    wire [24:0] chunk2;
    wire [24:0] chunk3;

    assign chunk0 = in[24:0];
    assign chunk1 = in[49:25];
    assign chunk2 = in[74:50];
    assign chunk3 = in[99:75];

    // Perform AND, OR, and XOR operations on each chunk
    wire and_result0;
    wire or_result0;
    wire xor_result0;

    wire and_result1;
    wire or_result1;
    wire xor_result1;

    wire and_result2;
    wire or_result2;
    wire xor_result2;

    wire and_result3;
    wire or_result3;
    wire xor_result3;

    assign and_result0 = &chunk0;
    assign or_result0 = |chunk0;
    assign xor_result0 = ^chunk0;

    assign and_result1 = &chunk1;
    assign or_result1 = |chunk1;
    assign xor_result1 = ^chunk1;

    assign and_result2 = &chunk2;
    assign or_result2 = |chunk2;
    assign xor_result2 = ^chunk2;

    assign and_result3 = &chunk3;
    assign or_result3 = |chunk3;
    assign xor_result3 = ^chunk3;

    // Perform AND, OR, and XOR operations on the results of each chunk
    wire and_stage1;
    wire or_stage1;
    wire xor_stage1;

    wire and_stage2;
    wire or_stage2;
    wire xor_stage2;

    assign and_stage1 = and_result0 & and_result1;
    assign or_stage1 = or_result0 | or_result1;
    assign xor_stage1 = xor_result0 ^ xor_result1;

    assign and_stage2 = and_stage1 & and_result2;
    assign or_stage2 = or_stage1 | or_result2;
    assign xor_stage2 = xor_stage1 ^ xor_result2;

    assign out_and = and_stage2 & and_result3;
    assign out_or = or_stage2 | or_result3;
    assign out_xor = xor_stage2 ^ xor_result3;

endmodule