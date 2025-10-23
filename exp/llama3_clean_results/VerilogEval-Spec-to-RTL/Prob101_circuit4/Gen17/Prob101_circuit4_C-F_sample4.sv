module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Direct implementation of the minimized logic
assign q = a | b | c;

endmodule