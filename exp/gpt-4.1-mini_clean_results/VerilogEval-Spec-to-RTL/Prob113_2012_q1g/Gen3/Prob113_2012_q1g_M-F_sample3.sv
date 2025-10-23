module TopModule(
    input  [3:0] x,
    output       f
);

// Assign variables according to Karnaugh map labeling:
// Rows indexed by x[2]x[3], with x[2] as MSB, x[3] as LSB
wire r1 = x[2];
wire r0 = x[3];

// Columns indexed by x[0]x[1], with x[0] as MSB, x[1] as LSB
wire c1 = x[0];
wire c0 = x[1];

// Map each cell in the Karnaugh map to the input vector x[3:0] bits:
// The minterm index is {x[3], x[2], x[1], x[0]} = {r0, r1, c0, c1}
// So minterm number = (r0<<3) + (r1<<2) + (c0<<1) + c1

// Let's enumerate all minterms with output 1 from the Karnaugh map:
// For row = r1 r0 and col = c1 c0:

// K-map from problem (rows: x[2]x[3], cols: x[0]x[1]):

// row\col 00  01  11  10  (col bits: c1 c0)
// 00(0 0): 1   0   0   1
// 01(0 1): 0   0   0   0
// 11(1 1): 1   1   1   0
// 10(1 0): 1   1   0   1

// Let's write down minterm numbers and values:

// row=00 (r1=0,r0=0)
// col=00 (c1=0,c0=0): minterm = {r0,r1,c0,c1} = {0,0,0,0} = 0  -> f=1
// col=01 (0,1): minterm = {0,0,1,0} = 2  -> f=0
// col=11 (1,1): minterm = {0,0,1,1} = 3  -> f=0
// col=10 (1,0): minterm = {0,0,0,1} = 1  -> f=1

// row=01 (r1=0,r0=1)
// col=00 (0,0): minterm = {1,0,0,0} = 8  -> f=0
// col=01 (0,1): minterm = {1,0,1,0} = 10 -> f=0
// col=11 (1,1): minterm = {1,0,1,1} = 11 -> f=0
// col=10 (1,0): minterm = {1,0,0,1} = 9  -> f=0

// row=11 (r1=1,r0=1)
// col=00 (0,0): minterm = {1,1,0,0} = 12 -> f=1
// col=01 (0,1): minterm = {1,1,1,0} = 14 -> f=1
// col=11 (1,1): minterm = {1,1,1,1} = 15 -> f=1
// col=10 (1,0): minterm = {1,1,0,1} = 13 -> f=0

// row=10 (r1=1,r0=0)
// col=00 (0,0): minterm = {0,1,0,0} = 4  -> f=1
// col=01 (0,1): minterm = {0,1,1,0} = 6  -> f=1
// col=11 (1,1): minterm = {0,1,1,1} = 7  -> f=0
// col=10 (1,0): minterm = {0,1,0,1} = 5  -> f=1

// Minterms with output 1 are:
// 0,1,4,5,6,12,14,15

// Now express f as the OR of these minterms using x bits:

// minterm bits are {x[3],x[2],x[1],x[0]} = {r0, r1, c0, c1}

// Let's write each minterm expression:

// 0: 0000 = ~x3 & ~x2 & ~x1 & ~x0
// 1: 0001 = ~x3 & ~x2 & ~x1 & x0
// 4: 0100 = ~x3 & x2 & ~x1 & ~x0
// 5: 0101 = ~x3 & x2 & ~x1 & x0
// 6: 0110 = ~x3 & x2 & x1 & ~x0
// 12: 1100= x3 & x2 & ~x1 & ~x0
// 14: 1110= x3 & x2 & x1 & ~x0
// 15: 1111= x3 & x2 & x1 & x0

// Let's try to simplify groups:

// Group 1: 0 and 1 differ only by x0
// (~x3 & ~x2 & ~x1) // covers 0 and 1

// Group 2: 4 and 5 differ only by x0
// (~x3 & x2 & ~x1) // covers 4 and 5

// Minterm 6 standalone: (~x3 & x2 & x1 & ~x0)

// Minterms 12,14,15 all with x3 & x2:
// 12: x3 & x2 & ~x1 & ~x0
// 14: x3 & x2 & x1 & ~x0
// 15: x3 & x2 & x1 & x0

// These three can be grouped partially:
// (x3 & x2 & ~x0 & (~x1 | x1)) = x3 & x2 & ~x0
// covers 12 and 14, and 15 has x0=1 so it is separate

// So 15 remains: x3 & x2 & x1 & x0

// Putting it all together:
// f = (~x3 & ~x2 & ~x1)
//   | (~x3 & x2 & ~x1)
//   | (~x3 & x2 & x1 & ~x0)
//   | (x3 & x2 & ~x0)
//   | (x3 & x2 & x1 & x0)

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

assign f = (~x3 & ~x2 & ~x1)
        | (~x3 & x2 & ~x1)
        | (~x3 & x2 & x1 & ~x0)
        | (x3 & x2 & ~x0)
        | (x3 & x2 & x1 & x0);

endmodule