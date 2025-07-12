module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = (b & d) | (a & d) | (a & b) | (b & c);

endmodule