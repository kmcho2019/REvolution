module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression derived from K-map
assign out = (~c & ~d) |          // covers 4 cells
             (~a & ~b & d) |       // covers 2 cells
             (a & b & c) |         // covers 2 cells
             (a & ~b & ~d) |       // covers 2 cells
             (~a & b & ~c);        // covers 2 cells

endmodule