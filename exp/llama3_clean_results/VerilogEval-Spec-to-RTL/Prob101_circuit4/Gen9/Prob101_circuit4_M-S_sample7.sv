module TopModule(
    input  a, // Not used but kept for interface compatibility
    input  b,
    input  c,
    input  d, // Not used but kept for interface compatibility
    output q
);

assign q = b || c;

endmodule