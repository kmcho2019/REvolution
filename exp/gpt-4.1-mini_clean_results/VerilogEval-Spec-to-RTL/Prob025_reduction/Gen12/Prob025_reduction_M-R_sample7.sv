module TopModule (
    input  [7:0] in,
    output       parity
);
    wire stage1_0, stage1_1, stage1_2, stage1_3;
    wire stage2_0, stage2_1;
    wire stage3;

    // Stage 1: XOR pairs of input bits
    assign stage1_0 = in[0] ^ in[1];
    assign stage1_1 = in[2] ^ in[3];
    assign stage1_2 = in[4] ^ in[5];
    assign stage1_3 = in[6] ^ in[7];

    // Stage 2: XOR results of stage 1
    assign stage2_0 = stage1_0 ^ stage1_1;
    assign stage2_1 = stage1_2 ^ stage1_3;

    // Stage 3: XOR results of stage 2 to get final parity
    assign stage3 = stage2_0 ^ stage2_1;

    // Output even parity bit
    assign parity = stage3;
endmodule