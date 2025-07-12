module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_ab;
wire and_cd;

// First layer: two AND gates
and U_and1 (and_ab, a, b);
and U_and2 (and_cd, c, d);

// Second layer: OR gate
or  U_or  (out, and_ab, and_cd);

// Inverter for out_n
not U_not (out_n, out);

endmodule