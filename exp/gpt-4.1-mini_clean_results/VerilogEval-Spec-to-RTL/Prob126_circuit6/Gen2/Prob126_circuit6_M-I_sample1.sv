module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Base output value for a = 0
    wire [15:0] base = 16'h1232;

    // Define XOR differences relative to base
    // For a = 0, diff = 0
    // Precompute diffs: diff = q[a] ^ base
    wire [15:0] diff_lut [0:7];
    assign diff_lut[0] = 16'h0000; // 1232 ^ 1232 = 0
    assign diff_lut[1] = 16'hb0f2; // aee0 ^ 1232
    assign diff_lut[2] = 16'h34e6; // 27d4 ^ 1232
    assign diff_lut[3] = 16'h487c; // 5a0e ^ 1232
    assign diff_lut[4] = 16'h3054; // 2066 ^ 1232
    assign diff_lut[5] = 16'h77fc; // 64ce ^ 1232
    assign diff_lut[6] = 16'hd714; // c526 ^ 1232
    assign diff_lut[7] = 16'h3ea3; // 2f19 ^ 1232

    // Output is base XOR difference indexed by 'a'
    assign q = base ^ diff_lut[a];

endmodule