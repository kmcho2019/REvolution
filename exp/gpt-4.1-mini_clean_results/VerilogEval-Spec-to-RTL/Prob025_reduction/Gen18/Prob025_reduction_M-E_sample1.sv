module TopModule(
    input  [7:0] in,
    output       parity
);
    // Stage 0: initial partial XORs are the input bits themselves
    wire [7:0] stage0;
    assign stage0 = in;

    // Stage 1: XOR pairs with distance 1
    wire [7:0] stage1;
    assign stage1[0] = stage0[0];
    assign stage1[1] = stage0[1] ^ stage0[0];
    assign stage1[2] = stage0[2];
    assign stage1[3] = stage0[3] ^ stage0[2];
    assign stage1[4] = stage0[4];
    assign stage1[5] = stage0[5] ^ stage0[4];
    assign stage1[6] = stage0[6];
    assign stage1[7] = stage0[7] ^ stage0[6];

    // Stage 2: XOR pairs with distance 2
    wire [7:0] stage2;
    assign stage2[0] = stage1[0];
    assign stage2[1] = stage1[1];
    assign stage2[2] = stage1[2] ^ stage1[0];
    assign stage2[3] = stage1[3] ^ stage1[1];
    assign stage2[4] = stage1[4];
    assign stage2[5] = stage1[5];
    assign stage2[6] = stage1[6] ^ stage1[4];
    assign stage2[7] = stage1[7] ^ stage1[5];

    // Stage 3: XOR pairs with distance 4
    wire [7:0] stage3;
    assign stage3[0] = stage2[0];
    assign stage3[1] = stage2[1];
    assign stage3[2] = stage2[2];
    assign stage3[3] = stage2[3];
    assign stage3[4] = stage2[4] ^ stage2[0];
    assign stage3[5] = stage2[5] ^ stage2[1];
    assign stage3[6] = stage2[6] ^ stage2[2];
    assign stage3[7] = stage2[7] ^ stage2[3];

    // Final parity is the total XOR of all bits, which is stage3[7]
    assign parity = stage3[7];
endmodule