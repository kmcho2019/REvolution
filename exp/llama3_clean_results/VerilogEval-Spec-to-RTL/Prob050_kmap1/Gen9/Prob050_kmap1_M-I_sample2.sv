module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

// The existing solution is already optimized for area and performance.
// Further optimizations would likely involve technology-specific directives or attributes.
assign out = a | b | c;

endmodule