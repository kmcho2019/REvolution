module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (a & b & ~d) | (~a & ~c & ~d) | (~c & b) | (a & ~d & c);

endmodule