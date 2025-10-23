module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire nb, nc, and_term;

    assign nb = ~b;
    assign nc = ~c;
    assign and_term = nb & nc & a;
    assign out = (b | c) | and_term;

endmodule