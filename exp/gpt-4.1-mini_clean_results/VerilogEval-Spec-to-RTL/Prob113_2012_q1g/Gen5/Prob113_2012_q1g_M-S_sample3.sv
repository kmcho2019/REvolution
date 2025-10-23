module TopModule(
    input  [3:0] x,
    output       f
);

// Assign bits for clarity: x = {x3, x2, x1, x0}
wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Simplified expression from K-map:
// f = (!x3 & !x2 & !x1 & !x0)       // minterm 0
//   + (!x3 & !x2 & x1 & x0)         // minterm 3 (which is 0 in K-map, so ignore)
//   + (!x3 & x2 & !x1 & !x0)        // minterm 4 (f=1)
//   + (!x3 & x2 & !x1 & x0)         // minterm 5 (f=1)
//   + (!x3 & x2 & x1 & !x0)         // minterm 6 (f=1)
//   + (x3 & !x2 & !x1 & !x0)        // minterm 8 (f=1)
//   + (x3 & !x2 & !x1 & x0)         // minterm 9 (f=1)
//   + (x3 & x2 & !x1 & !x0)         // minterm 12 (f=1)
//   + (x3 & x2 & x1 & !x0)          // minterm 14 (f=1)
//   + (x3 & x2 & x1 & x0);          // minterm 15 (f=1)

// We can factor common terms:

// From K-map analysis, the simplified SOP is:
// f = (~x3 & ~x2 & ~x1 & ~x0)          // cell 0
//   + (~x3 & x2 & ~x1)                  // cells 4,5,6
//   + (x3 & ~x2 & ~x1)                  // cells 8,9
//   + (x3 & x2 & x1 & ~x0)              // cells 14
//   + (x3 & x2 & x1 & x0);              // cell 15

assign f = 
    (~x3 & ~x2 & ~x1 & ~x0)       // 0
  | (~x3 & x2 & ~x1)              // 4,5,6
  | (x3 & ~x2 & ~x1)              // 8,9
  | (x3 & x2 & x1 & ~x0)          // 14
  | (x3 & x2 & x1 & x0);          // 15

endmodule