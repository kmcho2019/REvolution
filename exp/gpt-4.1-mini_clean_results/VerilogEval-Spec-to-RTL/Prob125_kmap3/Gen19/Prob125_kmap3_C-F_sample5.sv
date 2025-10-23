module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored
    output out
);

// Invert b for clarity
wire not_b = ~b;

// Essential product term: c & ~b
wire c_and_not_b = c & not_b;

// Final output: a OR (c AND ~b)
assign out = a | c_and_not_b;

endmodule