module TopModule (
    input  [3:0] x,
    output      f
);

wire [1:0] row = {x[3], x[0]}; // x3 x0 - row bits
wire [1:0] col = {x[2], x[1]}; // x2 x1 - column bits

// K-map given as:
// Rows: 00 01 11 10 (x3x0)
// Cols: 00 01 11 10 (x2x1)
//
//           00  01  11  10  (col)
// 00 (0,0) | d | 0 | d | d |
// 01 (0,1) | 0 | d | 1 | 0 |
// 11 (1,1) | 1 | 1 | d | d |
// 10 (1,0) | 1 | 1 | 0 | d |
//
// Using don't cares to simplify, the minimal SOP expression is:
// f = (x3 & x0) & (x2 | ~x1)  // covers row 11 and 10 with col 00,01
//   | (x3 & ~x0 & ~x2 & x1)  // covers row 10, col 11=0 (so no), use only ones
//   | (~x3 & x0 & x2 & x1)   // row 01 col 11=1
//   | (x3 & x0 & x2 & ~x1)   // row 11 col 10 d, treat as 0 to keep it simple
// From the map:
// Ones at:
// (11,00): row=11(3,0)=1 1, col=00(2,1)=0 0 => x3=1,x0=1,x2=0,x1=0 => f=1
// (11,01): 1 1 0 1 => f=1
// (01,11): 0 1 1 1 => f=1
// (10,00): 1 0 0 0 => f=1
// (10,01): 1 0 0 1 => f=1
// So minterms:
// m12: x3=1,x2=1,x1=0,x0=0
// m13: x3=1,x2=1,x1=0,x0=1
// m7:  x3=0,x2=1,x1=1,x0=1
// m8:  x3=1,x2=0,x1=0,x0=0
// m9:  x3=1,x2=0,x1=0,x0=1

// Let's write the expression as sum of minterms:

assign f = (x[3]&x[2]&~x[1]&~x[0]) | 
           (x[3]&x[2]&~x[1]&x[0])  |
           (~x[3]&x[2]&x[1]&x[0])  |
           (x[3]&~x[2]&~x[1]&~x[0])|
           (x[3]&~x[2]&~x[1]&x[0]);

endmodule