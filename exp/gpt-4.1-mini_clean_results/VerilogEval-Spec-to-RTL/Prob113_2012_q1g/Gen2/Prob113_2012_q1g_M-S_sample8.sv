module TopModule(
    input  [3:0] x,
    output       f
);

wire x0 = x[0];
wire x1 = x[1];
wire x2 = x[2];
wire x3 = x[3];

// From the Karnaugh map:
// f = (~x3 & ~x2 & ~x1 & ~x0)    // minterm 0
//   + (~x3 & ~x2 & x1 & ~x0)     // minterm 2
//   + (x3 & ~x2 & ~x1 & ~x0)     // minterm 8
//   + (x3 & ~x2 & ~x1 & x0)      // minterm 9
//   + (x3 & ~x2 & x1 & x0)       // minterm 10
//   + (x3 & x2 & ~x1 & ~x0)      // minterm 12
//   + (x3 & x2 & ~x1 & x0)       // minterm 13
//   + (x3 & x2 & x1 & x0);       // minterm 15

// Grouping terms and simplifying:
// f = (~x3 & ~x2 & ~x1 & ~x0) + (~x3 & ~x2 & x1 & ~x0)
//   + (x3 & ~x2 & ~x1)
//   + (x3 & ~x2 & x1 & x0)
//   + (x3 & x2 & ~x1)
//   + (x3 & x2 & ~x1 & x0) + (x3 & x2 & x1 & x0)

// Further simplification:
// f = (~x3 & ~x2 & ~x0) & (~x1 | x1)  // which is just (~x3 & ~x2 & ~x0)
//   + (x3 & ~x2 & ~x1)
//   + (x3 & ~x2 & x1 & x0)
//   + (x3 & x2 & ~x1)
//   + (x3 & x2 & x1 & x0)

// Realizing that (x3 & ~x2 & ~x1) covers minterm 8 and 9, 
// (x3 & ~x2 & x1 & x0) covers minterm 10,
// (x3 & x2 & ~x1) covers 12 and 13,
// (x3 & x2 & x1 & x0) covers 15.

// Thus final compact expression:

assign f = (~x3 & ~x2 & ~x0) // covers minterms 0 and 2
         | (x3 & ~x2 & ~x1)
         | (x3 & ~x2 & x1 & x0)
         | (x3 & x2 & ~x1)
         | (x3 & x2 & x1 & x0);

endmodule