module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Balanced AND reduction tree (6x16-bit chunks + 1x4-bit chunk)
    wire [6:0] and_level1;
    assign and_level1[0] = &in[15:0];
    assign and_level1[1] = &in[31:16];
    assign and_level1[2] = &in[47:32];
    assign and_level1[3] = &in[63:48];
    assign and_level1[4] = &in[79:64];
    assign and_level1[5] = &in[95:80];
    assign and_level1[6] = &in[99:96];
    assign out_and = &and_level1;

    // Balanced OR reduction tree (same structure as AND)
    wire [6:0] or_level1;
    assign or_level1[0] = |in[15:0];
    assign or_level1[1] = |in[31:16];
    assign or_level1[2] = |in[47:32];
    assign or_level1[3] = |in[63:48];
    assign or_level1[4] = |in[79:64];
    assign or_level1[5] = |in[95:80];
    assign or_level1[6] = |in[99:96];
    assign out_or = |or_level1;

    // Optimal XOR reduction
    assign out_xor = ^in;

endmodule