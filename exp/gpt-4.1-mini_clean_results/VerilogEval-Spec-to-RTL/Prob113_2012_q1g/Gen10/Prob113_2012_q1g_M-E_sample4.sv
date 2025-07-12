module TopModule(
    input  [3:0] x,
    output       f
);

// 16-bit LUT representing f for all 16 possible x values.
// The LSB corresponds to x = 0000, MSB to x = 1111.
// Values taken from the Karnaugh map rows (x[3]x[2] as high bits, x[1]x[0] as low bits):
// Row 00 (x[3]=0,x[2]=0): 1 0 0 1  -> bits for x=0000..0011
// Row 01 (x[3]=0,x[2]=1): 0 0 0 0
// Row 11 (x[3]=1,x[2]=1): 1 1 1 0
// Row 10 (x[3]=1,x[2]=0): 1 1 0 1
// Arranged in order of x from 0000 to 1111:

localparam [15:0] LUT = 16'b1110111100001001;

assign f = LUT[x];

endmodule