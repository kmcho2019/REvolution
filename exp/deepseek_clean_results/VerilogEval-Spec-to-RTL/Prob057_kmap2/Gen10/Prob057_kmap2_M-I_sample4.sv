module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & ~d) | (~a & ~d) | (b & c & d) | (a & ~b & ~d);

endmodule