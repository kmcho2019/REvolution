module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & ~d) | (~a & ~d) | (a & ~d) | (a & b & d) | (~b & c & d);

endmodule