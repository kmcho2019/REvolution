module TopModule (
    input  [7:0] in,
    output      parity
);
    wire [3:0] stage1;
    wire [1:0] stage2;
    wire       stage3;

    // Stage 1: XOR pairs of input bits using reduction XOR on 2-bit slices
    assign stage1[0] = ^in[1:0];
    assign stage1[1] = ^in[3:2];
    assign stage1[2] = ^in[5:4];
    assign stage1[3] = ^in[7:6];

    // Stage 2: XOR pairs of stage1 results
    assign stage2[0] = ^stage1[1:0];
    assign stage2[1] = ^stage1[3:2];

    // Stage 3: XOR final pair to get parity
    assign stage3 = ^stage2;

    // Output the even parity bit
    assign parity = stage3;
endmodule