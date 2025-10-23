module TopModule(
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output      f
);

    // Assign named bits for clarity per problem notation
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Build index: {x4,x3,x2,x1} to match Karnaugh map indexing
    wire [3:0] idx = {x4, x3, x2, x1};

    // Lookup table: f values as per Karnaugh map (assigning don't-cares = 0)
    // Rows: x4 x3, Columns: x1 x2
    // K-map entries (row,col):
    // 00: d 0 d d  -> indices 0000, 0001, 0011, 0010  -> f=0 for d, f=0 as given
    // 01: 0 d 1 0
    // 11: 1 1 d d
    // 10: 1 1 0 d
    // Index order: bit3=x4, bit2=x3, bit1=x2, bit0=x1
    // Map index decimal and f values:
    // 0 (0000): d -> 0
    // 1 (0001): 0
    // 2 (0010): d -> 0
    // 3 (0011): d -> 0
    // 4 (0100): 0
    // 5 (0101): d -> 0
    // 6 (0110): 0
    // 7 (0111): 1
    // 8 (1000): 1
    // 9 (1001): 1
    // 10(1010): d -> 0
    // 11(1011): 0
    // 12(1100): 1
    // 13(1101): 1
    // 14(1110): d -> 0
    // 15(1111): d -> 0

    localparam [15:0] f_lut = 16'b0001000110011100;

    assign f = f_lut[idx];

endmodule