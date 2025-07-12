module TopModule(
    input  [3:0] x,
    output      f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// From Karnaugh map analysis, function f can be expressed as:
// f = (!x3 & !x2 & !x1 & !x0)  // cell (00,00)
//   + (!x3 & !x2 & x1 & x0)    // cell (00,10)
//   + (!x3 & x2 & !x1 & !x0)   // cell (10,00)
//   + (!x3 & x2 & !x1 & x0)    // cell (10,01)
//   + (x3 & x2 & !x1 & !x0)    // cell (11,00)
//   + (x3 & x2 & !x1 & x0)     // cell (11,01)
//   + (x3 & x2 & x1 & !x0)     // cell (11,10)
//   + (x3 & !x2 & !x1 & !x0);  // cell (10,00 again, carefully verified below)

// Actually minterms from the K-map with '1':
// Coordinates: {x3 x2} rows, {x1 x0} cols
// 00 00: 1 (0000)
// 00 10: 1 (0010)
// 10 00: 1 (1000)
// 10 01: 1 (1001)
// 11 00: 1 (1100)
// 11 01: 1 (1101)
// 11 10: 1 (1110)
// 00 00 and 10 00 are two distinct entries; 10 00 (x3=1, x2=0, x1=0, x0=0) is included.
// The Karnaugh map must be matched precisely.

// To optimize:
// f = (!x3 & !x2 & !x1 & !x0)          // 0000
//   + (!x3 & !x2 &  x1 & !x0)          // 0010
//   + ( x3 & !x2 & !x1 & !x0)          // 1000
//   + ( x3 & !x2 & !x1 &  x0)          // 1001
//   + ( x3 &  x2 & !x1 & !x0)          // 1100
//   + ( x3 &  x2 & !x1 &  x0)          // 1101
//   + ( x3 &  x2 &  x1 & !x0)          // 1110
//   + (!x3 &  x2 & !x1 &  x0);         // 0010 is repeated? No, 0010 is !x3,!x2,x1,!x0= 0,0,1,0 which is second term
// The last term corresponds to (10 01), which is x3=1,x2=0,x1=0,x0=1 => 1001 included already.
// So some terms were mismatched.

// Revised based on K-map:

// (Row 00, Col 00) => x3=0, x2=0, x1=0, x0=0 => 0000
// (Row 00, Col 10) => x3=0, x2=0, x1=1, x0=0 => 0010
// (Row 10, Col 00) => x3=1, x2=0, x1=0, x0=0 => 1000
// (Row 10, Col 01) => x3=1, x2=0, x1=0, x0=1 => 1001
// (Row 11, Col 00) => x3=1, x2=1, x1=0, x0=0 => 1100
// (Row 11, Col 01) => x3=1, x2=1, x1=0, x0=1 => 1101
// (Row 11, Col 11) => x3=1, x2=1, x1=1, x0=1 => 1111 (not 1110!)
// (Row 10, Col 10) => x3=1, x2=0, x1=1, x0=0 => 1010

// From the map's '1's (note the original map):
// 00 00: 1  (0000)
// 00 10: 1  (0010)
// 10 00: 1  (1000)
// 10 01: 1  (1001)
// 11 00: 1  (1100)
// 11 01: 1  (1101)
// 11 11: 1  (1111)
// 10 10: 1  (1010)

// So minterms are:
// 0000, 0010, 1000, 1001, 1100, 1101, 1111, 1010

assign f = (x == 4'b0000) ||
           (x == 4'b0010) ||
           (x == 4'b1000) ||
           (x == 4'b1001) ||
           (x == 4'b1100) ||
           (x == 4'b1101) ||
           (x == 4'b1111) ||
           (x == 4'b1010);

endmodule