module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = (a & d) | (b & d) | (c & d) | (b & c) | (a & b) | (a & c);

endmodule