module TopModule (
    input  [3:0] x, // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1 (problem notation)
    output       f
);

    // Define a 16-bit lookup table representing f for each input x[3:0].
    // Indexing as x[3:0] with x[3]=MSB, x[0]=LSB.
    // Using the Karnaugh map:
    // For each x, if cell is 1 -> LUT bit = 1
    // If cell is 0 or d -> LUT bit = 0 (don't-cares chosen as 0)
    // Map each x (4 bits) to f according to the map:
    //
    // Let's enumerate all 16 inputs x[3:0], where bits correspond to x4 x3 x2 x1:
    //
    // To align with problem notation, inputs correspond to x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1.
    //
    // We'll convert the Karnaugh map entries:
    //
    // For clarity, produce the f for each input:
    // Input: x4 x3 x2 x1 (bits)
    // Value f:
    // x = 0000 (x4=0,x3=0,x2=0,x1=0) => map cell (x3x4=00,row, x1x2=00,col):
    //   row=00 col=00 => d => assign 0
    // x = 0001 (0001) x4=0,x3=0,x2=0,x1=1
    //   row=00, col=01 => 0
    // x = 0010 (0010) x4=0,x3=0,x2=1,x1=0
    //   row=00, col=11 => d => 0
    // x = 0011 (0011) x4=0,x3=0,x2=1,x1=1
    //   row=00, col=10 => d => 0
    // x = 0100 (0100) x4=0,x3=1,x2=0,x1=0
    //   row=01, col=00 => 0
    // x = 0101 (0101) x4=0,x3=1,x2=0,x1=1
    //   row=01, col=01 => d => 0
    // x = 0110 (0110) x4=0,x3=1,x2=1,x1=0
    //   row=01, col=11 => 1
    // x = 0111 (0111) x4=0,x3=1,x2=1,x1=1
    //   row=01, col=10 => 0
    // x = 1000 (1000) x4=1,x3=0,x2=0,x1=0
    //   row=10, col=00 => 1
    // x = 1001 (1001) x4=1,x3=0,x2=0,x1=1
    //   row=10, col=01 => 1
    // x = 1010 (1010) x4=1,x3=0,x2=1,x1=0
    //   row=10, col=11 => 0
    // x = 1011 (1011) x4=1,x3=0,x2=1,x1=1
    //   row=10, col=10 => d => 0
    // x = 1100 (1100) x4=1,x3=1,x2=0,x1=0
    //   row=11, col=00 => 1
    // x = 1101 (1101) x4=1,x3=1,x2=0,x1=1
    //   row=11, col=01 => 1
    // x = 1110 (1110) x4=1,x3=1,x2=1,x1=0
    //   row=11, col=11 => d => 0
    // x = 1111 (1111) x4=1,x3=1,x2=1,x1=1
    //   row=11, col=10 => d => 0
    //
    // In binary order, bits 15 down to 0 correspond to inputs 1111 down to 0000:
    // Let's build the 16-bit value where LSB is input 0000:
    //
    // bit0 = input 0000 => 0
    // bit1 = 0001 => 0
    // bit2 = 0010 => 0
    // bit3 = 0011 => 0
    // bit4 = 0100 => 0
    // bit5 = 0101 => 0
    // bit6 = 0110 => 1
    // bit7 = 0111 => 0
    // bit8 = 1000 => 1
    // bit9 = 1001 => 1
    // bit10= 1010 => 0
    // bit11= 1011 => 0
    // bit12= 1100 => 1
    // bit13= 1101 => 1
    // bit14= 1110 => 0
    // bit15= 1111 => 0
    //
    // So the 16-bit LUT is: bits [15:0] = 0 0 0 1 1 0 1 1 0 0 0 0 0 0 0 0 (written in reverse order!)
    // Actually, from LSB to MSB: bit0..bit15 = 0 0 0 0 0 0 1 0 1 1 0 0 1 1 0 0 (read carefully)
    //
    // Wait, carefully:
    // bit0 = input 0 => 0
    // bit1 = 0
    // bit2 = 0
    // bit3 = 0
    // bit4 = 0
    // bit5 = 0
    // bit6 = 1  (input 6)
    // bit7 = 0
    // bit8 = 1  (input 8)
    // bit9 = 1  (input 9)
    // bit10=0
    // bit11=0
    // bit12=1 (input 12)
    // bit13=1 (input 13)
    // bit14=0
    // bit15=0
    //
    // So binary LUT = 16'b0011001100100000
    // Let's write bits from MSB to LSB (bit15 to bit0):
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
    //
    // So bits: 0 0 1 1 0 0 1 1 0 1 0 0 0 0 0 0
    // Which is 16'b0011001101000000 = 0x3340
    // Let's double-check:
    //
    // bit15=0x8000
    // bit14=0x4000
    // bit13=0x2000
    // bit12=0x1000
    // bit11=0x0800
    // bit10=0x0400
    // bit9= 0x0200
    // bit8= 0x0100
    // bit7= 0x0080
    // bit6= 0x0040
    // bit5= 0x0020
    // bit4= 0x0010
    // bit3= 0x0008
    // bit2= 0x0004
    // bit1= 0x0002
    // bit0= 0x0001
    //
    // Adding bits set:
    // bit13=1 => 0x2000
    // bit12=1 => 0x1000
    // bit9=1 => 0x0200
    // bit8=1 => 0x0100
    // bit6=1 => 0x0040
    //
    // Sum = 0x2000 + 0x1000 + 0x0200 + 0x0100 + 0x0040 = 0x3340
    //
    // Perfect.
    //
    // Thus LUT = 16'h3340

    wire [15:0] LUT = 16'h3340;

    assign f = LUT[x];

endmodule