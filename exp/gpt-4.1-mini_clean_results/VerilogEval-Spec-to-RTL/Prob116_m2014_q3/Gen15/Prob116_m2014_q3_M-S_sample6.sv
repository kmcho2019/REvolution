module TopModule (
    input  [3:0] x, // x[3],x[2] = row; x[1],x[0] = col
    output      f
);

    // Karnaugh map values flattened by row and column (row,col):
    // row = x[3:2], col = x[1:0]
    // d replaced with 0 for deterministic output
    // Map:
    // 00: d=0, 0, d=0, d=0  -> columns 00=0, 01=0, 11=0, 10=0
    // 01: 0, d=0, 1, 0      -> 00=0, 01=0, 11=1, 10=0
    // 11: 1, 1, d=0, d=0    -> 00=1, 01=1, 11=0, 10=0
    // 10: 1, 1, 0, d=0      -> 00=1, 01=1, 11=0, 10=0

    // Create a 16-bit constant with f values indexed by x (row col)
    // index = {row, col} = x[3:0]
    // For x from 0 to 15:
    // x: f
    // 0 (0000): 0
    // 1 (0001): 0
    // 2 (0010): 0
    // 3 (0011): 0
    // 4 (0100): 0
    // 5 (0101): 0
    // 6 (0110): 1
    // 7 (0111): 0
    // 8 (1000): 1
    // 9 (1001): 1
    // 10(1010):0
    // 11(1011):0
    // 12(1100):1
    // 13(1101):1
    // 14(1110):0
    // 15(1111):0

    wire [15:0] lut = 16'b0010_0010_1100_0000; 
    // rewritten in bit order (bit 0 = x=0):
    // bits: 15..0 = f at x=15..0
    // From the above f values, from x=15 downto 0:
    // x=15:0,14:0,13:1,12:1,11:0,10:0,9:1,8:1,7:0,6:1,5:0,4:0,3:0,2:0,1:0,0:0
    // bits: 15..0 = 0 0 1 1 0 0 1 1 0 1 0 0 0 0 0 0 
    // In hex: 0010_0010_1100_0000 = 0x22C0

    assign f = lut[x];

endmodule