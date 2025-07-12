module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~a & ~b & ~d) | (~a & ~c & ~d) | (a & ~b & ~c) | (b & c) | (b & ~d);

endmodule