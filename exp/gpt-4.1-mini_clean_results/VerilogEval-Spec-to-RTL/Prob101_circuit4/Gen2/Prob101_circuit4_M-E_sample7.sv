module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Invert inputs b and c
wire not_b = ~b;
wire not_c = ~c;

// AND of inverted inputs
wire and_not_b_c = not_b & not_c;

// Final inversion: q = ~(~b & ~c) == b | c
assign q = ~and_not_b_c;

endmodule