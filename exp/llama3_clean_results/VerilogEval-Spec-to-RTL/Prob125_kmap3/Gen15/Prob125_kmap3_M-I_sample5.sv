module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// Continuous assignment for area and power efficiency
assign out = a | (~a & ~b & c);

endmodule