module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (a & d) | (~a & ~c) | (b & ~c & ~d) | (b & d & ~c);

endmodule