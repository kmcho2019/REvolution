module TopModule (
  input [4:1] x,
  output logic f
);
  // Inputs: x[4], x[3], x[2], x[1]
  // K-map rows: x[3]x[4], columns: x[1]x[2]
  // Rewrite K-map with explicit cells for all 16 combinations:
  // Using x[4] and x[3] as row bits (MSB: x4, LSB: x3)
  // and x[1] and x[2] as column bits (MSB: x1, LSB: x2)
  //
  // The K-map given (rows: x3x4, cols: x1x2):
  //  x3x4\x1x2  00   01   11   10
  //  00       d(0) 0(1) d(2) d(3)
  //  01       0(4) d(5) 1(6) 0(7)
  //  11       1(8) 1(9) d(10)d(11)
  //  10       1(12)1(13)0(14)d(15)
  //
  // Indexing in parentheses is the decimal index of the cell if
  // row bits are x3x4 and col bits are x1x2. But since x[4:1] is
  // x4 (MSB) to x1 (LSB), we must reorder bits to get the cell index:
  //
  // Let's map input x[4:1] to (x3,x4,x1,x2) to use the K-map:
  // But the K-map rows are x3 x4 and columns are x1 x2:
  // So row index = {x3,x4} = {x[3],x[4]}
  // column index = {x1,x2} = {x[1], x[2]}
  // So cell index = {row, column} = {x3,x4,x1,x2}
  //
  // To get minterm number, the order is x4 x3 x2 x1
  // but the K-map uses x3 x4 x1 x2
  //
  // Let's write function directly based on K-map entries:
  //
  // From map:
  // f=1 for:
  // row x3x4 = 11 (x3=1,x4=1), col x1x2=00,01 -> cells (8,9)
  // row 11 col 00=1, col 01=1
  // row 11 col 11 (d), col 10 (d)
  // row 10 col 00=1, 01=1, 11=0, 10=d
  // row 01 col 11=1, others 0 or d
  //
  // Marking minterms where f=1:
  // x3x4 x1x2 = 11 00 (cell 8) -> x3=1,x4=1,x1=0,x2=0
  // 11 01 (cell 9) -> x3=1,x4=1,x1=0,x2=1
  // 10 00 (cell 12)-> x3=1,x4=0,x1=0,x2=0
  // 10 01 (cell 13)-> x3=1,x4=0,x1=0,x2=1
  // 01 11 (cell 6) -> x3=0,x4=1,x1=1,x2=1
  //
  // Using don't cares to simplify:
  // Group 1: cells 8,9,12,13 (x3=1,x1=0,x2=don't care,x4=don't care) -> x3 & ~x1
  // Group 2: cell 6 (x3=0,x4=1,x1=1,x2=1)
  //
  // Also cell 14 (10 11) is 0, so no group there.
  //
  // So simplified expression:
  // f = (x3 & ~x1) | (~x3 & x4 & x1 & x2)
  //
  assign f = (x[3] & ~x[1]) | (~x[3] & x[4] & x[1] & x[2]);

endmodule