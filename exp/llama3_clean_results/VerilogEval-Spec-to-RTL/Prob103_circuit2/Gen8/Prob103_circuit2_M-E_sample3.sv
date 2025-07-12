module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire parity;
    
    assign parity = (a ^ b ^ c ^ d);
    assign q = ~parity;
endmodule