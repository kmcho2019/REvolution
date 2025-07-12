module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // We create a 16-bit constant representing the K-map entries,
    // indexed by {c,d,a,b} in that bit order (cdab).
    // Map each cell in the K-map:
    // cd\ab 00 01 11 10
    // 00: 1  1  0  1
    // 01: 1  0  0  1
    // 11: 0  1  1  1
    // 10: 1  1  0  0
    //
    // Index bits: c (MSB), d, a, b (LSB)
    // Let's assign bit0 = index 0 = 0000 = c=0 d=0 a=0 b=0
    // The 16 bits are bit15 (1111) down to bit0 (0000)
    //
    // We'll map the K-map entries to bit positions as:
    // index = c<<3 | d<<2 | a<<1 | b
    // value = K-map value at (cd)(ab)
    //
    // Build bit vector from bit15 down to bit0:
    // For each index from 0 to 15:
    // - Extract c,d,a,b bits
    // - Get corresponding value from K-map

    localparam [15:0] kmap =
        // cd=00 (c=0,d=0)
        (1<<0)  | // a=0,b=0 => 1
        (1<<1)  | // a=0,b=1 => 1
        (0<<2)  | // a=1,b=1 => 0
        (1<<3)  | // a=1,b=0 => 1
        // cd=01 (c=0,d=1)
        (1<<4)  | // a=0,b=0 => 1
        (0<<5)  | // a=0,b=1 => 0
        (0<<6)  | // a=1,b=1 => 0
        (1<<7)  | // a=1,b=0 => 1
        // cd=10 (c=1,d=0)
        (1<<8)  | // a=0,b=0 => 1
        (1<<9)  | // a=0,b=1 => 1
        (0<<10) | // a=1,b=1 => 0
        (0<<11) | // a=1,b=0 => 0
        // cd=11 (c=1,d=1)
        (0<<12) | // a=0,b=0 => 0
        (1<<13) | // a=0,b=1 => 1
        (1<<14) | // a=1,b=1 => 1
        (1<<15);  // a=1,b=0 => 1

    wire [3:0] index = {c, d, a, b};
    assign out = kmap[index];
endmodule