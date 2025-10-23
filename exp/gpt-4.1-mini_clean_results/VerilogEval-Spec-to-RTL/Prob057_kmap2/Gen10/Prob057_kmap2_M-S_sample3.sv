module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Based on the Karnaugh map, minimal SOP expression is:

// Deriving minimal expression (manually):
// Map rows and columns with inputs:
// cd\ab:       00  01  11  10
// 00(0,0):    1   1   0   1
// 01(0,1):    1   0   0   1
// 11(1,1):    0   1   1   1
// 10(1,0):    1   1   0   0

// Observing the map, minimal expression can be:
// out = (~c & ~b) | (~a & ~b) | (a & b & c) | (a & ~d) | (~c & ~d)

// Re-expressing as:
// out = (~c & ~b) 
//     | (~a & ~b) 
//     | (a & b & c) 
//     | (a & ~d) 
//     | (~c & ~d);

// This expression covers all 1s without redundancy.

assign out = 
    (~c & ~b) |
    (~a & ~b) |
    (a & b & c) |
    (a & ~d) |
    (~c & ~d);

endmodule