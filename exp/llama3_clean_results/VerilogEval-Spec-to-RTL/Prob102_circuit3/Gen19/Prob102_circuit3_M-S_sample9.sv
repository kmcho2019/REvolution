module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    assign q = (b & d) | (a & c & d) | (a & b & c) | (a & b & d);
    
endmodule