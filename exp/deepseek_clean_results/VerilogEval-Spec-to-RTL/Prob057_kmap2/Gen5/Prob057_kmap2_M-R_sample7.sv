module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Implement minimized logic from K-map groupings
assign out = (~c & ~d) |               // Group 1: top two rows
             (a & b & c) |             // Group 2: bottom right
             (~a & b & d) |            // Group 3: middle right
             (a & ~b & ~d) |           // Additional single-cell terms
             (~b & c & d);             // Additional single-cell terms

endmodule