// Improved solution directly implementing the simplified logic expression
module TopModuleImproved(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Direct implementation of the simplified logic expression
    assign q = (a | b) & (c | d);
    
endmodule