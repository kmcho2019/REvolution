module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized row pattern detection (shared with column terms)
wire row00 = ~c & ~d;
wire row11 = c & d;
wire row01_or_row10 = (~c & d) | (c & ~d);  // Combined terms

// Column pattern detection (minimal form)
wire col00 = ~a & ~b;
wire col10 = a & ~b;
wire col01_or_col11 = (~a & b) | (a & b);   // Combined terms

// Output construction using minimal POS form
assign out = (row00 | row01_or_row10 | col00) &  // Covers most 1's
             (row00 | row11 | col10) &           // Additional coverage
             (~(row11 & col00));                 // Explicitly handle 0's

endmodule