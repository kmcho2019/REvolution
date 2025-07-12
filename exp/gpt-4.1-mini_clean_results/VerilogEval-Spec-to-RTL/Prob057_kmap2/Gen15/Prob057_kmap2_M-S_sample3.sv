module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    assign out = (~a & ~d)
               | (a & ~b & c)
               | (~a & b & ~c)
               | (b & c & d)
               | (~b & ~c & ~d);

endmodule