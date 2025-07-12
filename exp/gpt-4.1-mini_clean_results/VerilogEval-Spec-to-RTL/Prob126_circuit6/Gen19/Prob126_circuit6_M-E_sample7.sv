module TopModule (
    input  [2:0] a,
    output [15:0] q
);

    // ROM for lower two bits of 'a' (4 entries)
    wire [15:0] low_rom [0:3];
    assign low_rom[0] = 16'h1232;
    assign low_rom[1] = 16'haee0;
    assign low_rom[2] = 16'h27d4;
    assign low_rom[3] = 16'h5a0e;

    // ROM for upper bit of 'a' (2 entries)
    wire [15:0] high_rom [0:1];
    assign high_rom[0] = 16'h0000;
    assign high_rom[1] = 16'h3454;

    // Combinational output is XOR of the two ROM outputs
    assign q = low_rom[a[1:0]] ^ high_rom[a[2]];

endmodule