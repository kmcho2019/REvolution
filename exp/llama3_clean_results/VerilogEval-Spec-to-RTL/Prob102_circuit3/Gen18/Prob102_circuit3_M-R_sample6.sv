module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Compute the OR of a and b, and the OR of c and d
    assign or_ab = a | b;
    assign or_cd = c | d;
    
    // Compute the output q based on the OR results
    assign q = or_ab & or_cd;
    
endmodule