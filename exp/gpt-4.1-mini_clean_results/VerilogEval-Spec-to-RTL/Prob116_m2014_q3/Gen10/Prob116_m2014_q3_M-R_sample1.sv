module TopModule(
    input  [3:0] x, // x[0]=x1, x[1]=x2, x[2]=x3, x[3]=x4
    output       f
);

    // Extract bits named as per problem statement
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Index formation:
    // Rows: x3 x4 (MSBs)
    // Columns: x1 x2 (LSBs)
    wire [3:0] idx = {x3, x4, x1, x2};

    // LUT from Karnaugh map with don't-cares = 0
    // K-map (rows: x3x4, cols: x1x2):
    //       00  01  11  10  (x1x2)
    // 00 |  d | 0 | d | d |  (x3x4=00)
    // 01 |  0 | d | 1 | 0 |  (x3x4=01)
    // 11 |  1 | 1 | d | d |  (x3x4=11)
    // 10 |  1 | 1 | 0 | d |  (x3x4=10)

    // Index and values (idx = {x3,x4,x1,x2}):
    // idx dec : (x3 x4 x1 x2) = value
    // 0  (0 0 0 0): d = 0
    // 1  (0 0 0 1): 0
    // 2  (0 0 1 1): d = 0
    // 3  (0 0 1 0): d = 0
    // 4  (0 1 0 0): 0
    // 5  (0 1 0 1): d = 0
    // 6  (0 1 1 1): 1
    // 7  (0 1 1 0): 0
    // 8  (1 1 0 0): 1
    // 9  (1 1 0 1): 1
    // 10 (1 1 1 1): d = 0
    // 11 (1 1 1 0): d = 0
    // 12 (1 0 0 0): 1
    // 13 (1 0 0 1): 1
    // 14 (1 0 1 1): 0
    // 15 (1 0 1 0): d = 0

    // Binary vector (idx from 15 down to 0):
    // bit idx: value
    // 15: 0
    // 14: 0
    // 13: 1
    // 12: 1
    // 11: 0
    // 10: 0
    // 9:  1
    // 8:  1
    // 7:  0
    // 6:  1
    // 5:  0
    // 4:  0
    // 3:  0
    // 2:  0
    // 1:  0
    // 0:  0

    localparam [15:0] f_lut = 16'b0011001101010000;

    assign f = f_lut[idx];

endmodule