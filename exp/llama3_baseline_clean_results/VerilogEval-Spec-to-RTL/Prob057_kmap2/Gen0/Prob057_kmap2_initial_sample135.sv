module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~a & ~b) | (~b & ~c & ~d) | (~a & c & ~d) | (a & b & c & ~d);

endmodule