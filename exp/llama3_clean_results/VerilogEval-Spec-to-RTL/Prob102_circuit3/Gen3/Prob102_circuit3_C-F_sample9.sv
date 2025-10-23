module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Directly implement the observed logic in a concise manner
assign q = (a || b) && (c || d);

endmodule