module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Directly compute the output q using the simplified logic
    assign q = (a | b) & (c | d);
endmodule