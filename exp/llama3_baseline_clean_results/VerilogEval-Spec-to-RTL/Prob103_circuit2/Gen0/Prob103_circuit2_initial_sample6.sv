module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = (a ^ d) ^ (b ^ c);

endmodule