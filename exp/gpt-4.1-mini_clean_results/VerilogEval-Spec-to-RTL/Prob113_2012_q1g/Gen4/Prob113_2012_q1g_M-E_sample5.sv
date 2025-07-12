module TopModule(
    input  [3:0] x,
    output      f
);

    // Construct address as per Karnaugh map indexing:
    // row = x[2] x[3], column = x[0] x[1]
    wire [3:0] addr = {x[2], x[3], x[0], x[1]};
    
    // LUT representing f values from Karnaugh map, indexed by addr
    // Index: {x[2], x[3], x[0], x[1]} from 0 to 15
    // Values from K-map rows x[2]x[3], columns x[0]x[1]:
    // row 00: 1 0 0 1
    // row 01: 0 0 0 0
    // row 11: 1 1 1 0
    // row 10: 1 1 0 1
    //
    // Flattened LUT: index=addr, value=f
    // addr=0  (0000): 1
    // addr=1  (0001): 0
    // addr=2  (0010): 0
    // addr=3  (0011): 1
    // addr=4  (0100): 0
    // addr=5  (0101): 0
    // addr=6  (0110): 0
    // addr=7  (0111): 0
    // addr=8  (1000): 1
    // addr=9  (1001): 1
    // addr=10 (1010): 0
    // addr=11 (1011): 1
    // addr=12 (1100): 1
    // addr=13 (1101): 1
    // addr=14 (1110): 1
    // addr=15 (1111): 0
    reg [15:0] lut = 16'b0_1111_1101_0111_1001;

    assign f = lut[addr];

endmodule