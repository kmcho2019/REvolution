module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = (a & d) | (b & d) | (a & b) | (a & c) | (b & c) | (c & d);

endmodule