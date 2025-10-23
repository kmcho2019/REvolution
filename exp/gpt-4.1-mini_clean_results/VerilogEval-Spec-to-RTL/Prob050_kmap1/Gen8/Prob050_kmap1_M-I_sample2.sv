module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire nb, nc; // inverted b and c
    wire and0;

    assign nb = ~b;
    assign nc = ~c;

    // and0 = ~b & ~c & a
    assign and0 = nb & nc & a;

    // out = (b | c) | and0
    assign out = (b | c) | and0;
endmodule