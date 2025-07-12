module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // q is high when either b or c is high
    assign q = b | c;
endmodule