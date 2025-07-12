module TopModule(
    input  [3:0] x,
    output       f
);

// Assign inputs to named wires for clarity
wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Explicit minterms corresponding to f=1 from the Karnaugh map:
// 0000 (x3=0,x2=0,x1=0,x0=0)
// 0010 (x3=0,x2=0,x1=1,x0=0) -> not in map (zero) => skip
// 0010 is zero, so corrected minterms are:

// From Karnaugh map positions with 1:
// Row x2 x3 | Col x0 x1

// 00 00 = x3=0,x2=0,x1=0,x0=0 -> 1
// 00 10 = x3=0,x2=0,x1=1,x0=0 -> 0
// 00 10 in map is 1 at (x2x3=00, x0x1=10), so x3=0,x2=0,x1=1,x0=0 -> 1

// Wait, from the map given: 
//             x[0]x[1]
// x[2]x[3]  00  01  11  10
// 00     | 1 | 0 | 0 | 1 |
// 01     | 0 | 0 | 0 | 0 |
// 11     | 1 | 1 | 1 | 0 |
// 10     | 1 | 1 | 0 | 1 |

// Map coordinates: rows x[2]x[3], cols x[0]x[1]
// So for example, position row=00 col=00 is x2=0,x3=0,x0=0,x1=0 => 1

// Let's write all minterms with f=1:

// row=00, col=00: x2=0,x3=0,x0=0,x1=0 -> 1
// row=00, col=10: x2=0,x3=0,x0=1,x1=0 -> 1
// row=01, col=xx: all zeros
// row=11, col=00: x2=1,x3=1,x0=0,x1=0 ->1
// row=11, col=01: x2=1,x3=1,x0=0,x1=1 ->1
// row=11, col=11: x2=1,x3=1,x0=1,x1=1 ->1
// row=11, col=10: x2=1,x3=1,x0=1,x1=0 ->0
// row=10, col=00: x2=1,x3=0,x0=0,x1=0 ->1
// row=10, col=01: x2=1,x3=0,x0=0,x1=1 ->1
// row=10, col=11: x2=1,x3=0,x0=1,x1=1 ->0
// row=10, col=10: x2=1,x3=0,x0=1,x1=0 ->1

assign f = 
    (~x2 & ~x3 & ~x0 & ~x1) // row 00 col 00
  | (~x2 & ~x3 &  x0 & ~x1) // row 00 col 10
  | ( x2 &  x3 & ~x0 & ~x1) // row 11 col 00
  | ( x2 &  x3 & ~x0 &  x1) // row 11 col 01
  | ( x2 &  x3 &  x0 &  x1) // row 11 col 11
  | ( x2 & ~x3 & ~x0 & ~x1) // row 10 col 00
  | ( x2 & ~x3 & ~x0 &  x1) // row 10 col 01
  | ( x2 & ~x3 &  x0 & ~x1) // row 10 col 10
  ;

endmodule