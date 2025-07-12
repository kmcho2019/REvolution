module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~a & ~b) | (~b & c & d) | (a & ~b & ~c) | (~a & c & d);

endmodule