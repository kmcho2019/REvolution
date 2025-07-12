module TopModule(
    input  [3:0] x,
    output      f
);
    // Reorder input bits to match K-map indexing: addr = {x[2], x[3], x[0], x[1]}
    wire [3:0] addr = {x[2], x[3], x[0], x[1]};
    
    // K-map values for f in order of addr from 0 to 15:
    // From the map:
    // addr:  f
    // 0:00 00 -> f=1
    // 1:00 01 -> 0
    // 2:00 11 -> 0
    // 3:00 10 -> 1
    // 4:01 00 -> 0
    // 5:01 01 -> 0
    // 6:01 11 -> 0
    // 7:01 10 -> 0
    // 8:11 00 -> 1
    // 9:11 01 -> 1
    //10:11 11 -> 1
    //11:11 10 -> 0
    //12:10 00 -> 1
    //13:10 01 -> 1
    //14:10 11 -> 0
    //15:10 10 -> 1

    // So bits of lut indexed by addr: from bit0=addr=0 to bit15=addr=15
    // bit value vector: 1 0 0 1  0 0 0 0  1 1 1 0  1 1 0 1
    // Binary literal: 16'b1011000111001001 reversed to match LSB=addr0:
    // Actually, bit0 (LSB) = addr=0 = 1, bit1=0, bit2=0, bit3=1,...
    // Write explicitly:
    localparam [15:0] lut = 16'b101101110001001;
    // To avoid confusion, define bits explicitly:

    // Let's declare the LUT properly (bit 0 corresponds to addr=0)
    // Using the bit order: bit 15 - addr=15, bit0 - addr=0
    // Assembling bit vector from addr=15 down to addr=0:
    // addr: f
    // 15:1
    // 14:0
    // 13:1
    // 12:1
    // 11:0
    // 10:1
    // 9:1
    // 8:1
    // 7:0
    // 6:0
    // 5:0
    // 4:0
    // 3:1
    // 2:0
    // 1:0
    // 0:1
    // Bit order: 15 to 0: 1 0 1 1 0 1 1 1 0 0 0 0 1 0 0 1

    localparam [15:0] LUT = 16'b1011011100001001;

    assign f = LUT[addr];
endmodule