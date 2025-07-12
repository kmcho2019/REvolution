module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Alternative implementation using a combination of basic logical operators
    // The expression ~(a ^ b ^ c ^ d) is functionally equivalent to the following:
    assign q = ~(a ^ b) == ~(c ^ d);
    
endmodule