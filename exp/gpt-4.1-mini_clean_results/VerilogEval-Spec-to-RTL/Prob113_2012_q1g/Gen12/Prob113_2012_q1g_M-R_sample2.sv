module TopModule(
    input  [3:0] x,
    output f
);
    // Define a 16-bit constant vector where each bit corresponds to f for inputs 0..15
    // Map inputs to bits according to x = {x[3], x[2], x[1], x[0]}
    // Since row = {x[2], x[3]} and col = {x[0], x[1]}, the K-map order differs
    // But here we store f for input x as a vector indexed by x directly.

    // Bits index: x[3]x[2]x[1]x[0] = 4'bxxxx = index
    // We'll set bits for inputs where f=1:
    // From the K-map, enumerate all x values for f=1:

    // K-map rows: x[2]x[3], cols: x[0]x[1]
    // f=1 cells at (row,col):
    // (0,0,0,0) => x= {x[3], x[2], x[1], x[0]} = {0,x[2],x[1],x[0]}
    // Let's explicitly list input patterns with f=1:

    // Enumerate all x in 0..15:
    // For each, compute row = {x[2], x[3]}, col = {x[0], x[1]}
    // Check if the corresponding cell in K-map is 1:

    // x= 0b0000 (0): x[3]=0,x[2]=0,x[1]=0,x[0]=0
    // row={x[2],x[3]}={0,0}=00, col={x[0],x[1]}={0,0}=00 => K-map(00,00)=1 => bit0=1

    // x= 0b0001 (1): {0,0,0,1} col= {1,0}=01 => K-map(00,01)=0 => bit1=0
    // x= 0b0010 (2): {0,0,1,0} col={0,1}=10 => K-map(00,10)=1 => bit2=1
    // x= 0b0011 (3): {0,0,1,1} col={1,1}=11 => K-map(00,11)=0 => bit3=0
    // x= 0b0100 (4): {0,1,0,0} row={1,0}=10, col={0,0}=00 K-map(10,00)=1 => bit4=1
    // x= 0b0101 (5): row=10, col=01 K-map(10,01)=1 => bit5=1
    // x= 0b0110 (6): row=10, col=10 K-map(10,10)=1 => bit6=1
    // x= 0b0111 (7): row=10, col=11 K-map(10,11)=0 => bit7=0
    // x= 0b1000 (8): row={0,1}=01 col=00 K-map(01,00)=0 => bit8=0
    // x= 0b1001 (9): row=01 col=01 K-map(01,01)=0 => bit9=0
    // x= 0b1010 (10): row=01 col=10 K-map(01,10)=0 => bit10=0
    // x= 0b1011 (11): row=01 col=11 K-map(01,11)=0 => bit11=0
    // x= 0b1100 (12): row=11 col=00 K-map(11,00)=1 => bit12=1
    // x= 0b1101 (13): row=11 col=01 K-map(11,01)=1 => bit13=1
    // x= 0b1110 (14): row=11 col=10 K-map(11,10)=0 => bit14=0
    // x= 0b1111 (15): row=11 col=11 K-map(11,11)=1 => bit15=1

    // So the vector is bits indexed from LSB (bit0) = x=0 to MSB(bit15) = x=15:
    // bit15 ... bit0 = 1 (15), 0(14), 1(13), 1(12), 0(11), 0(10), 0(9), 0(8),
    //                0(7), 1(6), 1(5), 1(4), 0(3), 1(2), 0(1), 1(0)
    // Binary: bit15..0 = 1 0 1 1 0 0 0 0 0 1 1 1 0 1 0 1
    // Let's write this binary number in hex:
    // Bits: 15..12 = 1011 = B
    //       11..8  = 0000 = 0
    //       7..4   = 0111 = 7
    //       3..0   = 0101 = 5
    // So 16-bit vector = 16'hB075

    localparam [15:0] LUT = 16'hB075;

    assign f = LUT[x];

endmodule