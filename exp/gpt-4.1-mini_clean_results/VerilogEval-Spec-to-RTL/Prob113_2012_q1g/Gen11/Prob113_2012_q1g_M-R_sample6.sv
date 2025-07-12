module TopModule(
    input  [3:0] x,
    output f
);
    // The function f can be stored as a 16-bit constant where each bit corresponds to f value for x from 0 to 15.
    // According to the Karnaugh map, build the 16-bit vector with bits ordered by x[3:0]:
    // We'll map row = {x[2], x[3]}, col = {x[0], x[1]} to each index:
    // Index in vector = {x[3], x[2], x[1], x[0]} = x itself

    // Karnaugh map from problem:
    // row\col  00  01  11  10
    // 00       1   0   0   1
    // 01       0   0   0   0
    // 11       1   1   1   0
    // 10       1   1   0   1

    // For each combination of x[3:0]:
    // We'll compute f(x) and place bits in the vector accordingly, with index = {x[3],x[2],x[1],x[0]}:
    // For x=0 to 15:
    //  x3 x2 x1 x0 | row=x2 x3, col=x0 x1 | f
    //  0  0  0  0 | 0  0 ,0  0 | 1  (row 00 col 00)
    //  0  0  0  1 | 0  0 ,1  0 | 1  (row 00 col 10)
    //  0  0  1  0 | 0  0 ,0  1 | 0  (row 00 col 01)
    //  0  0  1  1 | 0  0 ,1  1 | 0  (row 00 col 11)
    //  0  1  0  0 | 1  0 ,0  0 | 1  (row 10 col 00)
    //  0  1  0  1 | 1  0 ,1  0 | 0  (row 10 col 10)
    //  0  1  1  0 | 1  0 ,0  1 | 1  (row 10 col 01)
    //  0  1  1  1 | 1  0 ,1  1 | 0  (row 10 col 11)
    //  1  0  0  0 | 0  1 ,0  0 | 0  (row 01 col 00)
    //  1  0  0  1 | 0  1 ,1  0 | 0  (row 01 col 10)
    //  1  0  1  0 | 0  1 ,0  1 | 0  (row 01 col 01)
    //  1  0  1  1 | 0  1 ,1  1 | 0  (row 01 col 11)
    //  1  1  0  0 | 1  1 ,0  0 | 1  (row 11 col 00)
    //  1  1  0  1 | 1  1 ,1  0 | 1  (row 11 col 10)
    //  1  1  1  0 | 1  1 ,0  1 | 1  (row 11 col 01)
    //  1  1  1  1 | 1  1 ,1  1 | 0  (row 11 col 11)

    // Vector bits from index 0 to 15: (bit0 = x=0)
    // Index : f
    // 0 : 1
    // 1 : 1
    // 2 : 0
    // 3 : 0
    // 4 : 1
    // 5 : 0
    // 6 : 1
    // 7 : 0
    // 8 : 0
    // 9 : 0
    // 10: 0
    // 11: 0
    // 12: 1
    // 13: 1
    // 14: 1
    // 15: 0

    // Pack bits in a 16-bit constant:
    localparam [15:0] LUT = 16'b0110100011110001; // reverse order of above bits to match indexing

    // But to match index to bits correctly, we reverse bits since bit0 is LSB:
    // The bits above: bit0=1, bit1=1,... So we have:
    // bit0 = 1 (x=0)
    // bit1 = 1 (x=1)
    // bit2 = 0
    // bit3 = 0
    // bit4 = 1
    // bit5 = 0
    // bit6 = 1
    // bit7 = 0
    // bit8 = 0
    // bit9 = 0
    // bit10=0
    // bit11=0
    // bit12=1
    // bit13=1
    // bit14=1
    // bit15=0

    // Assign f by selecting LUT bit at index x
    assign f = LUT[x];

endmodule