module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire nb, nc;
    wire and_term;
    wire or_bc;

    assign nb = ~b;
    assign nc = ~c;

    assign or_bc = b | c;
    assign and_term = nb & nc & a;

    assign out = or_bc | and_term;
endmodule