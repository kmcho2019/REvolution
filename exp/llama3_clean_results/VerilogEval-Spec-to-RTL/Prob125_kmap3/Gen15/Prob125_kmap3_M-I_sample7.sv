module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Synthesis directives to optimize for area and power
`synthesize -area -power -clock_gating -resource_sharing

assign out = a | (~a & ~b & c);

endmodule