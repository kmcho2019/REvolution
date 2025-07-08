module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Map inputs to indices for convenience
    // Row index = {c,d}, col index = {a,b}
    // Truth table: 
    // cd\ab 00 01 11 10
    // 00    1  1  0  1
    // 01    1  0  0  1
    // 11    0  1  1  1
    // 10    1  1  0  0

    wire [3:0] row = {c, d};
    wire [3:0] col = {a, b};

    // Using a combinational lookup with a case statement on {c,d,a,b}
    wire [3:0] cd = {c,d};
    wire [3:0] ab = {a,b};

    // Evaluate output using a combinational expression from the map
    // We'll implement as a 16-bit lookup from {c,d,a,b}
    wire [15:0] lut = 16'b1101_1001_0111_1100;
    // Let's double check bit ordering:
    // Index = {c,d,a,b} as bits: c is MSB, b is LSB
    // For each input combination cdab:
    // cdab = 4 bits, index from 0 to 15:
    // 0 = 0000: c=0,d=0,a=0,b=0 => output=1 (from map cd=00, ab=00) => lut[0] = 1
    // 1 = 0001: c=0,d=0,a=0,b=1 => output=1 (cd=00, ab=01) => lut[1] = 1
    // 2 = 0010: c=0,d=0,a=1,b=0 => output=1 (cd=00, ab=10) => lut[2] = 1
    // 3 = 0011: c=0,d=0,a=1,b=1 => output=0 (cd=00, ab=11) => lut[3] = 0
    // 4 = 0100: c=0,d=1,a=0,b=0 => output=1 (cd=01, ab=00) => lut[4] = 1
    // 5 = 0101: c=0,d=1,a=0,b=1 => output=0 (cd=01, ab=01) => lut[5] = 0
    // 6 = 0110: c=0,d=1,a=1,b=0 => output=1 (cd=01, ab=10) => lut[6] = 1
    // 7 = 0111: c=0,d=1,a=1,b=1 => output=0 (cd=01, ab=11) => lut[7] = 0
    // 8 = 1000: c=1,d=0,a=0,b=0 => output=1 (cd=10, ab=00) => lut[8] = 1
    // 9 = 1001: c=1,d=0,a=0,b=1 => output=1 (cd=10, ab=01) => lut[9] = 1
    // 10=1010: c=1,d=0,a=1,b=0 => output=0 (cd=10, ab=10) => lut[10]=0
    // 11=1011: c=1,d=0,a=1,b=1 => output=0 (cd=10, ab=11) => lut[11]=0
    // 12=1100: c=1,d=1,a=0,b=0 => output=0 (cd=11, ab=00) => lut[12]=0
    // 13=1101: c=1,d=1,a=0,b=1 => output=1 (cd=11, ab=01) => lut[13]=1
    // 14=1110: c=1,d=1,a=1,b=0 => output=1 (cd=11, ab=10) => lut[14]=1
    // 15=1111: c=1,d=1,a=1,b=1 => output=1 (cd=11, ab=11) => lut[15]=1
    // So the bits in order from 15 down to 0:
    // lut = 1110_1100_0110_1111 (binary)
    // which is 16'b1110110001101111
    // But we want lut[0] = output at 0000, so the LSB is bit 0 = output for 0000
    // So we set lut = 16'b1110110001101111
    // Let's write it explicitly for clarity
    localparam [15:0] LUT = 16'b1110110001101111;

    wire [3:0] idx = {c,d,a,b};
    assign out = LUT[idx];

endmodule