module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Intermediate wires for inverted inputs
wire nb, nc;

// Invert b and c
assign nb = ~b;
assign nc = ~c;

// q = NAND(nb, nc) = ~(~b & ~c) = b | c
assign q = ~(nb & nc);

endmodule