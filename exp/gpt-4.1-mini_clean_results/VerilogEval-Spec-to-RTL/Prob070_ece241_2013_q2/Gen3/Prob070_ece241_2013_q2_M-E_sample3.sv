module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Combine inputs into a 4-bit index: a is MSB, d is LSB
wire [3:0] idx = {a,b,c,d};

// 16-bit vector for outputs: index corresponds to input number from 0 to 15
// bit=1 if output should be 1, bit=0 if output should be 0
// As per specification:
// 1 for 2 (0010), 7 (0111), 15 (1111)
// 0 for 0,1,4,5,6,9,10,13,14
// 0 for 3,8,11,12 (never occur)
// Mapping bits: bit0 = output for input 0, bit1 for input 1, ..., bit15 for input 15
// So from LSB to MSB: bits[15:0] = bit for input decimal
localparam [15:0] LUT = 16'b10000001010000100;
// Let's verify:
// Index: Value
//  0:0, 1:0, 2:1, 3:0, 4:0, 5:0, 6:0, 7:1, 8:0, 9:0, 10:0, 11:0, 12:0, 13:0, 14:0, 15:1
//  So bits: bit0=0, bit1=0, bit2=1, bit3=0, bit4=0, bit5=0, bit6=0, bit7=1, bit8=0, bit9=0, bit10=0, bit11=0, bit12=0, bit13=0, bit14=0, bit15=1
// Written MSB to LSB: bit15=1 at MSB -> position 15 = leftmost
// The binary: bit15 down to bit0 = 1 0 0 0 0 0 0 1 0 1 0 0 0 0 1 0 (16 bits)

assign out_sop = LUT[idx];

// out_pos is minimum Product-of-Sums form, which equals to inverted outputs minimized.
// Here, just assign as inverse of out_sop as inputs outside the domain don't occur.
assign out_pos = ~out_sop;

endmodule