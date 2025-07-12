module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1 (all Gray-coded)
    output        f
);

    // Gray to binary conversion for rows: x4x3 (x[3], x[2])
    wire row1 = x[2];           // MSB of binary row = x3
    wire row0 = x[2] ^ x[3];    // LSB of binary row = x3 XOR x4

    // Gray to binary conversion for columns: x2x1 (x[1], x[0])
    wire col1 = x[0];           // MSB of binary column = x1
    wire col0 = x[0] ^ x[1];    // LSB of binary column = x1 XOR x2

    // Assign variables for clarity (row = {row1,row0}, col = {col1,col0})
    // From Karnaugh map minterms for output=1 (treat d as 0):
    // minterms (row,col):
    // (11,00) = row1=1,row0=1,col1=0,col0=0
    // (11,01) = 1,1,0,1
    // (10,00) = 1,0,0,0
    // (10,01) = 1,0,0,1
    // (01,10) = 0,1,1,0

    // Construct sum of minterms:
    // f = (row1 & row0 & ~col1 & ~col0)
    //   + (row1 & row0 & ~col1 &  col0)
    //   + (row1 & ~row0 & ~col1 & ~col0)
    //   + (row1 & ~row0 & ~col1 &  col0)
    //   + (~row1 &  row0 &  col1 & ~col0)

    assign f =
          (row1 & row0 & ~col1 & ~col0)
        | (row1 & row0 & ~col1 &  col0)
        | (row1 & ~row0 & ~col1 & ~col0)
        | (row1 & ~row0 & ~col1 &  col0)
        | (~row1 & row0 &  col1 & ~col0);

endmodule