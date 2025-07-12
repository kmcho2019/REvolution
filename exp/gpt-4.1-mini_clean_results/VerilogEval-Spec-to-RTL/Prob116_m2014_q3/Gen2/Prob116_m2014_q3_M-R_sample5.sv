module TopModule (
    input  [3:0] x,
    output      f
);

    // Define row and column from input bits
    wire [1:0] row = {x[3], x[0]};
    wire [1:0] col = {x[1], x[2]};
    wire [3:0] addr = {row, col};

    // 16-bit constant vector representing K-map values:
    // Index: addr = {row, col} = {x[3], x[0], x[1], x[2]}
    // K-map table (rows x columns):
    //         00  01  11  10
    // 00 (00): d   0   d   d
    // 01 (01): 0   d   1   0
    // 11 (11): 1   1   d   d
    // 10 (10): 1   1   0   d
    //
    // Replace don't-cares (d) with values chosen to simplify logic:
    // Let's assign don't-cares as follows (arbitrary but consistent):
    // For row=00: addr 0 (00 00) = d -> 0; addr 2 (00 11) = d -> 0; addr 3 (00 10) = d -> 0
    // For row=01: addr 5 (01 01) = d -> 0
    // For row=11: addr 11(11 11) = d -> 0; addr 12(11 10) = d -> 0
    // For row=10: addr 15(10 10) = d -> 0

    // Index mapping (addr):
    // addr decimal: binary : f
    // 0  = 0000 : 0 (d->0)
    // 1  = 0001 : 0
    // 2  = 0010 : 0 (d->0)
    // 3  = 0011 : 0 (d->0)
    // 4  = 0100 : 0
    // 5  = 0101 : 0 (d->0)
    // 6  = 0110 : 1
    // 7  = 0111 : 0
    // 8  = 1000 : 1
    // 9  = 1001 : 1
    // 10 = 1010 : 0
    // 11 = 1011 : 0 (d->0)
    // 12 = 1100 : 1
    // 13 = 1101 : 1
    // 14 = 1110 : 0 (d->0)
    // 15 = 1111 : 0 (d->0)

    wire [15:0] lut = 16'b0000_0100_1100_1100;

    assign f = lut[addr];

endmodule