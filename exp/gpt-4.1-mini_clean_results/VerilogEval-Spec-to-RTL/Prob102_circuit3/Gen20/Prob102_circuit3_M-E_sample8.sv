module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    assign q = (a | b) ? (c | d) : 1'b0;

endmodule