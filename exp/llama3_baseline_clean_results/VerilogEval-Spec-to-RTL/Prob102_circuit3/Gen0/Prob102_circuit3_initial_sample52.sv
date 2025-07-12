module TopModule(
    input a,
    input b,
    input c, // This input does not affect the output q
    input d,
    output q
);

assign q = b | (a & d);

endmodule