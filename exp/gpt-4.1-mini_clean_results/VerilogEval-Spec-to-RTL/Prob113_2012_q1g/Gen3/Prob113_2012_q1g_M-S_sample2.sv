module TopModule(
    input  [3:0] x,
    output      f
);

    // Rows = x[2]x[3], Columns = x[0]x[1]
    wire [3:0] idx = {x[2], x[3], x[0], x[1]};

    // Karnaugh map values (bit idx = {row,col} = {x[2], x[3], x[0], x[1]}):
    // idx : value
    // 0  (0000) = 1  (row=00, col=00)
    // 1  (0001) = 0
    // 2  (0010) = 1
    // 3  (0011) = 0
    // 4  (0100) = 0
    // 5  (0101) = 0
    // 6  (0110) = 0
    // 7  (0111) = 0
    // 8  (1000) = 1
    // 9  (1001) = 1
    // 10 (1010) = 0
    // 11 (1011) = 1
    // 12 (1100) = 1
    // 13 (1101) = 1
    // 14 (1110) = 1
    // 15 (1111) = 0

    // Binary constant with bit0 = idx=0, bit15 = idx=15:
    // bits: 15..0 = 0 1 1 1 1 0 1 1 1 0 0 0 0 1 0 1
    // So:
    // bit 15 = idx15 = 0
    // bit 14 = idx14 = 1
    // bit 13 = idx13 = 1
    // bit 12 = idx12 = 1
    // bit 11 = idx11 = 1
    // bit 10 = idx10 = 0
    // bit 9  = idx9  = 1
    // bit 8  = idx8  = 1
    // bit 7  = idx7  = 0
    // bit 6  = idx6  = 0
    // bit 5  = idx5  = 0
    // bit 4  = idx4  = 0
    // bit 3  = idx3  = 0
    // bit 2  = idx2  = 1
    // bit 1  = idx1  = 0
    // bit 0  = idx0  = 1

    wire [15:0] f_table = 16'b0111101110000101;

    assign f = f_table[idx];

endmodule