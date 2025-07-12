module TopModule (
    input  [7:0] in,
    output       parity
);
    wire [3:0] stage1;
    wire [1:0] stage2;
    wire       stage3;

    // Stage 1: XOR input bits in pairs
    assign stage1[0] = in[0] ^ in[1];
    assign stage1[1] = in[2] ^ in[3];
    assign stage1[2] = in[4] ^ in[5];
    assign stage1[3] = in[6] ^ in[7];

    // Stage 2: XOR results of stage 1 pairs
    assign stage2[0] = stage1[0] ^ stage1[1];
    assign stage2[1] = stage1[2] ^ stage1[3];

    // Stage 3: XOR final pair to get parity
    assign stage3 = stage2[0] ^ stage2[1];

    // Output the even parity bit
    assign parity = stage3;
endmodule