module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Intermediate pairwise XNOR operations
    wire ab_xnor = (a & b) | (~a & ~b);
    wire cd_xnor = (c & d) | (~c & ~d);
    
    // Final XNOR of intermediate results
    assign q = (ab_xnor & cd_xnor) | (~ab_xnor & ~cd_xnor);
endmodule