module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire [3:0] idx = {a, b, c, d};

// 16-bit LUT representing the K-map output, indexed by abcd = {a,b,c,d}
// The order of bits is such that idx=0 corresponds to input 0000 and idx=15 to 1111.
// Based on the K-map, mapping is:
// cd\ab  00  01  11  10
// 00      1   1   0   1    -> indices: 0000=0,0001=1,0011=3,0010=2
// 01      1   0   0   1    -> indices: 0100=4,0101=5,0111=7,0110=6
// 11      0   1   1   1    -> indices: 1100=12,1101=13,1111=15,1110=14
// 10      1   1   0   0    -> indices: 1000=8,1001=9,1011=11,1010=10
//
// Construct bit vector in order of idx from 15 downto 0:
// idx:15(1111) = 1
// idx:14(1110) = 1
// idx:13(1101) = 1
// idx:12(1100) = 0
// idx:11(1011) = 0
// idx:10(1010) = 0
// idx:9 (1001) = 1
// idx:8 (1000) = 1
// idx:7 (0111) = 0
// idx:6 (0110) = 1
// idx:5 (0101) = 0
// idx:4 (0100) = 1
// idx:3 (0011) = 0
// idx:2 (0010) = 1
// idx:1 (0001) = 1
// idx:0 (0000) = 1
//
// So bit vector from idx=15 to idx=0 is:
// 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
//  1  1  1  0  0  0  1  1  0  1  0  1  0  1  1  1
// In hex: 1110 0011 0110 1011 = 0xE36B

localparam [15:0] LUT = 16'hE36B;

assign out = LUT[idx];

endmodule