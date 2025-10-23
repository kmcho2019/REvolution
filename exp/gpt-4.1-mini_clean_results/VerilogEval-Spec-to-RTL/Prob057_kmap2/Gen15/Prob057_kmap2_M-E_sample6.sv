module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Combine inputs into a 4-bit index: order is {c,d,b,a} to match K-map coordinates
    // K-map order is ab (columns), cd (rows), but here we index as: index = {c,d,b,a}
    // Let's carefully map inputs to index:
    // Given K-map:
    //           ab
    // cd   00  01  11  10
    // 00 | 1 | 1 | 0 | 1 |
    // 01 | 1 | 0 | 0 | 1 |
    // 11 | 0 | 1 | 1 | 1 |
    // 10 | 1 | 1 | 0 | 0 |

    // The order of input bits to form index is important.
    // Let's define index = {c,d,b,a} to convert cd and ab to bits:
    // The rows (cd) correspond to c and d, columns (ab) to a and b.
    // So, index = {c,d,b,a}

    // Let's build the 16-bit vector representing all outputs for input combinations:
    // Enumerate inputs from 0 to 15 in order: c d b a

    // We'll assign each bit according to K-map cell output for corresponding inputs.

    // Create a vector where bit 0 corresponds to inputs c=0,d=0,b=0,a=0
    // So bit indexing: index = c*8 + d*4 + b*2 + a*1

    // K-map cells:
    // cd=00 (c=0,d=0)
    // ab=00 (a=0,b=0) => bit index 0*8+0*4+0*2+0*1=0: output=1
    // ab=01 (a=1,b=0) => index= c*8 + d*4 + b*2 + a = 0*8+0*4+0*2+1=1: output=1
    // ab=11 (a=1,b=1) => 0*8+0*4+1*2+1=3: output=0
    // ab=10 (a=0,b=1) => 0*8+0*4+1*2+0=2: output=1

    // cd=01 (c=0,d=1)
    // ab=00 (a=0,b=0) => 0*8+1*4+0*2+0=4: output=1
    // ab=01 (a=1,b=0) => 0*8+1*4+0*2+1=5: output=0
    // ab=11 (a=1,b=1) => 0*8+1*4+1*2+1=7: output=0
    // ab=10 (a=0,b=1) => 0*8+1*4+1*2+0=6: output=1

    // cd=11 (c=1,d=1)
    // ab=00 => 1*8+1*4+0*2+0=12: output=0
    // ab=01 => 1*8+1*4+0*2+1=13: output=1
    // ab=11 => 1*8+1*4+1*2+1=15: output=1
    // ab=10 => 1*8+1*4+1*2+0=14: output=1

    // cd=10 (c=1,d=0)
    // ab=00 => 1*8+0*4+0*2+0=8: output=1
    // ab=01 => 1*8+0*4+0*2+1=9: output=1
    // ab=11 => 1*8+0*4+1*2+1=11: output=0
    // ab=10 => 1*8+0*4+1*2+0=10: output=0

    // Construct 16-bit vector accordingly, LSB is index=0
    // bits [15:0]:
    // Index: Value
    //  0:1
    //  1:1
    //  2:1
    //  3:0
    //  4:1
    //  5:0
    //  6:1
    //  7:0
    //  8:1
    //  9:1
    // 10:0
    // 11:0
    // 12:0
    // 13:1
    // 14:1
    // 15:1

    wire [15:0] lookup = 16'b1110_1101_0010_1111;
    // This is bit15 to bit0; double-check bits:
    // bit15 (index=15):1
    // bit14 (14):1
    // bit13 (13):1
    // bit12 (12):0
    // bit11 (11):0
    // bit10 (10):0
    // bit9  (9):1
    // bit8  (8):1
    // bit7  (7):0
    // bit6  (6):1
    // bit5  (5):0
    // bit4  (4):1
    // bit3  (3):0
    // bit2  (2):1
    // bit1  (1):1
    // bit0  (0):1

    wire [3:0] idx = {c,d,b,a};

    assign out = lookup[idx];
endmodule