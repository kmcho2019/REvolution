module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Build a 16-bit vector where bit m corresponds to minterm m,
    // with m = {c,d,a,b} indexing: since columns = ab, rows = cd,
    // minterm index = cd*4 + ab
    // The K-map gives ones at minterms: 0,1,2,4,7,8,9,13,14,15
    // So bit vector is (bit 15 is MSB):
    // bit 15 = 1, bit14=1, bit13=1, bit12=0,
    // bit11=0, bit10=0, bit9=1, bit8=1,
    // bit7=1, bit6=0, bit5=0, bit4=1,
    // bit3=0, bit2=1, bit1=1, bit0=1

    wire [3:0] ab = {a,b};
    wire [3:0] cd = {c,d};
    wire [3:0] addr = (cd << 2) | ab; // cd*4 + ab

    // Define lookup table with ones at minterms given
    localparam [15:0] LUT = 16'b1110110010000111;

    assign out = LUT[addr];

endmodule