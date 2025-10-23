module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~a & ~b) | (~a & b & ~d) | (a & ~b & ~c) | (c & d & (a | b));
endmodule