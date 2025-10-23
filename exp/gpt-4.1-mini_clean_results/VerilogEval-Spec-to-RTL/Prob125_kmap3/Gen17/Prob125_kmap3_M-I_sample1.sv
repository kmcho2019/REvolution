module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't care, ignored
    output out
);

// Simplified logic leveraging 'd' as don't care, reducing gates and switching
assign out = c | (a & ~b);

endmodule