module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // Although d does not affect the output, it's included as per the problem statement
    output q
);

assign q = a || b || c;

endmodule