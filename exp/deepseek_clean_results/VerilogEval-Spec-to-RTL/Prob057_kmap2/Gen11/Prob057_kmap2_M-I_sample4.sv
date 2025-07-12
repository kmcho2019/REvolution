module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression from K-map
assign out = (!c & (!b | !d)) |   // Covers cd=00 and cd=10 cases
             (!d & (!a | !b)) |   // Covers cd=00 and cd=01 cases
             (a & b & (c | !d)) |  // Covers cd=11 and cd=10 cases
             (!a & b & c & d);     // Specific case at cd=11, ab=01

endmodule