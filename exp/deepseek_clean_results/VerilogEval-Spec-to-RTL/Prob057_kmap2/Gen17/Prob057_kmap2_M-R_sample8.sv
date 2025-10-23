module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Minimal SOP implementation from K-map analysis
assign out = (~a & ~b & ~(c & d)) |  // ab=00 except cd=11
              (a & ~b & ~d) |        // ab=10 with d=0
              (a & b & ~c) |         // ab=11 with c=0
              (~a & b & c & d);      // ab=01 with cd=11

endmodule