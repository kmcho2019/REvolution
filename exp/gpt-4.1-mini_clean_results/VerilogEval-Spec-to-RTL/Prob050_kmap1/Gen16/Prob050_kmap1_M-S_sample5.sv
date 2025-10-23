module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    assign out = (b | c) | (~b & ~c & a);
endmodule