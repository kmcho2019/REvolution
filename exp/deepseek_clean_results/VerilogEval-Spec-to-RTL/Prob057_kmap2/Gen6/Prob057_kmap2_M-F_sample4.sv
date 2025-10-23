module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~a & ~b) | (~a & ~d) | (~b & ~c) | (b & ~c & d) | (a & ~b & c) | (a & b & ~d);

endmodule