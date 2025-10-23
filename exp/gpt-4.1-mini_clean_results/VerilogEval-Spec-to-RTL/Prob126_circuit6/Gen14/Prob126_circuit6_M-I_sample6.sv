module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Base pattern: output at a=0
    localparam [15:0] base = 16'h1232;

    // Differences (XOR between q[a] and base)
    wire [15:0] diff [0:7];
    assign diff[0] = 16'h0000; // base ^ base
    assign diff[1] = 16'hbae2; // 0xaee0 ^ 0x1232
    assign diff[2] = 16'h3556; // 0x27d4 ^ 0x1232
    assign diff[3] = 16'h499c; // 0x5a0e ^ 0x1232
    assign diff[4] = 16'h3e54; // 0x2066 ^ 0x1232
    assign diff[5] = 16'h799c; // 0x64ce ^ 0x1232
    assign diff[6] = 16xde14; // 0xc526 ^ 0x1232
    assign diff[7] = 16x3e0b; // 0x2f19 ^ 0x1232

    // Compute output as base pattern XOR difference
    assign q = base ^ diff[a];

endmodule