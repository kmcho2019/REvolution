module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output out
);

wire not_b = ~b;
wire a_and_not_b = a & not_b;

assign out = c | a_and_not_b;

endmodule