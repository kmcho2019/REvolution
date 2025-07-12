module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

assign q = (~a & ~b) | (~c & d) | (a & ~c) | (a & d) | (b & d) | (~b & c & d);

endmodule