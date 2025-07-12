module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Base pattern for a=0
    localparam [15:0] BASE = 16'h1232;

    // Masks showing bits different from BASE for each input 'a'
    // mask = q_val ^ BASE
    // Pre-calculated:
    // a=0: 1232 ^ 1232 = 0x0000
    // a=1: aee0 ^ 1232 = b4d2
    // a=2: 27d4 ^ 1232 = 3476
    // a=3: 5a0e ^ 1232 = 487c
    // a=4: 2066 ^ 1232 = 3114
    // a=5: 64ce ^ 1232 = 77fc
    // a=6: c526 ^ 1232 = d714
    // a=7: 2f19 ^ 1232 = 3c2b

    wire [15:0] mask_lut [0:7];
    assign mask_lut[0] = 16'h0000;
    assign mask_lut[1] = 16'hb4d2;
    assign mask_lut[2] = 16'h3476;
    assign mask_lut[3] = 16'h487c;
    assign mask_lut[4] = 16'h3114;
    assign mask_lut[5] = 16'h77fc;
    assign mask_lut[6] = 16'hd714;
    assign mask_lut[7] = 16'h3c2b;

    assign q = BASE ^ mask_lut[a];

endmodule