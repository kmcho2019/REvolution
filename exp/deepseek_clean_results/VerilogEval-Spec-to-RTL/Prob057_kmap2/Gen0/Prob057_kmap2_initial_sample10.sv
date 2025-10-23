module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~a & ~d) | (~b & ~c) | (b & c) | (a & ~b & d) | (~a & b & c);
endmodule