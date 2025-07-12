module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    
    assign out = (b & ~c) | (~c & a) | (c & b);
    
endmodule