module TopModule (
    input  [3:0] x,
    output      f
);

    // K-map values indexed by x from 0 to 15:
    // bit position = input value
    // Values based on the K-map (d = 0):
    // x:    f
    // 0000: d=0
    // 0001: 0
    // 0010: d=0
    // 0011: d=0
    // 0100: 0
    // 0101: d=0
    // 0110: 1
    // 0111: 0
    // 1000: 1
    // 1001: 1
    // 1010: 0
    // 1011: d=0
    // 1100: 1
    // 1101: 1
    // 1110: 0
    // 1111: 0

    // Encoding these in a 16-bit vector, bit 0 corresponds to input 0000,
    // bit 15 corresponds to input 1111:
    // bits: f = 16'b0000110011000110;
    // Let's map carefully:

    // Input (x) : f (bit)
    // 0000 (0) : 0 -> bit 0
    // 0001 (1) : 0 -> bit 1
    // 0010 (2) : 0 -> bit 2
    // 0011 (3) : 0 -> bit 3
    // 0100 (4) : 0 -> bit 4
    // 0101 (5) : 0 -> bit 5
    // 0110 (6) : 1 -> bit 6
    // 0111 (7) : 0 -> bit 7
    // 1000 (8) : 1 -> bit 8
    // 1001 (9) : 1 -> bit 9
    // 1010 (10): 0 -> bit 10
    // 1011 (11): 0 -> bit 11
    // 1100 (12): 1 -> bit 12
    // 1101 (13): 1 -> bit 13
    // 1110 (14): 0 -> bit 14
    // 1111 (15): 0 -> bit 15

    // So the vector is:
    // bit15-bit0 = 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0 0
    // Actually in hex: bits 15..0 = 0b 0001100110000000 = 0x1980
    // Wait carefully:

    // Let's write bits in order (LSB on right = bit 0)
    // bit15 bit14 bit13 bit12 bit11 bit10 bit9 bit8 bit7 bit6 bit5 bit4 bit3 bit2 bit1 bit0
    //  0     0    1     1    0    0   1   1   0   0    0   0  0   0  0   0
    // This doesn't match our bits, let's list bits bit0 to bit15 explicitly:

    // bit0 = 0 (x=0000)
    // bit1 = 0 (x=0001)
    // bit2 = 0 (x=0010)
    // bit3 = 0 (x=0011)
    // bit4 = 0 (x=0100)
    // bit5 = 0 (x=0101)
    // bit6 = 1 (x=0110)
    // bit7 = 0 (x=0111)
    // bit8 = 1 (x=1000)
    // bit9 = 1 (x=1001)
    // bit10= 0 (x=1010)
    // bit11= 0 (x=1011)
    // bit12= 1 (x=1100)
    // bit13= 1 (x=1101)
    // bit14= 0 (x=1110)
    // bit15= 0 (x=1111)

    // Bits from bit15 down to bit0 = 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 is incorrect.
    // The correct bits (bit15 downto bit0):
    // 15:0
    // 15:0
    // 14:0
    // 13:1
    // 12:1
    // 11:0
    // 10:0
    // 9: 1
    // 8: 1
    // 7: 0
    // 6: 1
    // 5: 0
    // 4: 0
    // 3: 0
    // 2: 0
    // 1: 0
    // 0: 0

    // Let's write bits from bit15 to bit0 as a string:
    // bit15=0
    // bit14=0
    // bit13=1
    // bit12=1
    // bit11=0
    // bit10=0
    // bit9= 1
    // bit8= 1
    // bit7= 0
    // bit6= 1
    // bit5= 0
    // bit4= 0
    // bit3= 0
    // bit2= 0
    // bit1= 0
    // bit0= 0

    // So bits = 16'b0011001101000000 = 0x3340

    // Verify in hex:
    // 0011 0011 0100 0000
    //  3    3    4    0

    // Final constant vector: 16'h3340

    wire [15:0] f_map = 16'h3340;

    assign f = f_map[x];

endmodule