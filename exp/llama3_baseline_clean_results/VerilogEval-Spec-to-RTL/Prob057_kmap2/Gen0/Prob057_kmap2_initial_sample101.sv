module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    assign out = (d) | (~a & ~b) | (~a & ~c) | (~b & c);
endmodule