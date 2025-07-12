module TopModule(
    input  [3:0] x,
    output      f
);
    // Map input bits as before to form address:
    wire [3:0] addr = {x[2], x[3], x[0], x[1]};

    // Lookup table encoding function f for each addr (bit corresponds to addr)
    // Corresponding to Karnaugh map entries with 'd' treated as 0:
    // Bit index: addr
    // Bits: f = 16'b{f[15], f[14], ..., f[0]}
    // From previous solution:
    // addr:  f
    // 0000:0, 0001:0, 0010:0, 0011:0,
    // 0100:0, 0101:0, 0110:0, 0111:1,
    // 1000:1, 1001:1, 1010:0, 1011:0,
    // 1100:1, 1101:1, 1110:0, 1111:0
    localparam [15:0] LUT = 16'b0011001100000000;
    // To verify:
    // Index 0 (0000): 0 (rightmost bit)
    // Index 7 (0111): 1 (bit 7)
    // Index 8 (1000): 1 (bit 8)
    // Index 12(1100):1 (bit 12)

    assign f = LUT[addr];
endmodule