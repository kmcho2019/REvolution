module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // Split LUT into two smaller ROMs of 8 bits each for better synthesis optimization
    wire [7:0] lut_low [0:7];
    wire [7:0] lut_high [0:7];

    assign lut_low[0]  = 8'h32;  // lower byte of 0x1232
    assign lut_high[0] = 8'h12;  // upper byte of 0x1232

    assign lut_low[1]  = 8'he0;  // 0xaee0
    assign lut_high[1] = 8'hae;

    assign lut_low[2]  = 8'hd4;  // 0x27d4
    assign lut_high[2] = 8'h27;

    assign lut_low[3]  = 8'h0e;  // 0x5a0e
    assign lut_high[3] = 8'h5a;

    assign lut_low[4]  = 8'h66;  // 0x2066
    assign lut_high[4] = 8'h20;

    assign lut_low[5]  = 8'hce;  // 0x64ce
    assign lut_high[5] = 8'h64;

    assign lut_low[6]  = 8'h26;  // 0xc526
    assign lut_high[6] = 8'hc5;

    assign lut_low[7]  = 8'h19;  // 0x2f19
    assign lut_high[7] = 8'h2f;

    assign q = {lut_high[a], lut_low[a]};

endmodule