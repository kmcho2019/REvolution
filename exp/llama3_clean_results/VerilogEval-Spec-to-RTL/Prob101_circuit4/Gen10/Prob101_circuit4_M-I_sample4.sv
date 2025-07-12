module TopModule(
    input  a,
    input  b,
    input  c,
    output q
);

assign q = a || b || c;

endmodule