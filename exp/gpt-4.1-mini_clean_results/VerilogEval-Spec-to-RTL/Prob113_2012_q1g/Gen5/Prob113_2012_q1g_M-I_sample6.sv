module TopModule(
    input  [3:0] x,
    output      f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Simplified boolean expression derived from the Karnaugh map:
// f = (!x3 & !x2 & !x1 & !x0)      // minterm 0
//   + (!x3 & !x2 & x1 & x0)        // minterm 3, covered by grouping minterms 0 and 8 (checked, not in original map, so re-check groups)
//   + (x3 & !x2 & !x1 & !x0)       // minterm 8, not in original map either, re-check minimal expression carefully
//
// Let's carefully re-derive minimal SOP from the given map:

// Karnaugh map indexing (x3 x2 as rows, x1 x0 as columns):
//       00  01  11  10
// 00 |  1 | 0 | 0 | 1 |  -> row 0 (x3=0,x2=0)
// 01 |  0 | 0 | 0 | 0 |  -> row 1 (x3=0,x2=1)
// 11 |  1 | 1 | 1 | 0 |  -> row 3 (x3=1,x2=1)
// 10 |  1 | 1 | 0 | 1 |  -> row 2 (x3=1,x2=0)

// List of minterms (in decimal) where f=1:
// 0 (0000), 3(0011 is 0 at pos 11?), let's check carefully:

// Positions where f=1:
// 0000 (0): row 0 col 00 -> 1
// 0011 (3): row 0 col 11 -> 0
// 0010 (2): row 0 col 10 -> 1
// 0100 (4): row 1 col 00 -> 0
// 0110 (6): row 1 col 10 -> 0
// 1000 (8): row 2 col 00 -> 1
// 1001 (9): row 2 col 01 -> 1
// 1010 (10): row 2 col 10 -> 1
// 1100 (12): row 3 col 00 -> 1
// 1101 (13): row 3 col 01 -> 1
// 1110 (14): row 3 col 10 -> 0
// 1111 (15): row 3 col 11 -> 1

// Actually, re-check original map values:
// Given map entries (row x3x2, col x1x0):
// (00,00)=1 (minterm 0)
// (00,01)=0 (minterm 1)
// (00,11)=0 (minterm 3)
// (00,10)=1 (minterm 2)

// (01,00)=0 (4)
// (01,01)=0 (5)
// (01,11)=0 (7)
// (01,10)=0 (6)

// (11,00)=1 (12)
// (11,01)=1 (13)
// (11,11)=1 (15)
// (11,10)=0 (14)

// (10,00)=1 (8)
// (10,01)=1 (9)
// (10,11)=0 (11)
// (10,10)=1 (10)

// So minterms with f=1 are:
// 0, 2, 8, 9, 10, 12, 13, 15

// Group 1: (8,9,12,13) = x3 & ~x1
// Group 2: (0,2,10) = ~x3 & ~x2 & (x0 | x1 & ~x0)? Let's see if this can be merged better

// Alternatively, factor groups:

// Group A: (8,9) = 1000, 1001 = x3=1,x2=0,x1=0,x0=don't care => x3 & ~x2 & ~x1
// Group B: (12,13) = 1100, 1101 = x3=1,x2=1,x1=0,x0=don't care => x3 & x2 & ~x1
// Group C: (0,2) = 0000, 0010 = x3=0,x2=0,x1=don't care,x0=0 => ~x3 & ~x2 & ~x0
// Group D: (10,15) = 1010, 1111 = (x3=1,x2=0,x1=1,x0=0), (x3=1,x2=1,x1=1,x0=1)
// These don't fit cleanly in one group, but 15 alone is a minterm.

// Another attempt, alternatively write f as:
// f = (x3 & ~x1)                         // covers 8,9,12,13
//   + (~x3 & ~x2 & ~x0)                  // covers 0,2
//   + (x3 & x2 & x1 & x0)                // covers 15 only
//   + (x3 & ~x2 & x1 & ~x0)              // covers 10 only

// This covers all minterms: 0,2 by (~x3 & ~x2 & ~x0), 8,9,12,13 by (x3 & ~x1), 10 by (x3 & ~x2 & x1 & ~x0), 15 by (x3 & x2 & x1 & x0)

// Expression:
// f = (x3 & ~x1) + (~x3 & ~x2 & ~x0) + (x3 & ~x2 & x1 & ~x0) + (x3 & x2 & x1 & x0)

// Implementing this expression will minimize logic terms and literals compared to full enumeration.

assign f = (x3 & ~x1)
        | (~x3 & ~x2 & ~x0)
        | (x3 & ~x2 & x1 & ~x0)
        | (x3 & x2 & x1 & x0);

endmodule