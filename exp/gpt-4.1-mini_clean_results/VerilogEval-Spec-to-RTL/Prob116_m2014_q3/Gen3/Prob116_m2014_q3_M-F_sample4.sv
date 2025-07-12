module TopModule(
    input [3:0] x,
    output f
);
    // Reorder bits for LUT indexing: address = {x[3], x[0], x[1], x[2]}
    wire [3:0] addr = {x[3], x[0], x[1], x[2]};
    
    // Karnaugh map from the problem with rows = x[3]x[0], cols = x[1]x[2]:
    // row\col  00   01   11   10
    // 00       d=0  0    d=0  d=0
    // 01       0    d=0  1    0
    // 11       1    1    d=0  d=0
    // 10       1    1    0    d=0
    
    // Mapping each address (0 to 15) with this ordering:
    // addr = {x3 x0 x1 x2} binary
    // addr decimal : f value
    // 0  (0000): row=00 col=00 -> d=0
    // 1  (0001): row=00 col=01 -> 0
    // 2  (0010): row=00 col=10 -> d=0
    // 3  (0011): row=00 col=11 -> d=0
    // 4  (0100): row=01 col=00 -> 0
    // 5  (0101): row=01 col=01 -> d=0
    // 6  (0110): row=01 col=10 -> 0
    // 7  (0111): row=01 col=11 -> 1
    // 8  (1000): row=10 col=00 -> 1
    // 9  (1001): row=10 col=01 -> 1
    // 10 (1010): row=10 col=10 -> 0
    // 11 (1011): row=10 col=11 -> d=0
    // 12 (1100): row=11 col=00 -> 1
    // 13 (1101): row=11 col=01 -> 1
    // 14 (1110): row=11 col=10 -> d=0
    // 15 (1111): row=11 col=11 -> d=0
    
    // LUT bits (bit 0 = addr=0):
    // addr:  15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
    // value:  0  0  1  1  0  0  1  1  1  0  0  0  0  0  0  0
    // Bits in binary (MSB is addr=15): 0011001110000000
    // In Verilog binary constant with bit0 = LSB:
    wire [15:0] lut = 16'b0011001110000000;
    
    assign f = lut[addr];
endmodule