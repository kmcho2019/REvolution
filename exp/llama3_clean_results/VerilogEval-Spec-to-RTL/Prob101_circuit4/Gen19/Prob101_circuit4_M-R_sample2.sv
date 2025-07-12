module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Simplified implementation using a single assign statement
assign q = b | c;

endmodule