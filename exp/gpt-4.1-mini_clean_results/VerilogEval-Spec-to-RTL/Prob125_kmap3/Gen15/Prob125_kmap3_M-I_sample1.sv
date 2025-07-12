module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored
    output out
);

// Factored combinational logic to reduce gate count and switching
assign out = (a & ~c) | (c & (~b | a));

endmodule