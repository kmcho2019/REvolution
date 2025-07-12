module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Improved solution using a simplified continuous assignment
assign q = b || c;

endmodule