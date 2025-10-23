module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (!a & !b & !(c & d)) |  // Top-left quadrant with exception
             (a & b & (c | d)) |     // Bottom-right quadrant with exception
             (!a & b & !c & d) |     // Specific 1 in top-right
             (a & !b & c & !d);      // Specific 1 in bottom-left

endmodule