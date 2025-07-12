module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// Optimized logic using bitwise operators for efficiency
assign out = a | (~a & ~b & c);

endmodule