module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_ab, and_cd;

// First layer: two AND gates
assign and_ab = a & b;
assign and_cd = c & d;

// Second layer: OR gate combining AND outputs
assign out = and_ab | and_cd;

// Inverted output
assign out_n = ~out;

endmodule