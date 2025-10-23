module TopModule(
    input a,
    input b,
    input c,
    input d, // don't-care
    output out
);
    wire [3:0] idx;
    // Map inputs to index: idx = {c, d, a, b}
    assign idx = {c, d, a, b};

    // Define the output lookup table:
    // Index bit order: c d a b (MSB to LSB)
    // For each input combination, provide the output from K-map,
    // assigning don't-cares (d inputs) to zero for simplicity.
    // 16 bits: bit 0 corresponds to idx=0 (0000), bit 15 idx=15 (1111)
    // We'll define output bits accordingly:
    // From K-map and don't cares, filled with 0 for 'd' entries.
    // 
    // idx (c d a b): output
    // 0000: c=0 d=0 a=0 b=0 => K-map at cd=00, ab=00 => 0
    // 0001: c=0 d=0 a=0 b=1 => K-map 00, 01 => d => assign 0
    // 0010: c=0 d=0 a=1 b=0 => 00,10 => 1
    // 0011: c=0 d=0 a=1 b=1 => 00,11 => 1
    // 0100: c=0 d=1 a=0 b=0 => 01,00 => 0
    // 0101: c=0 d=1 a=0 b=1 => 01,01 => 0
    // 0110: c=0 d=1 a=1 b=0 => 01,10 => d => assign 0
    // 0111: c=0 d=1 a=1 b=1 => 01,11 => d => assign 0
    // 1000: c=1 d=0 a=0 b=0 => 10,00 => 0
    // 1001: c=1 d=0 a=0 b=1 => 10,01 => 1
    // 1010: c=1 d=0 a=1 b=0 => 10,10 => 1
    // 1011: c=1 d=0 a=1 b=1 => 10,11 => 1
    // 1100: c=1 d=1 a=0 b=0 => 11,00 => 0
    // 1101: c=1 d=1 a=0 b=1 => 11,01 => 1
    // 1110: c=1 d=1 a=1 b=0 => 11,10 => 1
    // 1111: c=1 d=1 a=1 b=1 => 11,11 => 1

    // Binary vector (bit15 ... bit0):
    // bit0 = idx=0 = 0
    // bit1 = 0
    // bit2 = 1
    // bit3 = 1
    // bit4 = 0
    // bit5 = 0
    // bit6 = 0
    // bit7 = 0
    // bit8 = 0
    // bit9 = 1
    // bit10= 1
    // bit11= 1
    // bit12= 0
    // bit13= 1
    // bit14= 1
    // bit15= 1
    //
    // 16-bit vector: 1110111100110000b

    wire [15:0] lut = 16'b1110111100110000;
    assign out = lut[idx];

endmodule