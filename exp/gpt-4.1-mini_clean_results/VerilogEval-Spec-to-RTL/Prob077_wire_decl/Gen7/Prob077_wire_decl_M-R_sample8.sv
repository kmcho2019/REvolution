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

// First layer: AND gates implemented via continuous assignments
assign and_ab = a & b;
assign and_cd = c & d;

// Second layer: OR gate combining the AND outputs
assign out = and_ab | and_cd;

// Inverted output from out
assign out_n = ~out;

endmodule