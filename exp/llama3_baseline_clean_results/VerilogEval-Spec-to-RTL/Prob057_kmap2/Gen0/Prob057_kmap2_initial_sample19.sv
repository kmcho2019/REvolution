module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (a | b) & (~c | ~d) | (c & d & b);

endmodule