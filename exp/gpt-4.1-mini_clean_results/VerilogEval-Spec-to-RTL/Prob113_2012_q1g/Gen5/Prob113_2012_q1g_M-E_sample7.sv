module TopModule(
    input  [3:0] x,
    output       f
);

// Let x = {x[3], x[2], x[1], x[0]}
// Based on the Karnaugh map, the minimal expression derived is:
// f = (!x3 & !x2 & !x1 & !x0)  // m0
//   + (!x3 & !x2 & x1 & x0)    // m3, but m3=0, so exclude
//   + (!x3 & x2 & !x1 & !x0)   // m4=0
//   + (!x3 & x2 & !x1 & x0)    // m5=0
//   + (!x3 & x2 & x1 & !x0)    // m6=0
//   + (x3 & x2 & !x1 & !x0)    // m12=1
//   + (x3 & x2 & x1 & !x0)     // m14=1
//   + (x3 & x2 & x1 & x0)      // m15=1
//   + (x3 & !x2 & !x1 & !x0)   // m8=1
//   + (x3 & !x2 & !x1 & x0)    // m9=1
//   + (!x3 & !x2 & !x1 & x0)   // m1=0
//   + (!x3 & !x2 & x1 & !x0)   // m2=0
//
// By analyzing the map and grouping:
// Group 1 (column 00): x1=0, x0=0 => f=1 when (x1=0 & x0=0) & (x3x2=00 or 10 or 11)
// Group 2 (row 11): x3=1 & x2=1 => f=1 except when x1=0 and x0=1 (m13=0)
//
// Minimal expression after Karnaugh map simplification:
// f = (!x1 & !x0) |
//     (x3 & x2 & x1) |
//     (x3 & !x2 & !x1) |
//     (!x3 & !x2 & !x1 & !x0)
//
// But noting m0 and m8, m9 etc. specifically:
//
// Final simplified formula:
// f = (!x1 & !x0) | (x3 & x2 & x1) | (x3 & !x2 & !x1)
//
// This covers all the 1s from the Karnaugh map.
//
// Implement this directly as a continuous assignment.

assign f = (~x[1] & ~x[0]) | (x[3] & x[2] & x[1]) | (x[3] & ~x[2] & ~x[1]);

endmodule