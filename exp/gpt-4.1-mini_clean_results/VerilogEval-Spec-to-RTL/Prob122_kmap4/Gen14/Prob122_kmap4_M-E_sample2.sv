module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Address formed as {a,b,c,d} = 4-bit input to index LUT
    wire [3:0] addr = {a, b, c, d};

    // LUT: bit position corresponds to input combination addr,
    // bit value corresponds to output
    // Karnaugh map flattened by rows (cd), columns (ab)
    // Map input order: (a,b,c,d) = {a,b,c,d} 
    // To match cd(2 bits) as MSB for rows, and ab for columns, we'll reorder addr bits as {c,d,a,b}
    // The Karnaugh map given:
    // cd\ab 00 01 11 10
    // 00: 0  1  0  1
    // 01: 1  0  1  0
    // 11: 0  1  0  1
    // 10: 1  0  1  0
    //
    // Flattening rows in order cd=00..11, columns ab=00..11 (using Gray code is not specified)
    // To use as address, we take addr = {c,d,a,b}
    //
    // Let's build the LUT with bits [15:0] = outputs for addr=0..15, addr={c,d,a,b}:
    // addr | c d a b | output
    //   0  | 0 0 0 0 | cd=00, ab=00 => 0
    //   1  | 0 0 0 1 | cd=00, ab=01 => 1
    //   2  | 0 0 1 0 | cd=00, ab=10 => 1
    //   3  | 0 0 1 1 | cd=00, ab=11 => 0
    //   4  | 0 1 0 0 | cd=01, ab=00 => 1
    //   5  | 0 1 0 1 | cd=01, ab=01 => 0
    //   6  | 0 1 1 0 | cd=01, ab=10 => 0
    //   7  | 0 1 1 1 | cd=01, ab=11 => 1
    //   8  | 1 0 0 0 | cd=10, ab=00 => 1
    //   9  | 1 0 0 1 | cd=10, ab=01 => 0
    //  10  | 1 0 1 0 | cd=10, ab=10 => 1
    //  11  | 1 0 1 1 | cd=10, ab=11 => 0
    //  12  | 1 1 0 0 | cd=11, ab=00 => 0
    //  13  | 1 1 0 1 | cd=11, ab=01 => 1
    //  14  | 1 1 1 0 | cd=11, ab=10 => 1
    //  15  | 1 1 1 1 | cd=11, ab=11 => 0
    //
    // Encoding these outputs as a 16-bit value:
    // bit  0 = addr 0 = 0
    // bit  1 = addr 1 = 1
    // bit  2 = addr 2 = 1
    // bit  3 = addr 3 = 0
    // bit  4 = addr 4 = 1
    // bit  5 = addr 5 = 0
    // bit  6 = addr 6 = 0
    // bit  7 = addr 7 = 1
    // bit  8 = addr 8 = 1
    // bit  9 = addr 9 = 0
    // bit 10 = addr 10= 1
    // bit 11 = addr 11= 0
    // bit 12 = addr 12= 0
    // bit 13 = addr 13= 1
    // bit 14 = addr 14= 1
    // bit 15 = addr 15= 0
    //
    // Binary: 0b 0 1 1 0  1 0 0 1  1 0 1 0  0 1 1 0 (from bit15 to bit0)
    // LSB is addr0, so:
    // bits: [15..0] = 0b0110100110100110
    //
    // Hex: 0x6996

    localparam [15:0] LUT = 16'h6996;

    // Compose address in the order {c,d,a,b}
    wire [3:0] lut_addr = {c, d, a, b};

    assign out = LUT[lut_addr];
endmodule