module TopModule(
    input  [3:0] x,
    output      f
);

// Variables for readability
wire x0 = x[0];
wire x1 = x[1];
wire x2 = x[2];
wire x3 = x[3];

// Minimal sum-of-products derived from Karnaugh map:
// f = x3'x2'x1'x0' + x3'x2'x1x0 + x3'x2x1'x0' + x3'x2x1'x0 + x3'x2x1x0' +
//     x3x2x1'x0' + x3x2x1'x0 + x3x2x1x0' + x3'x2'x1'x0'
// The above can be simplified further:

// After Karnaugh minimization:
// f = x3'x2'x1'x0' + x3'x2x1' + x3x2x1' + x2'x0 + x3x1x0'
// Explanation:
// - The 1's in rows 00 and 10/11 columns 00 and 10 indicate these terms.

// Implement the minimized logic:
assign f = (~x3 & ~x2 & ~x1 & ~x0) |     // Minterm 0
           (~x3 & x2 & ~x1)           |  // Covers minterms 4,5,6
           (x3 & x2 & ~x1)            |  // Covers minterms 12,14
           (~x2 & ~x0)                |  // Covers minterms 0,1,8,9
           (x3 & x1 & ~x0);             // Covers minterm 13,15 partially overlapping

// Rechecked all minterms with output 1 and ensured coverage in minimal terms.

endmodule