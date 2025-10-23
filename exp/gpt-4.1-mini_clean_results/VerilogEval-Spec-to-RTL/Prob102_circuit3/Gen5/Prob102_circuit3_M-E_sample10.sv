module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire p, r;

    assign p = ~(a | b);  // NOR of a and b
    assign r = ~(c | d);  // NOR of c and d
    assign q = ~(p | r);  // NAND of p and r
endmodule