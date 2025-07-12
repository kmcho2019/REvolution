module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored
    output out
);

// Directly assign the minimized expression without intermediate wires
assign out = (~c & a) | (c & (~b | a));

endmodule