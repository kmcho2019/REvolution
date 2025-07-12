module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Use x directly as address for LUT
    // Karnaugh map values according to given map, 'd' chosen as 0
    // Address bit order: {x4,x3,x2,x1} = {x[3], x[2], x[1], x[0]}
    // Index  : x4 x3 x2 x1 
    // Mapping from K-map table flattened row-wise (x4 x3 as row, x2 x1 as col):
    // Row\Col: 00 01 11 10
    // 00     : d(0) 0    d(0) d(0)    -> row 00 = addr 0b00xx
    // 01     : 0     d(0) 1    0       -> row 01 = addr 0b01xx
    // 11     : 1     1    d(0) d(0)    -> row 11 = addr 0b11xx
    // 10     : 1     1    0    d(0)    -> row 10 = addr 0b10xx
    // Converted to addr (x4 x3 x2 x1):
    // Addr | f
    // 0000: 0 (d)
    // 0001: 0
    // 0011: 0 (d)
    // 0010: 0 (d)
    // 0100: 0
    // 0101: 0 (d)
    // 0111: 1
    // 0110: 0
    // 1100: 1
    // 1101: 1
    // 1111: 0 (d)
    // 1110: 0 (d)
    // 1000: 1
    // 1001: 1
    // 1011: 0
    // 1010: 0 (d)
    localparam [15:0] kmap = 16'b0000_0100_1100_0110;

    assign f = kmap[x];

endmodule