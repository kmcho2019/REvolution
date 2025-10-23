module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Concatenate inputs as address: {a,b,c,d}
    wire [3:0] addr = {a,b,c,d};

    // Define 16-bit LUT corresponding to the K-map truth table.
    // Mapping inputs to output:
    // Index bits: a b c d
    // Order: from 0 to 15
    // Use K-map values to set bit positions:
    // K-map is defined for cd (rows) and ab (columns):
    // ab=00 b=0 a=0, ab=01 b=0 a=1, ab=11 b=1 a=1, ab=10 b=1 a=0
    // We map index bits as a,b,c,d for LUT indexing:
    // So bit index = (a<<3) + (b<<2) + (c<<1) + d
    // We assign output values accordingly:

    // Let's map each minterm (a,b,c,d):
    // For each input combination, determine output:

    // (a,b,c,d) : out
    // 0000 (0): a=0,b=0,c=0,d=0 -> K-map cd=00, ab=00 -> 1
    // 0001 (1): 0,0,0,1 cd=00,ab=01 -> 1
    // 0010 (2): 0,0,1,0 cd=10,ab=00 -> 1
    // 0011 (3): 0,0,1,1 cd=11,ab=00 -> 0
    // 0100 (4): 0,1,0,0 cd=00,ab=10 -> 1
    // 0101 (5): 0,1,0,1 cd=01,ab=10 -> 1
    // 0110 (6): 0,1,1,0 cd=10,ab=10 -> 0
    // 0111 (7): 0,1,1,1 cd=11,ab=10 -> 0
    // 1000 (8): 1,0,0,0 cd=00,ab=11 -> 0
    // 1001 (9): 1,0,0,1 cd=01,ab=11 -> 0
    // 1010 (10):1,0,1,0 cd=10,ab=11 -> 0
    // 1011 (11):1,0,1,1 cd=11,ab=11 -> 1
    // 1100 (12):1,1,0,0 cd=00,ab=01 -> 1
    // 1101 (13):1,1,0,1 cd=01,ab=01 -> 0
    // 1110 (14):1,1,1,0 cd=10,ab=01 -> 1
    // 1111 (15):1,1,1,1 cd=11,ab=01 -> 1

    // Create the 16-bit LUT accordingly, bit0 = index0 = a=0,b=0,c=0,d=0
    localparam [15:0] LUT = 16'b1110100010001101;
    // Bit mapping from above:
    // bit15 = index 15 = 1
    // bit14 = index 14 = 1
    // bit13 = index 13 = 0
    // bit12 = index 12 = 1
    // bit11 = index 11 = 1
    // bit10 = index 10 = 0
    // bit9  = index 9  = 0
    // bit8  = index 8  = 0
    // bit7  = index 7  = 0
    // bit6  = index 6  = 0
    // bit5  = index 5  = 1
    // bit4  = index 4  = 1
    // bit3  = index 3  = 0
    // bit2  = index 2  = 1
    // bit1  = index 1  = 1
    // bit0  = index 0  = 1

    assign out = LUT[addr];

endmodule