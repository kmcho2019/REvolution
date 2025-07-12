module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

wire nb, nc;

assign nb = ~b;
assign nc = ~c;
assign q = ~(nb & nc);

endmodule