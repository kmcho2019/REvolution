module TopModule(
    input  [3:0] x,
    output       f
);

// 16-bit constant representing f for inputs 0 to 15 based on Karnaugh map
// Index is x[3:0] with x[3] as MSB, x[0] as LSB
// Bits set to 1 for minterms where f=1

// Map from given Karnaugh map (x3 x2 x1 x0):
// x3 x2 x1 x0: f
// 0000 (0) = 1
// 0001 (1) = 0
// 0010 (2) = 1
// 0011 (3) = 0
// 0100 (4) = 0
// 0101 (5) = 0
// 0110 (6) = 0
// 0111 (7) = 0
// 1000 (8) = 1
// 1001 (9) = 1
// 1010 (10)= 1
// 1011 (11)= 0
// 1100 (12)= 1
// 1101 (13)= 0
// 1110 (14)= 0
// 1111 (15)= 1

// Binary: bit 15 down to 0
// bit15 = f(15) = 1
// bit14 = f(14) = 0
// bit13 = f(13) = 0
// bit12 = f(12) = 1
// bit11 = f(11) = 0
// bit10 = f(10) = 1
// bit9  = f(9)  = 1
// bit8  = f(8)  = 1
// bit7  = f(7)  = 0
// bit6  = f(6)  = 0
// bit5  = f(5)  = 0
// bit4  = f(4)  = 0
// bit3  = f(3)  = 0
// bit2  = f(2)  = 1
// bit1  = f(1)  = 0
// bit0  = f(0)  = 1

// So vector = 16'b10010111100000101 but note that in Verilog the leftmost bit is MSB (bit 15)

// Reorder to binary:
// bits: 15 down to 0 = 1 0 0 1 0 1 1 1 1 0 0 0 0 0 1 0 1 ? This is 17 bits - double-check

// Counting bits precisely:
// bit15 = f(15) = 1
// bit14 = f(14) = 0
// bit13 = f(13) = 0
// bit12 = f(12) = 1
// bit11 = f(11) = 0
// bit10 = f(10) = 1
// bit9  = f(9)  = 1
// bit8  = f(8)  = 1
// bit7  = f(7)  = 0
// bit6  = f(6)  = 0
// bit5  = f(5)  = 0
// bit4  = f(4)  = 0
// bit3  = f(3)  = 0
// bit2  = f(2)  = 1
// bit1  = f(1)  = 0
// bit0  = f(0)  = 1

// So bits from MSB to LSB: 1 0 0 1 0 1 1 1 0 0 0 0 0 1 0 1

// Let's write as hex:
// bit15..bit12 = 1001 = 9
// bit11..bit8  = 0111 = 7
// bit7..bit4   = 0000 = 0
// bit3..bit0   = 0101 = 5

// So vector = 16'h9705

wire [15:0] lut = 16'h9705;

assign f = lut[x];

endmodule