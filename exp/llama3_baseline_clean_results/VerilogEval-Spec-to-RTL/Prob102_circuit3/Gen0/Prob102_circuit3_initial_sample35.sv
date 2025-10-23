module TopModule(
    input  a,
    input  b,
    input  c,  // This input is not used in the implementation
    input  d,
    output q
);

assign q = a & b | a & d | b;

endmodule