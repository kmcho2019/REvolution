module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output wire q
);
    // q is high when b or c is high, a and d have no effect
    assign q = b | c;
endmodule