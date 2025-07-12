module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored
    output out
);

// Direct combinational logic using simplified K-map expression
assign out = (a & ~c) | (c & ~b) | (c & a);

endmodule