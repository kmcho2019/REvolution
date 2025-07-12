module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Synthesis directive to optimize for area and power
// `synthesize -area -power`

assign out = a | (~a & ~b & c);

endmodule