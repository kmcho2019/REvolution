module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the output q using a single logical expression
    assign q = (a | b) & (c | d);
    
endmodule