module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Inlined OR operation to reduce area usage
assign q = b | c;

endmodule