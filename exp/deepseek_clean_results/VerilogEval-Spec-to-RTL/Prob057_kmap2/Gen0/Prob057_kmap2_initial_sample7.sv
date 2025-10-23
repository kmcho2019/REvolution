module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    assign out = (~c & ~d) | (~a & ~d) | (~b & d) | (a & b & c);
endmodule