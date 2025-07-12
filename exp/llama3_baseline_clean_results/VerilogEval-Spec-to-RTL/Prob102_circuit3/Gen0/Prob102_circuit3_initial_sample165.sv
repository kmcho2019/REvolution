module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = (b & c) | (b & d) | (c & d) | (a & b) | (a & c) | (a & d);

endmodule