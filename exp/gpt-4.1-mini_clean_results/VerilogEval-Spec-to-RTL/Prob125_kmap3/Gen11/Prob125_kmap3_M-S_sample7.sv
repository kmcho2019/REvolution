module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output out
);

wire not_b = ~b;
wire not_c = ~c;

assign out = (c & (a | not_b)) | (a & not_c);

endmodule