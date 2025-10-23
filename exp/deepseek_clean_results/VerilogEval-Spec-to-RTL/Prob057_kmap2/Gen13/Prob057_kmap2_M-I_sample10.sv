module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized Boolean expression using sum-of-products
assign out = (!a & !c) |                // Covers most 1s in first two columns
             (a & !b & !d) |            // Top right corner
             (a & b & c) |              // Middle of bottom row
             (!a & b & c & !d);         // Specific case in second row

endmodule