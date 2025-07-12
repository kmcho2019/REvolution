module TopModule(
    input  a,
    input  b,
    input  c,  // not used in this implementation
    input  d,
    output q
);

assign q = a | b | (~a & ~b & d);

endmodule