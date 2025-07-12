module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~a & ~b) | (a & ~b) | (~a & c & ~d) | (b & c & d);
endmodule