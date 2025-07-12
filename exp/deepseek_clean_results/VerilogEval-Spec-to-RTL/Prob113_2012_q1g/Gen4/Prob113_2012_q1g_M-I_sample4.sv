module TopModule(
    input [3:0] x,
    output f
);
    // Row conditions
    wire row00 = (~x[3] & ~x[2]);  // x[3:2] = 00
    wire row01 = (~x[3] &  x[2]);  // x[3:2] = 01
    wire row11 = ( x[3] &  x[2]);  // x[3:2] = 11
    wire row10 = ( x[3] & ~x[2]);  // x[3:2] = 10

    // Column conditions where f=1 for each row
    wire col00 = (~x[1] & ~x[0]);  // x[1:0] = 00
    wire col01 = (~x[1] &  x[0]);  // x[1:0] = 01
    wire col11 = ( x[1] &  x[0]);  // x[1:0] = 11
    wire col10 = ( x[1] & ~x[0]);  // x[1:0] = 10

    // f=1 conditions for each row
    wire f_row00 = row00 & (col00 | col10);
    wire f_row01 = 1'b0;  // Always 0 for row01
    wire f_row11 = row11 & (~col10);  // 1 for all except col10
    wire f_row10 = row10 & (col00 | col01 | col10);

    // Final output
    assign f = f_row00 | f_row01 | f_row11 | f_row10;
endmodule