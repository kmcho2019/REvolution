module TopModule (
    input  [3:0] x,
    output      f
);

    // Karnaugh map (rows: x[3]x[0], columns: x[1]x[2])
    // Inputs: x[3], x[2], x[1], x[0]
    //
    // We'll build the LUT indexed by x[3:0]:
    // For each input x = {x3,x2,x1,x0}, output f is:
    //
    // Map each cell in Karnaugh map to input x:
    // Row bits = x[3]x[0]
    // Col bits = x[1]x[2]
    //
    // Input bits: x3 x2 x1 x0
    // Index:      bit3 bit2 bit1 bit0
    //
    // For example, row=00 (x3=0,x0=0), col=00 (x1=0,x2=0)
    // input = x3=0, x2=0, x1=0, x0=0 => x=4'b0000 = 0 decimal
    // Output = d (assign 0)
    //
    // Fill LUT for all 16 inputs:
    // x[3] x[2] x[1] x[0] | f (with d=0)
    // ---------------------------------
    // 0 0 0 0 (0)  : d -> 0
    // 0 0 0 1 (1)  : 0
    // 0 0 1 0 (2)  : d -> 0
    // 0 0 1 1 (3)  : d -> 0
    //
    // 0 1 0 0 (4)  : 0
    // 0 1 0 1 (5)  : d -> 0
    // 0 1 1 0 (6)  : 0
    // 0 1 1 1 (7)  : 1
    //
    // 1 0 0 0 (8)  : 1
    // 1 0 0 1 (9)  : 1
    // 1 0 1 0 (10) : 0
    // 1 0 1 1 (11) : d -> 0
    //
    // 1 1 0 0 (12) : 1
    // 1 1 0 1 (13) : 1
    // 1 1 1 0 (14) : d -> 0
    // 1 1 1 1 (15) : d -> 0

    // LUT bits: index = x, bit = f(x)
    // bit 15 ... bit 0 (MSB to LSB)
    // bit 15 (x=15) = 0
    // bit 14 (x=14) = 0
    // bit 13 (x=13) = 1
    // bit 12 (x=12) = 1
    // bit 11 (x=11) = 0
    // bit 10 (x=10) = 0
    // bit 9  (x=9)  = 1
    // bit 8  (x=8)  = 1
    // bit 7  (x=7)  = 1
    // bit 6  (x=6)  = 0
    // bit 5  (x=5)  = 0
    // bit 4  (x=4)  = 0
    // bit 3  (x=3)  = 0
    // bit 2  (x=2)  = 0
    // bit 1  (x=1)  = 0
    // bit 0  (x=0)  = 0

    wire [15:0] lut = 16'h3380; // binary: 0011_0011_1000_0000

    assign f = lut[x];

endmodule