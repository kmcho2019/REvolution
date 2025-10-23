module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~a & ~b) | (~a & b & ~d) | (a & ~b & ~c) | (b & c & d);
endmodule