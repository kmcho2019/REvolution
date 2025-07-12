module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Precompute f for all 16 input combinations (x from 0 to 15)
    // Using original K-map mapping (Gray-coded row: x3 x4, column: x1 x2)
    // We find f by applying Gray-to-binary to indices manually:

    // Instead of converting, we enumerate all x and assign f:
    // For all x in [0..15], compute f based on Karnaugh map cell that (x3 x4) row Gray, (x1 x2) col Gray.

    // Let's define a function to get f[x]:

    // We know the K-map is:
    // row\col: 00 01 11 10  (col Gray: x1 x2)
    // 00:     d  0  d  d   (row Gray: x3 x4)
    // 01:     0  d  1  0
    // 11:     1  1  d  d
    // 10:     1  1  0  d

    // We map each input x = {x4, x3, x2, x1} to Gray row (x3,x4), Gray col (x1,x2):
    // Then find f

    // We construct a 16-bit LUT as a constant parameter:

    // Index: x4 x3 x2 x1 (bit3 .. bit0)
    // Value: f (1 or 0)

    // The 16 values (x from 0 to 15):
    // For clarity:

    // x=0  (0000) x4=0 x3=0 x2=0 x1=0: row Gray=00 col Gray=00 -> K-map(00,00)=d=0
    // x=1  (0001) 0 0 0 1: row=00 col=01 -> 0
    // x=2  (0010) 0 0 1 0: row=00 col=10 -> d=0
    // x=3  (0011) 0 0 1 1: row=00 col=11 -> d=0
    // x=4  (0100) 0 1 0 0: row=01 col=00 -> 0
    // x=5  (0101) 0 1 0 1: row=01 col=01 -> d=0
    // x=6  (0110) 0 1 1 0: row=01 col=10 -> 1
    // x=7  (0111) 0 1 1 1: row=01 col=11 -> 0
    // x=8  (1000) 1 0 0 0: row=10 col=00 -> 1
    // x=9  (1001) 1 0 0 1: row=10 col=01 -> 1
    // x=10 (1010) 1 0 1 0: row=10 col=10 -> 0
    // x=11 (1011) 1 0 1 1: row=10 col=11 -> d=0
    // x=12 (1100) 1 1 0 0: row=11 col=00 -> 1
    // x=13 (1101) 1 1 0 1: row=11 col=01 -> 1
    // x=14 (1110) 1 1 1 0: row=11 col=10 -> d=0
    // x=15 (1111) 1 1 1 1: row=11 col=11 -> d=0

    // Construct 16-bit vector (bit0 for x=0):
    // bit pos: 15 ... 0
    // Values: 0b
    // x15=0
    // x14=0
    // x13=1
    // x12=1
    // x11=0
    // x10=0
    // x9 =1
    // x8 =1
    // x7 =0
    // x6 =1
    // x5 =0
    // x4 =0
    // x3 =0
    // x2 =0
    // x1 =0
    // x0 =0

    // Binary: 0b0011001101000000 = 16'h3340

    // Let's double-check the bit order:
    // bit0: x=0 = 0
    // bit1: x=1 = 0
    // bit2: x=2 = 0
    // bit3: x=3 = 0
    // bit4: x=4 = 0
    // bit5: x=5 = 0
    // bit6: x=6 = 1
    // bit7: x=7 = 0
    // bit8: x=8 = 1
    // bit9: x=9 = 1
    // bit10:x=10=0
    // bit11:x=11=0
    // bit12:x=12=1
    // bit13:x=13=1
    // bit14:x=14=0
    // bit15:x=15=0

    // Binary vector bits: bit15..bit0 = 0 0 1 1 0 0 1 1 0 1 0 0 0 0 0 0
    // hex = 0x3340

    localparam [15:0] LUT = 16'h3340;

    assign f = LUT[x];

endmodule