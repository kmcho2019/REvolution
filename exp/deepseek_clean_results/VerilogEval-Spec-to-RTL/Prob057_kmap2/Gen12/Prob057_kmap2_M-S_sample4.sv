module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Further optimized to 3 product terms with better grouping
assign out = ~(
    (~a & ~b & c & d) |          // Essential term for top-left 0
    (a & b & ~(c & d)) |         // Combined term for bottom-right pattern
    ((a & c & ~d) | (b & ~c & d)) // Combined adjacent terms
);

endmodule