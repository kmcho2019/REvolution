module TopModule (
    input  [3:0] x,
    output      f
);

// Mapping:
// row = x[3]x[0]
// col = x[1]x[2]
// Index = {x[3], x[0], x[1], x[2]} (4 bits)
// K-map given:
//             x[1]x[2]
// x[3]x[4]  00  01  11  10
//     00 | d | 0 | d | d |  -> row=00 => x[3]=0,x[0]=0
//     01 | 0 | d | 1 | 0 |  -> row=01 => x[3]=0,x[0]=1
//     11 | 1 | 1 | d | d |  -> row=11 => x[3]=1,x[0]=1
//     10 | 1 | 1 | 0 | d |  -> row=10 => x[3]=1,x[0]=0
//
// We'll assign don't-cares (d) as 0 to keep it simple.

// Construct LUT bits with index from 0 to 15 (binary 0000 to 1111)
// Index bits: {x3, x0, x1, x2} = bit3 bit2 bit1 bit0

// For each index:
// 0000 (x3=0,x0=0,x1=0,x2=0): row=00 col=00 => d=0
// 0001 (x3=0,x0=0,x1=0,x2=1): row=00 col=01 => 0
// 0010 (x3=0,x0=0,x1=1,x2=0): row=00 col=10 => d=0
// 0011 (x3=0,x0=0,x1=1,x2=1): row=00 col=11 => d=0
// 0100 (x3=0,x0=1,x1=0,x2=0): row=01 col=00 => 0
// 0101 (x3=0,x0=1,x1=0,x2=1): row=01 col=01 => d=0
// 0110 (x3=0,x0=1,x1=1,x2=0): row=01 col=10 => 0
// 0111 (x3=0,x0=1,x1=1,x2=1): row=01 col=11 => 1
// 1000 (x3=1,x0=0,x1=0,x2=0): row=10 col=00 => 1
// 1001 (x3=1,x0=0,x1=0,x2=1): row=10 col=01 => 1
// 1010 (x3=1,x0=0,x1=1,x2=0): row=10 col=10 => 0
// 1011 (x3=1,x0=0,x1=1,x2=1): row=10 col=11 => d=0
// 1100 (x3=1,x0=1,x1=0,x2=0): row=11 col=00 => 1
// 1101 (x3=1,x0=1,x1=0,x2=1): row=11 col=01 => 1
// 1110 (x3=1,x0=1,x1=1,x2=0): row=11 col=10 => d=0
// 1111 (x3=1,x0=1,x1=1,x2=1): row=11 col=11 => d=0

localparam [15:0] LUT = 16'b0001001100110000;

assign f = LUT[{x[3], x[0], x[1], x[2]}];

endmodule