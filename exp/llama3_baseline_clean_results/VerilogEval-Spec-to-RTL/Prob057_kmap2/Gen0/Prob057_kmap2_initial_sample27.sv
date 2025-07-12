module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    assign out = (~a & ~b) | (b & c) | (~a & b & ~c) | (~a & c & d);
endmodule