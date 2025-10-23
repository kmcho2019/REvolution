module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the output q directly using assign statements
    assign q = (a | b) & (c | d);
    
endmodule