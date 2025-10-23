module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = b | (~b & ~a & ~c) | (~b & c);

endmodule