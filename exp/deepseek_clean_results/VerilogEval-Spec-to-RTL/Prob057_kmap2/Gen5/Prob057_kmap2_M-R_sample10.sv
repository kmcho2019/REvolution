module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Boolean equation derived from K-map groupings
assign out = (~c & ~d) |                 // Group 1: covers top-left 4 cells
              (~a & ~b) |                 // Group 2: covers left two columns
              (b & d) |                   // Group 3: covers middle-right when cd=11
              (a & ~b & c & ~d);         // Group 4: covers specific cell at cd=10,ab=01

endmodule